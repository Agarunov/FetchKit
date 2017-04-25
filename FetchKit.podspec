Pod::Spec.new do |spec|
  spec.name         = 'FetchKit'
  spec.version      = '1.0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/Agarunov/FetchKit'
  spec.authors      = { 'Anton Agarunov' => 'agarunov.anton@gmail.com' }
  spec.summary      = 'Lightweight Core Data fetch framework'
  spec.source       = { :git => 'https://github.com/Agarunov/FetchKit.git', :tag => "#{spec.version}" }
  spec.module_name  = 'FetchKit'

  spec.ios.deployment_target  = '8.0'
  spec.osx.deployment_target  = '10.9'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'

  spec.source_files = 'Sources/**/*.swift'

  spec.framework = 'CoreData'
end