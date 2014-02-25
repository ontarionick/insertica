Gem::Specification.new do |s|
  s.name        = "insertica"
  s.version     = "0.0.4"
  s.date        = Time.now
  s.summary     = "A simple tool to insert data into Vertica."
  s.description = "A simple tool to insert data into Vertica. Currently only supports JSON data."
  s.author      = "Nick Evans"
  s.files       = Dir['lib/**/*.rb']
  s.executables << 'insertica'
  s.license     = "MIT"

  s.add_runtime_dependency('vertica', '~> 0.11.1')
  s.add_runtime_dependency('thor',    '~> 0.18.1')

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
  s.add_development_dependency('pry')
end