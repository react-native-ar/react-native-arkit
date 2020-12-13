require 'json'
version = JSON.parse(File.read('../package.json'))["version"]

Pod::Spec.new do |s|

  s.name           = "RCTARKit"
  s.version        = version
  s.summary        = "ARKit for react native"
  s.homepage       = "https://github.com/react-native-ar/react-native-arkit"
  s.license        = "MIT"
  s.author         = { "macrozone" => "https://github.com/macrozone" }
  s.platforms      = { :ios => "9.0", :tvos => "9.0" }
  s.source         = { :git => "https://github.com/react-native-ar/react-native-arkit"", :tag => #{s.version}" }
  s.source_files   = '**/*.{h,m}'
  s.preserve_paths = "**/*.js"
  s.dependency 'React'
  s.dependency 'PocketSVG', '~> 2.6'

end