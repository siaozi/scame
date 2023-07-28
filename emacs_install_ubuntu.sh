sudo apt-get install emacs
sudo apt-get install graphviz mpv ruby git
sudo gem install taskjuggler
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

sudo mkdir ~/.emacs.d/
cd ~/.emacs.d/
sudo git clone https://github.com/siaozi/scame

mkdir ~/.local/share/fonts/
cp ~/.emacs.d/scame/fontPack/* ~/.local/share/fonts/
fc-cache -f -v
cp ~/.emacs.d/scame/init.org ~/.emacs.d/
