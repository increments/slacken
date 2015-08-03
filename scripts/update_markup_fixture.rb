require 'slacken'

fixture_dir = File.expand_path('../spec/fixtures', __dir__)

File.write(
  File.join(fixture_dir, 'markup_text.txt'),
  Slacken.translate(File.read(File.join(fixture_dir, 'example.html')))
)
