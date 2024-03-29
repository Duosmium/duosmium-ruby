# frozen_string_literal: true

require 'sciolyff/interpreter'

ignore '/results/placeholder.html'
ignore '/results/template.html'
ignore '/results/schools_template.html'

if (comp = ENV['RESULT_TO_BUILD'])
  ignore '/results/index.html'
  ignore '/results/schools.html'
  ignore '/results/schools.csv'
  ignore '/results/events.csv'
  filename = comp.to_sym
  proxy "/results/#{filename}.html",
        '/results/template.html',
        locals: { i: SciolyFF::Interpreter.new(@app.data.to_h[filename]) }
  return
end

if (num = ENV['MIN_BUILD'])
  ignore '/results/index.html'
  ignore '/results/schools.html'
  ignore '/results/schools.csv'
  ignore '/results/events.csv'
  num = num.empty? ? 1 : num.to_i
  @app.data.recents[0...num].each do |recent|
    filename = recent.delete_suffix('.yaml').to_sym
    proxy "/results/#{filename}.html",
          '/results/template.html',
          locals: { i: SciolyFF::Interpreter.new(@app.data.to_h[filename]) }
  end
  return
end

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

interpreters = {}

@app.data.to_h.each do |filename, tournament|
  next unless filename.to_s.start_with?(/[0-9]/)

  interpreters[filename.to_s] = SciolyFF::Interpreter.new(tournament)
end

interpreters = interpreters.sort_by do |_, i|
  [Date.new(2019, 10, 17) - i.tournament.start_date,
   i.tournament.state,
   i.tournament.location,
   i.tournament.division]
end.to_h

page '/results/index.html', locals: { interpreters: interpreters, officials: @app.data.official }
page '/results/schools.html'
page '/results/schools.csv', locals: { interpreters: interpreters }
page '/results/events.csv', locals: { interpreters: interpreters }

# strip trailing whitespace from CSV files
after_build do |builder|
  base = File.join(config[:build_dir], 'results')
  builder.thor.gsub_file File.join(base, 'schools.csv'), /\s+\Z/, ''
  builder.thor.gsub_file File.join(base, 'events.csv' ), /\s+\Z/, ''
end

return if ENV['INDEX_ONLY']

fsn = -> (t) { [t.school, t.city ? "(#{t.city}, #{t.state})" : "(#{t.state})"].join(" ") }
schools = interpreters
    .values
    .flat_map { |i| i.teams.map {|t| fsn.call(t) } }
    .uniq
    .sort_by { |t| t.downcase.tr('^A-Za-z0-9', '') }
    .reduce({}) {
      |acc, school|
        if acc[school[0].downcase].nil?
          then acc[school[0].downcase] = [school]
          else acc[school[0].downcase] << school
        end
        acc
    }
    .map do |letter, schools|
      [
        letter,
        schools.map do |s|
          [
            s,
            interpreters.keys.map do |k|
              teams = interpreters[k].teams.select {|t| fsn.call(t) == s }
              next if teams.empty?

              [k, teams.map(&:rank).sort.map(&:ordinalize)]
            end.compact.to_h
          ]
        end.to_h
      ]
    end.to_h

schools.each do |l, s|
  proxy "/results/schools/#{l}.html",
        '/results/schools_template.html',
        locals: { interpreters: interpreters, schools: s, letter: l, letters: schools.keys }
end

interpreters.each do |filename, interpreter|
  proxy "/results/#{filename}.html",
        '/results/template.html',
        locals: { i: interpreter, official: (@app.data.official.include? filename) }
end

data.official.each do |info|
  next if interpreters.key?(info)

  proxy "/results/#{info}.html",
        '/results/placeholder.html',
        locals: { t: info }
end

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :external_pipeline,
         name: :webpack,
         command: if build?
                    'yarn run webpack --bail'
                  else
                    'yarn run webpack --watch -d'
                  end,
         source: '.tmp/dist',
         latency: 1
