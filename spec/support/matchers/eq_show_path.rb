RSpec::Matchers.define :eq_show_path do |expected|
  match do |actual|
    url_helpers = Rails.application.routes.url_helpers
    regex = url_helpers.send(expected, 1).sub('1', '\d')
    expect(actual).to match(regex)
  end
end
