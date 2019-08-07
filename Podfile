# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'RealmToDoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RealmToDoApp
  pod 'RealmSwift'

  target 'RealmToDoAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

  target 'RealmToDoAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '4.2'
  end
end

end
