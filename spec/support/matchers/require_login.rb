RSpec::Matchers.define :require_login do |expected|
  match do |actual|
    expect(actual).to redirect_to(login_path)
  end
end
