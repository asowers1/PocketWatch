#!/bin/sh
# project_fetch: A script for fetching a project and its dependencies.
# written by Noah Blake, copyright Fuzz Productions LLC, Feb. 2013

USER_HOME=$(eval echo ~${SUDO_USER})

function install_pod_gem {
  if [ -d "$USER_HOME/.cocoapods" ];
    then
      echo "Cocoapods is installed."
    else
	  echo "Cocoapods is not installed. Installingspo."
	  sudo gem install cocoapods
  fi
}

function install_fuzz_podspec_repo {
  if [ -d "$USER_HOME/.cocoapods/repos/podspecs" ];
    then
     echo "Fuzz spec repo is installed."
    else
     echo "Fuzz spec repo is installed. Installing."
     PODSPEC_DIRECTORY = "$USER_HOME/.cocoapods/repos/podspecs"
     git clone git@gitlab.fuzzhq.com:ios-modules/podspecs.git "$PODSPEC_DIRECTORY"
  fi
}

function install_project {
	echo "Enter the project repo URL found on gitlab.fuzzhq.com. For example, git@gitlab.fuzzhq.com:ios-modules/podspecs.git"
	read project_repo_url  
	substring_length=${#project_repo_url}-4
	project_directory="$USER_HOME/Desktop/${project_repo_url:0:substring_length}"
	git clone "$project_repo_url" "$project_directory"
	project_subdirectory="$(dirname "$(find "$project_directory" -name ".git")")"
	cd "$project_subdirectory"
	pwd
	pod install
	git submodule init
	git submodule update
}

install_pod_gem
install_fuzz_podspec_repo
install_project

exit

