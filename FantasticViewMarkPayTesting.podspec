Pod::Spec.new do |s|
  s.name             = 'FantasticViewMarkPayTesting'
  s.version          = '0.2.3'
  s.summary          = 'By far the most fantastic view I have seen in my entire life. No joke.'
 
  s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
                       DESC
 
  s.homepage         = 'https://github.com/markcardamis/FantasticView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mark' => 'mark.cardamis@paydock.com' }
  s.source           = { :git => 'https://github.com/markcardamis/FantasticView.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'FantasticView/**/*.{h,m}', 'FantasticView/**/*.swift'
  s.resources = 'FantasticView/Assets.xcassets', 'FantasticView/**/*.xib'
  s.resource_bundles = {
      'FantasticView' => [
          'FantasticView/**/*.{xib,xcassets,json,imageset,png}'
      ]
  }
  s.exclude_files = 'FantasticView/ViewController.swift'
end