Pod::Spec.new do |spec|
  spec.name = 'SKLocationManager'
  spec.version = '0.0.3'
  spec.license = 'MIT'
  spec.summary = 'A wrapper around CLLocationManager to simplify requesting permission and receiving events.'
  spec.homepage = 'https://github.com/skladek/SKLocationManager'
  spec.authors = { 'Sean Kladek' => 'skladek@gmail.com' }
  spec.source = { :git => 'https://github.com/skladek/SKLocationManager.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.source_files = 'Source/*.swift'
end
