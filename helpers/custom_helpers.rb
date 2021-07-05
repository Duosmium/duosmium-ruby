# frozen_string_literal: true

require 'color_contrast_calc'
require 'miro'

# Methods used in templates
# https://middlemanapp.com/basics/helper-methods/
module CustomHelpers
  STATES_BY_POSTAL_CODE ||= {
    AK: 'Alaska',
    AZ: 'Arizona',
    AR: 'Arkansas',
    CA: 'California',
    nCA: 'Northern California',
    sCA: 'Southern California',
    CO: 'Colorado',
    CT: 'Connecticut',
    DE: 'Delaware',
    DC: 'District of Columbia',
    FL: 'Florida',
    GA: 'Georgia',
    HI: 'Hawaii',
    ID: 'Idaho',
    IL: 'Illinois',
    IN: 'Indiana',
    IA: 'Iowa',
    KS: 'Kansas',
    KY: 'Kentucky',
    LA: 'Louisiana',
    ME: 'Maine',
    MD: 'Maryland',
    MA: 'Massachusetts',
    MI: 'Michigan',
    MN: 'Minnesota',
    MS: 'Mississippi',
    MO: 'Missouri',
    MT: 'Montana',
    NE: 'Nebraska',
    NV: 'Nevada',
    NH: 'New Hampshire',
    NJ: 'New Jersey',
    NM: 'New Mexico',
    NY: 'New York',
    NC: 'North Carolina',
    ND: 'North Dakota',
    OH: 'Ohio',
    OK: 'Oklahoma',
    OR: 'Oregon',
    PA: 'Pennsylvania',
    RI: 'Rhode Island',
    SC: 'South Carolina',
    SD: 'South Dakota',
    TN: 'Tennessee',
    TX: 'Texas',
    UT: 'Utah',
    VT: 'Vermont',
    VA: 'Virginia',
    WA: 'Washington',
    WV: 'West Virginia',
    WI: 'Wisconsin',
    WY: 'Wyoming'
  }.freeze

  IMAGES_PATH ||= Pathname.new(__dir__) + '..' + 'source' + 'images'

  # gets the newest matching logo with year less than tournament year
  def find_logo_path(filename)
    tournament_year = filename[0...4].to_i
    tournament_name = filename[11..-3]
    get_year = ->(image) { image[/^[0-9]+/].to_i }

    Pathname.new('../images/logos/') +
    Dir.children(IMAGES_PATH + 'logos')
       .select { |image| image.include? tournament_name }
       .select { |i| filename.end_with? i.split('.').first[/_[abc]$/].to_s }
       .append('default.jpg')
       .select { |image| get_year.call(image) <= tournament_year }
       .max_by { |image| get_year.call(image) + image.length / 100.0 }
       .dup # string may be frozen
  end

  def find_bg_color(filename)
    colors = Miro::DominantColors
              .new((IMAGES_PATH + find_logo_path(filename)).to_s)
              .to_hex
    # String#paint from the chroma gem
    color = colors[3] ? colors[3].paint : colors.first.paint
    color = color.darken while ColorContrastCalc.contrast_ratio("#f5f5f5", color.to_hex) <= 4.5
    color
  end

  def trophy_and_medal_colors
    %w[
      #ffee58
      #cfd8dc
      #d8bf99
      #ffefc0
      #dcedc8
      #eeccff
      #fdd5b4
      #d4f0f1
      #ffc8db
      #dab9d1
      #e5e5e5
      #e5e5e5
      #e5e5e5
      #e5e5e5
      #e5e5e5
      #f4f4f4
      #f4f4f4
      #f4f4f4
      #f4f4f4
      #f4f4f4
    ]
  end

  def trophy_and_medal_css(trophies, medals)
    trophy_and_medal_colors.map.with_index do |color, i|
      [
        ("td.event-points[data-points='#{i+1}'] div" if i < medals),
        ("td.event-points-focus[data-points='#{i+1}'] div" if i < medals),
        ("div#team-detail tr[data-points='#{i+1}']" if i < medals),
        ("td.rank[data-points='#{i+1}'] div" if i < trophies)
      ].compact.join(',') + "{background-color: #{color};border-radius: 1em;}"
    end.join
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
      "#{t_info.state.gsub('sCA', 'SoCal').gsub('nCA', 'NorCal')} State Tournament"
    when 'Regionals', 'Invitational'
      if t_info.short_name.nil?
        cut = t_info.level[0..-1] if t_info.level == "Regionals" else t_info.level
        splits = t_info.name.split(cut, 2)[0]
        "#{splits} #{cut}#{' Tournament' if cut == 'Regional'}"
      end
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
      abbr_school(team.school_abbreviation)
    else
      abbr_school(team.school)
    end
  end

  def abbr_school(school)
    school.sub('Elementary School', 'Elementary')
          .sub('Elementary/Middle School', 'E.M.S.')
          .sub('Middle School', 'M.S.')
          .sub('Junior High School', 'J.H.S.')
          .sub(%r{Middle[ /-]High School}, 'M.H.S')
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
      (t.date.strftime if t.date.is_a?(Date)),
      (t.date.strftime('%A') if t.date.is_a?(Date)),
      (t.date.strftime('%B') if t.date.is_a?(Date)),
      (t.date.strftime('%-d') if t.date.is_a?(Date)),
      (t.date.strftime('%Y') if t.date.is_a?(Date)),
      (t.start_date.strftime if t.start_date.is_a?(Date)),
      (t.start_date.strftime('%A') if t.start_date.is_a?(Date)),
      (t.start_date.strftime('%B') if t.start_date.is_a?(Date)),
      (t.start_date.strftime('%-d') if t.start_date.is_a?(Date)),
      (t.start_date.strftime('%Y') if t.start_date.is_a?(Date)),
      (t.end_date.strftime if t.end_date.is_a?(Date)),
      (t.end_date.strftime('%A') if t.end_date.is_a?(Date)),
      (t.end_date.strftime('%B') if t.end_date.is_a?(Date)),
      (t.end_date.strftime('%-d') if t.end_date.is_a?(Date)),
      (t.end_date.strftime('%Y') if t.end_date.is_a?(Date))
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

  def summary_titles
    %w[
      Champion
      Runner-up
      Third-place
      Fourth-place
      Fifth-place
      Sixth-place
    ]
  end

  def sup_tag(placing)
    exempt = placing.exempt? || placing.dropped_as_part_of_worst_placings?
    tie = placing.tie? && !placing.points_limited_by_maximum_place?
    return '' unless tie || exempt

    "<sup>#{'◊' if exempt}#{'*' if tie}</sup>"
  end

  def bids_sup_tag(team)
    return '' unless team.earned_bid?

    "<sup>✧</sup>"
  end

  def bids_sup_tag_note(tournament)
    next_tournament = if tournament.level == 'Regionals'
                        "#{tournament.state.gsub('sCA', 'SoCal').gsub('nCA', 'NorCal')} State Tournament"
                      else
                        "National Tournament"
                      end
    qualifiee = tournament.bids_per_school > 1 ? 'team' : 'school'
    "Qualified #{qualifiee} for the #{tournament.year} #{next_tournament}"
  end

  def group_by_schools(interpreters)
    interpreters
      .values
      .flat_map { |i| i.teams.map {|t| full_school_name(t) } }
      .uniq
      .sort_by { |t| t.downcase.tr('^A-Za-z0-9', '') }
      .map do |s|
      [
        s,
        interpreters.keys.map do |k|
          teams = interpreters[k].teams.select {|t| full_school_name(t) == s }
          next if teams.empty?

          [k, teams.map(&:rank).sort.map(&:ordinalize)]
        end.compact.to_h
      ]
    end.to_h
  end

  def csv_schools(interpreters)
    CSV.generate do |csv|
      interpreters
        .values
        .flat_map { |i| i.teams.map {|t| [t.school, t.city, t.state] }}
        .uniq
        .sort_by { |t| [t[0], t[1].nil? ? '' : t[1], t[2]] }
        .each { |row| csv << row }
    end
  end

  def csv_events(interpreters)
    CSV.generate do |csv|
      interpreters
        .values
        .flat_map { |i| i.events.map {|e| [e.name] }}
        .uniq
        .sort
        .each { |row| csv << row }
    end
  end

  def placing_notes(placing)
    place = placing.place
    points = placing.isolated_points
    [
      ('trial event' if placing.event.trial?),
      ('trialed event' if placing.event.trialed?),
      ('disqualified' if placing.disqualified?),
      ('did not participate' if placing.did_not_participate?),
      ('participation points only' if placing.participation_only?),
      ('tie' if placing.tie?),
      ('exempt' if placing.exempt?),
      ('points limited' if placing.points_limited_by_maximum_place?),
      ('unknown place' if placing.unknown?),
      ('placed behind exhibition team'\
       if placing.points_affected_by_exhibition? && place - points == 1),
      ('placed behind exhibition teams'\
       if placing.points_affected_by_exhibition? && place - points > 1),
      ('dropped'\
       if placing.dropped_as_part_of_worst_placings?),
    ].compact.join(', ').capitalize
  end

  def teams_to_states(interpreter)
    states = []
    interpreter.teams.each do |t|
      states.append(t.state)
    end
    states.uniq
  end
end
