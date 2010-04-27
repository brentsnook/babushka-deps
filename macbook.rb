require 'rubygems'
require 'nokogiri'

def from_page(url, pattern)
  download_page = shell("curl #{url}")
  version_matches = download_page.match pattern
  version_matches[1]
end

def bundle_short_version(path)
  full_version = IO.read(path / 'Contents/Info.plist').xml_val_for('CFBundleShortVersionString')
  major_minor_version = full_version.split('.')[0..1].join('.')
end
    
app 'Skype.app' do
  source 'http://www.skype.com/go/getskype-macosx.dmg'
  latest_version { from_page 'http://www.skype.com/download/skype/macosx/', /<title>Skype (\S*) / }
  current_version { |path| bundle_short_version path }
end

app 'Transmission.app' do
  source L{ "http://mirrors.m0k.org/transmission/files/Transmission-#{version}.dmg" }
  latest_version { from_page 'http://www.transmissionbt.com/download.php', /The current release version is <b>(.*)<\/b>/ }
  current_version { |path| bundle_short_version path }
end

dep 'macbook' do
  [
    'Skype.app',
    'Transmission.app'
  ].each { |dependency| requires dependency }
end

