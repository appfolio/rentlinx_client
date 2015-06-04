task default: :test

desc 'Run tests (default)'
task :test do
  Dir.glob('./test/**/*.rb').each { |file| require file }
end
