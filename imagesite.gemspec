Gem::Specification.new do |spec|
  spec.name          = 'imagesite'
  spec.version       = '1.0.11'
  spec.author        = 'Dave Schweisguth'
  spec.email         = 'dave@schweisguth.org'

  spec.summary       = %q(iPhoto-style web export for Photos)
  spec.description   = %q(OS X's iPhoto software had a feature that exported photos to a static web site. iPhoto was discontinued in 2015. Its replacement, Photos, does not have that feature. imagesite approximates that feature.)
  spec.homepage      = 'https://github.com/dschweisguth/imagesite'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(.gitignore|.idea/|.rspec|spec/)}) }
  spec.bindir	       = 'bin'
  spec.executables   = spec.files.grep(%r(^bin/)) { |f| File.basename(f) }

  spec.required_ruby_version = '~> 2.3'

  spec.add_runtime_dependency 'exifr', '~> 1.3'
  spec.add_runtime_dependency 'xmp', '~> 2.0'
  spec.add_runtime_dependency 'image_science', '~> 1.3'
  spec.add_runtime_dependency 'erubis', '~> 2.7'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '0.50.0'
  spec.add_development_dependency 'simplecov'

end
