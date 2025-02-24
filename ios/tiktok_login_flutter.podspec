#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tiktok_login_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tiktok_login_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Tiktok login for flutter'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TikTokOpenSDKCore', '~> 2.5.0'
  s.dependency 'TikTokOpenAuthSDK', '~> 2.5.0'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.static_framework = true
#  s.preserve_paths = 'TikTokOpenSDK.TikTokOpenSDK.framework'
#  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework TikTokOpenSDK.TikTokOpenSDK.framework' }
#  s.vendored_frameworks = 'TikTokOpenSDK.TikTokOpenSDK.framework'
end
