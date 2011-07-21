require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = 'aeolus-orch'
  s.version = '0.1.0'
  s.summary = 'Library For Handling Aeolus Deployables'
  s.description = s.summary
  s.author = 'Mark McLoughlin'
  s.email = 'markmc@redhat.com'
  s.files = %w(Rakefile) + Dir.glob("lib/**/*")
  s.require_path = "lib"

  s.add_dependency('nokogiri', '>= 1.4.3')
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end
