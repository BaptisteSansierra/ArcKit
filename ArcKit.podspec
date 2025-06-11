#
#  Be sure to run `pod spec lint ActivityPulseBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "ArcKit"
  spec.version      = "1.0"
  spec.summary      = "Lightweight Swift library for drawing animated arcs and circles — perfect for loaders, progress indicators, and scanner UIs."

  spec.description  = <<-DESC
ArcKit is a lightweight and flexible Swift library for creating animated arcs and circular visuals.
Ideal for building easily custom loaders, progress indicators, scanner-style or random UI components.
                   DESC

  spec.homepage     = "git@github.com:BaptisteSansierra/ArcKit.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "Baptiste Sansierra" => "baptiste.sansierra@gmail.com" }
  spec.ios.deployment_target = '12.0'
  spec.swift_version = '5.0'
  spec.source           = { :git => 'git@github.com:BaptisteSansierra/ArcKit.git', :tag => spec.version.to_s }
  spec.source_files = 'ArcKit/Lib/*', 'ArcKit/TrialViews/*'
  spec.frameworks = 'UIKit'

end


