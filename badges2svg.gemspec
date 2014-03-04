require './lib/badges2svg'

Gem::Specification.new do |s|
    s.name          = 'badges2svg'
    s.version       = BadgesToSVG.version
    s.date          = Time.now

    s.summary       = 'Replace GitHub PNG badges into SVG ones'
    s.description   = 'Parse a markdown file and replace PNG badges with SVG ones.'
    s.license       = 'MIT'

    s.author        = 'Baptiste Fontaine'
    s.email         = 'b@ptistefontaine.fr'
    s.homepage      = 'https://github.com/bfontaine/badges2svg'

    s.files         = ['lib/badges2svg.rb']
    s.test_files    = Dir.glob('tests/*tests.rb')
    s.require_path  = 'lib'
    s.executables  << 'badges2svg'

    s.add_runtime_dependency 'trollop', '~>2.0'

    s.add_development_dependency 'simplecov', '~>0.8'
    s.add_development_dependency 'rake', '~>10.1'
    s.add_development_dependency 'test-unit', '~>2.5'
    s.add_development_dependency 'coveralls', '~>0.7'
end
