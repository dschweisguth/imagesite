Gem::Specification.new do |spec|
  spec.name          = 'imagesite'
  spec.version       = '1.0.2'
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

  spec.add_runtime_dependency 'exifr', '>= 1.3.3'
  spec.add_runtime_dependency 'xmp', '>= 0.2.0'
  spec.add_runtime_dependency 'image_science', '>= 1.3.0'
  spec.add_runtime_dependency 'erubis', '>= 2.7.0'

  spec.add_development_dependency 'bundler', '>= 1.12.5'
  spec.add_development_dependency 'rake', '>= 12.3.0'
  spec.add_development_dependency 'rspec', '>= 3.7.0'
  spec.add_development_dependency 'capybara', '>= 2.16.1'
  spec.add_development_dependency 'simplecov', '>= 0.15.1'

  # The following are not directly required by this gem but are directly or indirectly required by capybara.
  # They are here so they can be constrained to versions compatible with the lowest supported version of Ruby.
  spec.add_development_dependency 'public_suffix', '~> 2.0'
  spec.add_development_dependency 'rack', '~> 1.6' # required by capybara
  spec.add_development_dependency 'rack-test', '~> 0.7.0' # required by capybara

end
