Pod::Spec.new do |s|
  s.name = 'IPAPI'
  s.version = '2.1.0'
  s.license = 'MIT'
  s.summary = 'http://ip-api.com Geolocation API client written in Swift.'
  s.homepage = 'https://github.com/arturgrigor/IPAPI'
  s.social_media_url = 'http://twitter.com/arturgrigor'
  s.authors = { 'Artur Grigor' => 'arturgrigor@gmail.com' }
  s.source = { :git => 'https://github.com/arturgrigor/IPAPI.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*.swift'

  s.requires_arc = true
end
