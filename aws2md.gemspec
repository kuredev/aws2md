# aws2md.gemspec

Gem::Specification.new do |spec|
  spec.name          = "aws2md"
  spec.version       = "0.1.0"
  spec.authors       = ["Akira Kure"]
  spec.email         = ["kuredev@email.com"]

  spec.summary       = "Display AWS CLI output as Markdown tables"
  spec.description   = "Display AWS CLI output as Markdown tables (supports both vertical and horizontal formats)"
  spec.homepage      = "https://github.com/kuredev/aws2md"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + ["exe/aws2md"]
  spec.bindir        = "exe"
  spec.executables   = ["aws2md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "json", ">= 2.0"
  spec.add_dependency "terminal-table", "~> 4.0.0"
  spec.add_dependency "activesupport", "~> 7.1"
end
