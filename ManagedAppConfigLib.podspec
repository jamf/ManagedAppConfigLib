Pod::Spec.new do |s|
  s.name         = "ManagedAppConfigLib"
  s.version      = "1.0.0"
  s.summary      = "A facade that simplifies working with Managed App Configuration and Feedback."

  s.description  = <<-DESC
                    The purpose of ManagedAppConfigLib is to make it that much easier to work with Apple's [Managed App Configuration](https://developer.apple.com/library/content/samplecode/sc2279/Introduction/Intro.html) by providing a few convenience methods.
                   DESC

  s.homepage     = "https://appconfig.org/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "James Felton" => "james.felton@jamf.com" }

  s.swift_versions = "5.1"
  s.platform     = :ios, "8.0"
  s.tvos.deployment_target = "10.2"
  s.macos.deployment_target = "11"

  s.source = { :git => "https://github.com/jamf/ManagedAppConfigLib.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/ManagedAppConfigLib/*.{swift}"
end
