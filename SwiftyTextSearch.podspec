#
#  Be sure to run `pod spec lint SwiftyTextSearch.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SwiftyTextSearch"
  s.version      = "1.0.0"
  s.summary      = "SuperFast Text Search/Suggestion engine written in Swift."

  s.description  = <<-DESC

* Pre-processes the keyword strings to make searching faster.
* Add / Delete Strings anytime
* Search results are prioritized based on number of matches
* Can detect few mistakes and give the most probable output (Beta)


                   DESC
  s.homepage     = "https://github.com/sheshans/SwiftyTextSearch"
  s.license      = "MIT"
  s.author       = { "Sheshans Yadav" => "sheshans.r.yadav@gmail.com" }
  s.platform     = :ios, "8.0"
  
  s.source       = { :git => "https://github.com/sheshans/SwiftyTextSearch.git", :tag => "1.0.0" }
  s.source_files = "SwiftyTextSearch", "SwiftyTextSearch/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
