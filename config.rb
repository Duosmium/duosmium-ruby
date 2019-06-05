# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

require 'miro'

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

Dir.new(Pathname.new(__dir__) + 'data')
  .children
  .select { |f| f.end_with?(".yaml") }
  .map { |f| f.delete_suffix(".yaml") }
  .each do |t|
  proxy "/results/#{t}.html", "/results/template.html",
    locals: { tournament: t }, ignore: true
end

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do
  STATES_BY_POSTAL_CODE = {
    AK: 'Alaska ',
    AZ: 'Arizona ',
    AR: 'Arkansas ',
    CA: 'California ',
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
  }
  def find_logo_path(filename)
    image_dir = Dir.new(Pathname.new(__dir__) + 'source' + 'images' + 'logos')
    potential_logos = [
      filename + '.png',
      filename + '.jpg',
      filename.split('_')[0..-2].join('_') + '.png', # remove _b or _c suffix
      filename.split('_')[0..-2].join('_') + '.jpg', # remove _b or _c suffix
      filename.split('_')[0..-2].join('_') + '.gif', # remove _b or _c suffix
      filename.split('_')[1..-2].join('_') + '.png', # remove date as well
      filename.split('_')[1..-2].join('_') + '.jpg', # remove date as well
      filename.split('_')[1..-2].join('_') + '.gif'  # remove date as well
    ]
    potential_logos.concat(%w[
      default.jpg
    ].shuffle)
    '/images/logos/' + potential_logos.find { |l| image_dir.children.include? l }
  end

  def find_bg_color(path)
    filename = path.delete_prefix('results/').delete_suffix('.html')
    logo_file_path = (Pathname.new(__dir__) +
                      'source' +
                      find_logo_path(filename).delete_prefix('/')).to_s
    colors = Miro::DominantColors.new(logo_file_path)
    colors.to_hex[3]
  end

  def expand_state_name(postal_code)
    STATES_BY_POSTAL_CODE[postal_code.to_sym]
  end
end

activate :external_pipeline,
  name: :webpack,
  command: build? ? './node_modules/webpack/bin/webpack.js --bail' : './node_modules/webpack/bin/webpack.js --watch -d',
  source: "dist",
  latency: 1

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
