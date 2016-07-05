
Pod::Spec.new do |s|


  s.name         = "HLAlertController"
  s.version      = "1.0.0"
  s.summary      = "alert to replace system alert"
  s.description  = <<-DESC
	alert to replace system alert. very easy to use.
                   DESC

  s.homepage     = "https://github.com/JustString/HLAlertController"
  # s.screenshots  = "https://github.com/JustString/HLAlertController/blob/master/snap1.PNG", "https://github.com/JustString/HLAlertController/blob/master/snap2.PNG"

  s.license      = "MIT"
  s.author             = { "StringZhao" => "497492762@qq.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/JustString/HLAlertController.git", :tag => "1.0.0" }
  s.source_files  = "HLAlertController/*.{h,m}"
  s.framework  = "UIKit", "Foundation"
  s.requires_arc = true

end
