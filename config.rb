# frozen_string_literal: true

require 'sciolyff/interpreter'

ignore '/results/placeholder.html'
ignore '/results/template.html'

if (num = ENV['MIN_BUILD'])
  ignore '/results/index.html'
  num = num.empty? ? 1 : num.to_i
  @app.data.recents[0...num].each do |recent|
    filename = recent.delete_suffix('.yaml').to_sym
    proxy "/results/#{filename}.html",
          '/results/template.html',
          locals: { i: SciolyFF::Interpreter.new(@app.data.to_h[filename]) }
  end
  return
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

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

interpreters = {}

@app.data.to_h.each do |filename, tournament|
  next unless filename.to_s.start_with?(/[0-9]/)

  interpreters[filename.to_s] = SciolyFF::Interpreter.new(tournament)
end

interpreters.each do |filename, interpreter|
  proxy "/results/#{filename}.html",
        '/results/template.html',
        locals: { i: interpreter }
end

interpreters = interpreters.sort_by do |_, i|
  [Date.new(2019, 10, 17) - i.tournament.date,
   i.tournament.state,
   i.tournament.location,
   i.tournament.division]
end.to_h

page '/results/index.html', locals: { interpreters: interpreters }

data.upcoming.each do |info|
  next unless info.key?(:file) && !interpreters.key?(info[:file])

  proxy "/results/#{info[:file]}.html",
        '/results/placeholder.html',
        locals: { t: info }
end
