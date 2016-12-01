task default: :test

desc 'Run tests (default)'
task :test do
  Dir.glob('./test/**/*.rb').each { |file| require file }
end

require 'rake'
require 'af_gems/gem_tasks'
require 'af_gems/appraisal'
