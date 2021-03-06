def from_page(url, pattern)
  page = shell("curl #{url}")
  version_matches = page.match pattern
  version_matches[1]
end

def bundle_version(path, key)
  IO.read(path / 'Contents/Info.plist').xml_val_for(key)
end

app 'Dropbox.app' do
  # no https support yet!
  source 'https://www.dropbox.com/downloading?os=mac'
  latest_version { from_page 'https://www.dropbox.com/install', /<span>\s*(\S*)\s*for\s*/ } #0.7.110
  current_version { |path| bundle_version path, 'CFBundleVersion' } #0.7.110
end

app 'Skitch.app' do
  source 'http://get.skitch.com/skitch-beta.dmg'
  # can't get the latest version anywhere
  current_version { |path| bundle_version(path, 'CFBundleVersion').split(' ').first } #1.0b8.6 (v2520)
end

app 'Sofortbild.app' do
  # can't process DMG inside of zip
  source 'http://www.sofortbildapp.com/download/Sofortbild.dmg.zip'
  latest_version { from_page 'http://www.sofortbildapp.com', /Download Sofortbild ([^<]*)/ }
  current_version { |path| bundle_version(path, 'CFBundleShortVersionString') }
end

app 'Skype.app' do
  source 'http://www.skype.com/go/getskype-macosx.dmg'
  latest_version { from_page 'http://www.skype.com/download/skype/macosx/', /<title>Skype (\S*) / }
  current_version { |path| bundle_version(path, 'CFBundleShortVersionString').split('.')[0..1].join('.') }
end

app 'Transmission.app' do
  source L{ "http://mirrors.m0k.org/transmission/files/Transmission-#{version}.dmg" }
  latest_version { from_page 'http://www.transmissionbt.com/download.php', /The current release version is <b>(.*)<\/b>/ } #1.92
  current_version { |path| bundle_version path, 'CFBundleShortVersionString' } #1.92
end

app 'Twitterrific.app' do
  source L { "http://iconfactory.com/assets/software/twitterrific/Twitterrific_#{version.gsub('.', '')}.zip" }
  latest_version { from_page 'http://iconfactory.com/software/twitterrific', /Download: Twitterrific (\S*)</ } 
  current_version { |path| bundle_version(path, 'CFBundleVersion') }
end

app 'pomodoro.app' do
  source L { "http://pomodoro.ugolandini.com/pages/downloads_files/pomodoro-#{version}.zip" }
  latest_version { from_page 'http://www.apple.com/downloads/macosx/development_tools/pomodoro.html', /<h2>Pomodoro\s*(\S*)</ }
  current_version { |path| bundle_version(path, 'CFBundleVersion') }
end

app 'Quicksilver.app' do
  source L {
    file = from_page 'http://github.com/tiennou/blacktree-alchemy/downloads', /href="(.*tar\.gz)"/
    "http://github.com#{file}"
  }
  latest_version { from_page 'http://github.com/tiennou/blacktree-alchemy/downloads', /Quicksilver-.*-(\d*)\.tar\.gz/ }
  current_version { |path| bundle_version(path, 'CFBundleVersion') }
end

app 'GitX.app' do
  source 'http://frim.frim.nl/GitXStable.app.zip'
  latest_version { from_page 'http://gitx.frim.nl/release_history.html', /<h1>v(.*)</ } #0.7
  current_version { |path| bundle_version(path, 'CFBundleShortVersionString') } #0.7.1
end

app 'Colloquy.app' do
  source 'http://colloquy.info/downloads/colloquy-latest.zip'
  latest_version { from_page 'http://colloquy.info/downloads.html', /<h1.*Colloquy (.*) \(/ }
  current_version { |path| bundle_version(path, 'CFBundleShortVersionString') } 
end

app 'VLC.app' do
  source L { "http://www.videolan.org/mirror-geo.php?file=vlc/#{version}/macosx/vlc-#{version}.dmg" }
  latest_version { from_page 'http://www.videolan.org/vlc/download-macosx.html', /<h2>.*release (.*)\)/ }
  current_version { |path| bundle_version(path, 'CFBundleShortVersionString') }
end

# - VLC
# - Sequel Pro
# - Jolly's fast VNC
# - Mactheripper
# - OmmWriter
# - Openoffice
# - Firefox

# - Urban Terror
# - Chromium
# - Gimp

dep 'macbook' do
  [
    'Skype.app',
    'Transmission.app'
  ].each { |dependency| requires dependency }
end

