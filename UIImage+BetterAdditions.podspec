Pod::Spec.new do |s|
  s.name         = "UIImage+BetterAdditions"
  s.version      = "2.0.0"
  s.summary      = "Adding methods to generate dynamically images from colors, borders, adding corner radius, tinting images, etc."

  s.description  = <<-DESC
                   This category of UIImage add methods to generate dynamically images:
           * from colors
           * with borders
           * adding corner radius (for each corner)
           * tinting images,
           * Much more!
           
           Use this category if you want to add "colored style" to your app without having to generate colored graphic resources.
                   DESC

  s.homepage     = "https://github.com/devxoul/UIImage-BetterAdditions"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Suyeol Jeon" => "devxoul@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/devxoul/UIImage-BetterAdditions.git", :tag => "#{s.version}" }
  s.source_files = 'UIImage+BetterAdditions.{h,m}'
  s.framework  = 'UIKit'
  s.requires_arc = true
end