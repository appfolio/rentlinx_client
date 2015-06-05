require File.expand_path('lib/rentlinx/version', File.dirname(__FILE__))

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

  s.add_runtime_dependency 'httpclient', '~> 2.6.0'
  s.add_runtime_dependency 'json', '~> 1.8'
end
