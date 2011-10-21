require File.join(File.expand_path('lib'), 'hancock', 'version')

Gem::Specification.new do |s|
  s.name = "hancock"
  s.version = Hancock::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Donohoe", "Tim Carey-Smith"]
  s.date = %q{2011-10-20}
  s.description = %q{A gem that provides a Rack based Single Sign On Server in the form of a sintra based OpenID provider}
  s.email = ["atmos@atmos.org", "tim@spork.in"]
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = %w(LICENSE README.md Rakefile) + Dir.glob("{features,lib,spec}/**/*")
  s.homepage = %q{http://github.com/atmos/hancock}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A gem that provides a Rack based Single Sign On Server}

  s.add_runtime_dependency(%q<sinatra>, ["~> 1.0"])
  s.add_runtime_dependency(%q<haml>, ["~> 3.0.0"])
  s.add_runtime_dependency(%q<ruby-openid>, ["~> 2.1.7"])
  s.add_runtime_dependency(%q<guid>, ["~> 0.1.1"])
  s.add_runtime_dependency(%q<rack-contrib>, ["~> 0.9.2"])
  s.add_runtime_dependency(%q<json>, [">= 0"])
end
