Pod::Spec.new do |s|
  s.name         = "ManagedAppConfigLib"
  s.version      = "2.0.0"
  s.summary      = "Simplify working with Managed App Configuration and Feedback."

  s.description  = <<-DESC
                    ManagedAppConfigLib makes it easier to work with Apple's [Managed App Configuration](https://developer.apple.com/library/content/samplecode/sc2279/Introduction/Intro.html) by providing a couple property wrappers and an object-based approach.
                   DESC

  s.homepage     = "https://appconfig.org/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Kyle Hammond", "James Felton"

  s.swift_versions = "5.9"
  s.platform     = :ios, "17.0"
  s.tvos.deployment_target = "17.0"
  s.macos.deployment_target = "13.0"

  s.source = { :git => "https://github.com/jamf/ManagedAppConfigLib.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/ManagedAppConfigLib/*.{swift}"
end
