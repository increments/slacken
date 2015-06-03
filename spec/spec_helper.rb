require 'rspec'
require 'markup-translator'

def fixture(name)
  @fixture_cache ||= {}
  @fixture_cache[name] ||= File.read(File.expand_path(name, File.expand_path('fixtures', __dir__)))
end
