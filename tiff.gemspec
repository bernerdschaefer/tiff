# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "tiff"
  s.version     = "0.1"
  s.authors     = ["Bernerd Schaefer"]
  s.email       = ["bj.schaefer@gmail.com"]
  s.homepage    = ""
  s.summary     = "Ruby wrapper for libtiff with FFI"
  s.description = s.summary

  s.add_dependency "ffi"
  s.add_development_dependency "rspec"

  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = "lib"
end
