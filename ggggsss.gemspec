
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ggggsss/version"

Gem::Specification.new do |spec|
  spec.name          = "ggggsss"
  spec.version       = Ggggsss::VERSION
  spec.authors       = ["takkanm"]
  spec.email         = ["takkanm@gmail.com"]

  spec.summary       = %q{ggggsss is grep command for S3 files.}
  spec.description   = %q{ggggsss is grep command for S3 files.}
  spec.homepage      = "https://github.com/takkanm/ggggsss"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'aws-sdk-s3'
end
