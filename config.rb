# frozen_string_literal: true

require 'miro'
require 'sciolyff'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

interpreters = {}

@app.data.to_h.each do |filename, tournament|
  next if filename == :recents || filename == :upcoming

  interpreters[filename.to_s] = SciolyFF::Interpreter.new(tournament)
end

interpreters.each do |filename, interpreter|
  proxy "/results/#{filename}.html",
        '/results/template.html',
        locals: { i: interpreter },
        ignore: true
end

interpreters = interpreters.sort_by do |_, i|
  [Date.new(2019, 10, 17) - i.tournament.date,
   i.tournament.state,
   i.tournament.location,
   i.tournament.division]
end.to_h

page '/results/index.html', locals: { interpreters: interpreters }

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do
  STATES_BY_POSTAL_CODE = {
    AK: 'Alaska ',
    AZ: 'Arizona ',
    AR: 'Arkansas ',
    CA: 'California ',
    nCA: 'Northern California',
    sCA: 'Southern California',
    CO: 'Colorado ',
    CT: 'Connecticut ',
    DE: 'Delaware ',
    DC: 'District of Columbia',
    FL: 'Florida ',
    GA: 'Georgia ',
    HI: 'Hawaii ',
    ID: 'Idaho ',
    IL: 'Illinois ',
    IN: 'Indiana ',
    IA: 'Iowa ',
    KS: 'Kansas ',
    KY: 'Kentucky ',
    LA: 'Louisiana ',
    ME: 'Maine ',
    MD: 'Maryland ',
    MA: 'Massachusetts ',
    MI: 'Michigan ',
    MN: 'Minnesota ',
    MS: 'Mississippi ',
    MO: 'Missouri ',
    MT: 'Montana ',
    NE: 'Nebraska ',
    NV: 'Nevada ',
    NH: 'New Hampshire ',
    NJ: 'New Jersey ',
    NM: 'New Mexico ',
    NY: 'New York ',
    NC: 'North Carolina ',
    ND: 'North Dakota ',
    OH: 'Ohio ',
    OK: 'Oklahoma ',
    OR: 'Oregon ',
    PA: 'Pennsylvania ',
    RI: 'Rhode Island ',
    SC: 'South Carolina ',
    SD: 'South Dakota ',
    TN: 'Tennessee ',
    TX: 'Texas ',
    UT: 'Utah ',
    VT: 'Vermont ',
    VA: 'Virginia ',
    WA: 'Washington ',
    WV: 'West Virginia ',
    WI: 'Wisconsin ',
    WY: 'Wyoming '
  }.freeze

  # gets the newest matching logo with year less than tournament year
  def find_logo_path(filename)
    tournament_year = filename[0...4].to_i
    tournament_name = filename[11..-3]
    get_year = lambda { |image| image[/^[0-9]+/].to_i }

    Dir.new(Pathname.new(__dir__) + 'source' + 'images' + 'logos')
       .children
       .select { |image| image.include? tournament_name }
       .select { |i| filename.ends_with? i.split('.').first[/_[abc]$/].to_s }
       .append('default.jpg')
       .select { |image| get_year.call(image) <= tournament_year }
       .max_by { |image| get_year.call(image) + image.length / 100.0 }
       .dup  # string may be frozen
       .prepend '../images/logos/'
  end

  def find_bg_color(path)
    filename = path.delete_prefix('results/').delete_suffix('.html')
    logo_file_path = (Pathname.new(__dir__) +
                      'source/images' +
                      find_logo_path(filename).delete_prefix('/')).to_s
    colors = Miro::DominantColors.new(logo_file_path)
    color = colors.to_hex[3].paint # String#paint from the chroma gem

    color = color.darken while color.light?
    color
  end

  def tournament_title(t_info)
    return t_info.name if t_info.name

    case t_info.level
    when 'Nationals'
      'Science Olympiad National Tournament'
    when 'States'
      "#{expand_state_name(t_info.state)} Science Olympiad State Tournament"
    when 'Regionals'
      "#{t_info.location} Regional Tournament"
    when 'Invitational'
      "#{t_info.location} Invitational"
    end
  end

  def tournament_title_short(t_info)
    case t_info.level
    when 'Nationals'
      'National Tournament'
    when 'States'
      "#{t_info.state} State Tournament"
    when 'Regionals', 'Invitational'
      t_info.short_name
    end
  end

  def acronymize(phrase)
    phrase.split(' ')
          .select { |w| /^[[:upper:]]/.match(w) }
          .map { |w| w[0] }
          .join
  end

  def expand_state_name(postal_code)
    STATES_BY_POSTAL_CODE[postal_code.to_sym]
  end

  def format_school(team)
    if team.school_abbreviation
      abbr = abbr_school(team.school_abbreviation)
      "<abbr title=\"#{team.school}\">#{abbr}</abbr>"
    else
      abbr_school(team.school)
    end
  end

  def abbr_school(school)
    school.sub('Elementary School', 'Elementary')
          .sub('Elementary/Middle School', 'E.M.S.')
          .sub('Middle School', 'M.S.')
          .sub('Junior High School', 'J.H.S.')
          .sub('Middle/High School', 'M.H.S')
          .sub('Junior/Senior High School', 'Jr./Sr. H.S.')
          .sub('High School', 'H.S.')
          .sub('Secondary School', 'Secondary')
  end

  def full_school_name(team)
    location = if team.city then "(#{team.city}, #{team.state})"
               else              "(#{team.state})"
               end
    [team.school, location].join(' ')
  end

  def full_team_name(team)
    location = if team.city then "(#{team.city}, #{team.state})"
               else              "(#{team.state})"
               end
    [team.school, team.suffix, location].join(' ')
  end

  def search_string(interpreter)
    t = interpreter.tournament
    words = [
      'science',
      'olympiad',
      'tournament',
      t.name,
      t.short_name,
      t.location,
      t.name ? acronymize(t.name) : nil,
      t.location ? acronymize(t.location) : nil,
      t.level,
      t.level == 'Nationals' ? 'nats' : nil,
      t.level == 'Nationals' ? 'sont' : nil,
      t.level == 'Invitational' ? 'invite' : nil,
      t.state,
      t.state ? expand_state_name(t.state) : nil,
      "div-#{t.division}",
      "division-#{t.division}",
      t.year,
      t.date,
      t.date.strftime('%A'),
      t.date.strftime('%B'),
      t.date.strftime('%-d'),
      t.date.strftime('%Y')
    ]
    words.compact.map(&:to_s).map(&:downcase).join('|')
  end

  def team_attended?(team)
    team
      .placings
      .map(&:participated?)
      .any?
  end

  def rel_link_prefix(current_page_path)
    return './' unless current_page_path.include? '/'

    current_page_path.count('/').times.map { |_| '../' }.join
  end
end

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :external_pipeline,
         name: :webpack,
         command: if build?
                    './node_modules/webpack/bin/webpack.js --bail'
                  else
                    './node_modules/webpack/bin/webpack.js --watch -d'
                  end,
         source: '.tmp/dist',
         latency: 1
