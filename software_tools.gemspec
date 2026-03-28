Gem::Specification.new do |s|
  s.name        = "software-tools-ruby"
  s.version     = "0.1.0"
  s.summary     = "Unix text processing tools — inspired by Software Tools in Pascal (Kernighan & Plauger)"
  s.description = "A collection of classic Unix tools built in Ruby. Use as CLI commands or as a library. Chainable."
  s.authors     = ["yos17"]
  s.email       = "claude_yos@proton.me"
  s.homepage    = "https://github.com/yos17/software-tools-ruby"
  s.license     = "MIT"

  s.files         = Dir["lib/**/*.rb", "bin/*", "README.md"]
  s.executables   = Dir["bin/*"].map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 3.0"
end
