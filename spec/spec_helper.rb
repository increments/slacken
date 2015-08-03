require 'rspec'
require 'slacken'

require 'helpers/document_component_dsl'

def fixture(name)
  File.read(File.join(__dir__, 'fixtures', name))
end

RSpec.configure do |c|
  c.include DocumentComponentDsl, dsl: true
end
