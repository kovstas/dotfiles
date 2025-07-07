echo "Installing Dependencies"
brew install --cask sf-symbols
brew install jq
brew install gh
brew install lua
brew install switchaudio-osx
brew install nowplaying-cli
brew tap FelixKratz/formulae
brew install sketchybar

brew install --cask font-jetbrains-mono-nerd-font
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.25/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

if [ -d "$HOME/.config/sketchybar" ]; then
  cp -r $HOME/.config/sketchybar $HOME/.config/sketchybar_backup
fi
ln -s sketchybar $HOME/.config/sketchybar
brew services restart sketchybar
