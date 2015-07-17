require 'rspec'
require 'slacken'

require 'helpers/document_component_dsl'

def fixture(name)
  File.read(File.expand_path(name, File.expand_path('fixtures', __dir__)))
end

RSpec.configure do |c|
  c.include DocumentComponentDsl, dsl: true
end
