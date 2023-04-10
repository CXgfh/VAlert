#
# Be sure to run `pod lib lint VAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VAlert'
  s.version          = '1.0.0'
  s.summary          = 'A short description of VAlert.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/CXgfh'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oauth2' => 'gfh.cynthia@icloud.com' }
  s.source           = { :git => 'https://github.com/CXgfh/VAlert', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  
  s.swift_versions = '5.0'

  s.source_files = 'VAlert/Classes/**/*'
  
  s.dependency 'Util_V'
  s.dependency 'ContentSizeView'
  s.dependency 'SnapKit'
end
