Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "ARSoundPlayer"
s.summary = "ARSoundplayer lets you add a mediaplayer to your projects with ease."
s.requires_arc = true

# 2
s.version = "0.1.4"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Ahmed Ramy" => "Dev.AhmedRamy@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/ARamy23/ARSoundPlayer"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/ARamy23/ARSoundPlayer.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.framework = "AVKit"
s.framework = "MediaPlayer"

s.dependency 'SwifterSwift'
s.dependency 'SVProgressHUD'

# 8
s.source_files = "ARSoundPlayer/**/*.{swift}"

# 9
s.resources = "ARSoundPlayer/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.resource_bundles = {
'{ARSoundPlayer}' => ['{ARSoundPlayer}/**/*.xib']
}

# 10
s.swift_version = "4.2"

end
