#! /bin/bash

# Setup username
username="rdness"
gitUsername="rdness"
gitEmail="orderofmoti@gmail.com"

home="/home/$username"


# Get repo of configuration files
echo "Creating directory: repos"
if [ ! -d "$home/repos" ]; then
	mkdir repos
fi
# --- Check if git is Installed
if [[ -z `command -v git` ]]; then
	echo "git not installed. Installing git"
	sudo apt-get install git

	git config --global user.email $getEmail
	git config --global core.editor vim
fi
# --- get directories from git
cd repos
if [ ! -d "$home/repos/aliases" ]; then
	echo "--- Cloning aliases repo"
	git clone https://github.com/rdness/aliases.git
fi
if [ ! -d "$home/repos/vimrc" ]; then
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
# ----- Link vimrc to home directory
if [ ! -f "$home/.vimrc" ]; then
	ln -s $home/repos/vimrc/vimrc $home/.vimrc

	mkdir $home/.vim
	mkdir $home/.vim/backup
	mkdir $home/.vim/tmps
	
	ln -s $home/repos/vimrc/templates $home/.vim/templates
fi

# --- Setup bashrc
os=`uname -s`

case "$os" in
	Linux)
		osDir="linux"

		echo "----- Copying bashrc"	
		mv .bashrc .bashrc_old
		ln -s $home/repos/aliases/$osDir/bashrc $home/.bashrc
		;;
	Darwin)
		osDir="mac"
	
		echo "----- Copying profile"
		mv .profile .profile_old
		ln -s $home/repos/aliases/$osDir/profile $home/.profile
		;;
	CYGWIN*)
		osDir="cygwin"
	
		echo "----- Copying bashrc"
		mv .bashrc .bashrc_old
		ln -s $home/repos/aliases/$osDir/bashrc $home/.bashrc
		;;
esac

# --- Setup bash_aliases
		echo "----- Copying backup script: .bar.pl"
ln -s $home/repos/aliases/$osDir/bar.pl $home/.bar.pl
		echo "----- Copying bash alias script: .ba.sh"
ln -s $home/repos/aliases/$osDir/ba.sh $home/.ba.sh
		echo "----- Copying aliases file: .bash_aliases"
ln -s $home/repos/aliases/$osDir/bash_aliases $home/.bash_aliases

source $home/.bashrc

cp $home/repos/aliases/common/bash_paths_template $home/.bash_paths
touch $home/.work_aliases
touch $home/.bash_vars

# Setup Libraries directory
echo "Creating directory: Libraries"
if [ ! -d "/home/$username/Libraries" ]; then
	mkdir Libraries
fi



