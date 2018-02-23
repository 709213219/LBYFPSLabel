Pod::Spec.new do |s|
  s.name      = "LBYFPSLabel"
  s.version   = '1.0.0'
  s.summary   = "LBYFPSLabel"
  s.homepage    = "https://github.com/709213219/LBYFPSLabel"
  s.license   = "MIT"
  s.author    = { "billlin" => "bill1in@163.com" }
  s.source    = { :git => "https://github.com/709213219/LBYFPSLabel.git", :tag => '0.0.1' }
  s.source_files  = "LBYFPSLabel/LBYFPSLabel"
  s.requires_arc  = true
  s.platform    = :ios
  s.ios.deployment_target = '8.0'
end