Gem::Specification.new do |spec|
  spec.name          = 'imagesite'
  spec.version       = '1.0.0'
  spec.author        = 'Dave Schweisguth'
  spec.email         = 'dave@schweisguth.org'

  spec.summary       = %q{iPhoto-style web export for Photos}
  spec.description   = %q{OS X's iPhoto software had a feature that exported photos to a static web site. iPhoto was discontinued in 2015. Its replacement, Photos, does not have that feature. imagesite approximates that feature.}
  spec.homepage      = 'https://github.com/dschweisguth/imagesite'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(.gitignore|.idea/|.rspec|spec/)}) }
  spec.bindir	       = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.required_ruby_version = '~> 2.0'

  spec.add_runtime_dependency 'exifr', '>= 1.2.4'
  spec.add_runtime_dependency 'xmp', '>= 0.2.0'
  spec.add_runtime_dependency 'image_science', '>= 1.3.0'
  spec.add_runtime_dependency 'erubis', '>= 2.7.0'

  spec.add_development_dependency 'bundler', '>= 1.12.5'
  spec.add_development_dependency 'rake', '>= 0.9.6'
  spec.add_development_dependency 'rspec', '>= 3.5.0'
  spec.add_development_dependency 'capybara', '>= 2.7.1'
  spec.add_development_dependency 'simplecov', '>= 0.11.2'

end
