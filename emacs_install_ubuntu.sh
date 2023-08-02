sudo apt-get update
sudo apt-get install emacs
sudo apt-get install graphviz mpv ruby git
sudo gem install taskjuggler
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

mkdir ~/.emacs.d/
cd ~/.emacs.d/

mkdir ~/.local/share/fonts/
cp ~/scame/fontPack/* ~/.local/share/fonts/
fc-cache -f -v
cp ~/scame/init.* ~/.emacs.d/
