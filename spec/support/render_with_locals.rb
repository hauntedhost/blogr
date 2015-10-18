require 'rspec/expectations'

RSpec::Matchers.define :render_with_locals do |template, locals|
  match do |controller|
    allow(controller).to receive(:render).with no_args
    expect(controller).to receive(:render).with(template, locals: locals)
  end
end
