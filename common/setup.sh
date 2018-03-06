#! /bin/bash

# Setup git parameters
gitUsername=""
gitEmail=""
gitCoreEditor=""

# Get repo of configuration files
echo "Creating directory: repos"
if [ ! -d "$HOME/repos" ]; then
	mkdir repos
fi

# --- Check if git is Installed
if [[ -z `command -v git` ]]; then
	echo "git not installed. Installing git"
	sudo apt-get install git
fi

# --- Setup Git preferences
git config --global user.email $gitEmail
git config --global core.editor $gitCoreEditor

# --- get directories from git
cd repos
if [ ! -d "$HOME/repos/aliases" ]; then
	echo "--- Cloning aliases repo"
	git clone https://github.com/rdness/aliases.git
fi
if [ ! -d "$HOME/repos/vimrc" ]; then
	echo "--- Cloning vimrc repo"
	git clone https://github.com/rdness/vimrc
fi
cd ~

# --- Setup vim
# ----- Check if vim is Installed
if [[ -z `command -v vim` ]]; then
	echo "vim not installed. Installing vim"
	sudo apt-get install vim
fi
# ----- Link vimrc to HOME directory
if [ ! -f "$HOME/.vimrc" ]; then
	ln -s $HOME/repos/vimrc/vimrc $HOME/.vimrc

	mkdir $HOME/.vim
	mkdir $HOME/.vim/backup
	mkdir $HOME/.vim/tmps
	
	ln -s $HOME/repos/vimrc/templates $HOME/.vim/templates
fi

# --- Setup bashrc
os=`uname -s`

case "$os" in
	Linux)
		osDir="linux"

		echo "----- Copying bashrc"	
		mv .bashrc .bashrc_old
		ln -s $HOME/repos/aliases/$osDir/bashrc $HOME/.bashrc
		;;
	Darwin)
		osDir="mac"
	
		echo "----- Copying profile"
		mv .profile .profile_old
		ln -s $HOME/repos/aliases/$osDir/profile $HOME/.profile
		;;
	CYGWIN*)
		osDir="cygwin"
	
		echo "----- Copying bashrc"
		mv .bashrc .bashrc_old
		ln -s $HOME/repos/aliases/$osDir/bashrc $HOME/.bashrc
		;;
esac

# --- Setup bash_aliases
		echo "----- Copying backup script: .bar.pl"
ln -s $HOME/repos/aliases/$osDir/bar.pl $HOME/.bar.pl
		echo "----- Copying bash alias script: .ba.sh"
ln -s $HOME/repos/aliases/$osDir/ba.sh $HOME/.ba.sh
		echo "----- Copying aliases file: .bash_aliases"
ln -s $HOME/repos/aliases/$osDir/bash_aliases $HOME/.bash_aliases

source $HOME/.bashrc

cp $HOME/repos/aliases/common/bash_paths_template $HOME/.bash_paths
touch $HOME/.work_aliases
touch $HOME/.bash_vars

# Setup Libraries directory
echo "Creating directory: Libraries"
if [ ! -d "$HOME/Libraries" ]; then
	mkdir Libraries
fi



