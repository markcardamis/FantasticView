Pod::Spec.new do |s|
  s.name             = 'FantasticViewMarkPayTesting'
  s.version          = '0.3.5'
  s.summary          = 'By far the most fantastic view I have seen in my entire life. No joke.'
 
  s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
                       DESC
 
  s.homepage         = 'https://github.com/markcardamis/FantasticView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mark' => 'mark.cardamis@paydock.com' }
  s.source           = { :git => 'https://github.com/markcardamis/FantasticView.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.2'
  s.source_files = 'FantasticView/**/*.{h,m}', 'FantasticView/**/*.swift'
  s.resources = 'FantasticView/Assets.xcassets', 'FantasticView/**/*.xib', 'FantasticView/Info1.plist'
  s.resource_bundles = {
      'FantasticViewMarkPayTesting' => [
          'FantasticView/**/*.{xib,xcassets,json,imageset,png,plist}'
      ]
  }
  s.exclude_files = 'FantasticView/ViewController.swift'
end