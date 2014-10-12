# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby/libvirt/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-libvirt"
  spec.version       = Ruby::Libvirt::VERSION
  spec.authors       = ["Yukihiro Matsumoto"]
  spec.email         = ["libvir-list@redhat.com"]
  spec.summary       = %q{Ruby support for libvirt}
  spec.description   = %q{Use libvirt from ruby.}
  spec.homepage      = "http://libvirt.org/ruby/documentation.html"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
