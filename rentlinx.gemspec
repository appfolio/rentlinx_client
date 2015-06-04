require_relative 'lib/rentlinx/version'

Gem::Specification.new do |s|
  s.author = 'AppFolio, Inc.'
  s.email = 'bryce.boe@appfolio.com'
  s.files = Dir.glob('lib/**/*') + %w(LICENSE.txt README.md)
  s.homepage = 'https://github.com/appfolio/rentlinx_client'
  s.license = 'Simplified BSD'
  s.name = 'rentlinx'
  s.post_install_message = 'Thanks for installing!'
  s.summary = 'API Wrapper for '
  s.version = Rentlinx::VERSION
end
