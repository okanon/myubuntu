#!/bin/bash

sudo apt update
sudo apt -y upgrade

# install utils
sudo apt -y install tree net-tools git vim curl fish \
                    neofetch openssh-server speedtest-cli \
                    psensor ffmpeg mysql-server ddclient
                    
# ssh config
mkdir ~/.ssh
chmod 700 ~/.ssh
cp src/ssh/ssh.config ~/.ssh/config

# fish Settings
mkdir -p ~/.config/fish
cp src/config/fish/config.fish ~/.config/fish/

if [ $DESKTOP_SESSION = "plasma" ]; then #KDE
   LANG=C xdg-user-dirs-update --force
   ls $HOME | grep -E [亜-熙ぁ-んァ-ヶ] | xargs -I@ rm -rf $HOME/@
   
   # Konsole Settings
   sudo cp src/local/share/konsole/Lisa.colorscheme /usr/share/konsole
   cp src/config/konsolerc $HOME/.config/
   
   # install KDE themes
   sudo apt -y install latte-dock

else # GNOME 
   LANG=C xdg-user-dirs-gtk-update
fi

# set default shell
chsh
sudo chsh

# install fonts
curl -OL https://github.com/vjpr/monaco-bold/raw/master/MonacoB/MonacoB.otf
curl -OL https://github.com/vjpr/monaco-bold/raw/master/MonacoB2/MonacoB2.otf
sudo mkdir /usr/share/fonts/Monaco
sudo mv Monaco* /usr/share/fonts/Monaco
fc-cache -f

# install checkra1n
echo "deb https://assets.checkra.in/debian /" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --fetch-keys https://assets.checkra.in/debian/archive.key
sudo apt update
sudo apt install checkra1n

# install python packages
sudo apt -y install python-dev python3-dev python3-testresources

# install pip
curl -kL https://bootstrap.pypa.io/get-pip.py | sudo python
curl -kL https://bootstrap.pypa.io/get-pip.py | sudo python3

# install solaar (logicool mouse controller)
git clone https://github.com/pwr-Solaar/Solaar && cd Solaar
sudo python3 setup.py install ; cd ..
sudo rm -rf Solaar

# install c cpp runtime
sudo apt -y install gcc-10 g++-10 gccgo-10 gfortran-10
sudo apt -y install make automake flex bison zlib1g-dev \
                    z3 libssl-dev libcurl4-openssl-dev \
                    gettext libncurses-dev liblua5.3-dev
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
                         --slave /usr/bin/g++ g++ /usr/bin/g++-10 \
                         --slave /usr/bin/gccgo gccgo /usr/bin/gccgo-10 \
                         --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-10

# install chrome
curl -OL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt -y --fix-broken install
rm -f google-chrome-stable_current_amd64.deb

# install jdk
sudo apt -y install openjdk-11-jdk openjdk-14-jdk
sudo update-java-alternatives -s java-1.11.0-openjdk-amd64

# install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt update
sudo apt -y install sbt

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup install --force stable
rustup install --force beta
rustup install --force nightly

# install exa
git clone https://github.com/ogham/exa
cd exa && make
sudo mv target/release/exa /usr/local/bin ; cd ..
rm -rf exa

# install nodejs & npm
sudo apt -y install nodejs npm
sudo npm install -g n
sudo n latest
sudo npm install -g npm
sudo apt -y purge nodejs npm
sudo chown -R $USER /usr/local/{lib/node_modules,bin,share}

# install npm software
npm install -g @angular/cli bagbak yarn

# install vim, colorscheme & dein.vim
mkdir -p ~/.vim/colors ~/.vim/syntax
git clone https://github.com/NLKNguyen/papercolor-theme
cp papercolor-theme/colors/PaperColor.vim ~/.vim/colors/
rm -rf papercolor-theme

cp src/vimrc ~/.vimrc
cp src/vim/syntax/scala.vim ~/.vim/syntax/

mkdir -p ~/.vim/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.vim/dein
mv installer.sh ~/.vim

# install coc.nvim
mkdir -p ~/.vim/toml
cp src/vim/toml/dein.toml ~/.vim/toml/
