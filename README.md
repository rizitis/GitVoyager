# GitVoyager
Is your personal git package manager. Explore your github repo  and download from cli any file or folder/subfolder without clone all repo loccaly.<br>
Only requirement in a Linux system is jq and and a personal github api access token.<br>

## Install
Just clone or download GitVoyager and command `bash install.sh` (no sudo , no root). That will place GitVoyager in $HOME/.local/bin/<br>

## SetUp
0. If you used `install.sh` you are fine, else note that all **GitVoyager** files must stay in the same folder but a copy of the gitv script must be out of parrent folder. Example: `$PATH/{gitv,GitVoyager}`
1. Create (if you dont have) a [github token.](https://github.com/settings/tokens) <br>
Paste your token in plain.txt file and place file in a safe hidden dir of your system. Assume: `/home/user/.config/github_token.txt`<br>
2. GitVoyager has a conf file stored in.   `$HOME/.local/bin/GitVoyager/gitv.conf`
After installation finish you must edit `gitv.conf`. <br>
Open it with a text editor or command: `gitv setup`

```
######################-github_token-############################
# Add here the path of your github_token.txt                   #
# Example: TOKEN_FILE_PATH="$HOME"/.config/github_token.txt    #
################################################################
TOKEN_FILE_PATH=

###############################-GitHub-##########################################
# Set the GitHub API URL                                                        #
# Examples:                                                                     #
#GITHUB_API="https://api.github.com/repos"                                      #
#REPO_OWNER="rizitis"  # Change this to your GitHub username                    #
#REPO_NAME="One4All_SlackBuild"   # Change this to your GitHub repository name  #
#BRANCH="main"                # Change if necessary                             #
#################################################################################
GITHUB_API="https://api.github.com/repos"
REPO_OWNER=
REPO_NAME=
BRANCH=

##########################-LOCAL DOWNLOAD DIR-###########################
# LOC_DIR is the local folder where files from github will downloaded   #
# Example: LOC_DIR="$HOME"/GitV_WORK                                    #
#########################################################################
LOC_DIR=
```

3. Next step is the command `gitv fetch`<br>
This will create the first database of your remote repo localy so gitv will now know where to search for remote files. This command also update database.<br>
This is the end of setup.

## Usage
If you command `gitv help` will print all you need<br>
```

_____ _ ___      __
/ ____(_) \ \    / /
| |  __ _| |\ \  / /__  _   _  __ _  __ _  ___ _ __
| | |_ | | __\ \/ / _ \| | | |/ _` |/ _` |/ _ \ '__|
| |__| | | |_ \  / (_) | |_| | (_| | (_| |  __/ |
\_____|_|\__| \/ \___/ \__, |\__,_|\__, |\___|_|
                       __/ |       __/ |
                      |___/       |___/


The gitv command lets you download any file or folder from github.
First you must have a valid github personal access token.
Then edit "$HOME/.local/bin/GitVoyager/gitv.conf" and add you token.
In gitv.conf also add github project name etc, as and the local dir path for download files.

Usage: gitv <command> [<file>]
Commands:
get <file_name>  - Download from github file_name to LOC_DIR.
search <file_name>   - Search if file exist in remote and print info.
list               - Print all contents of remote in a json file format.
fetch               - This command create the first database and also update database if exist

help               - Display this help message
uninstall          - Uninstall gitv and delete all file but not LOC_DIR
```

examples:<br> `gitv get folder_name` <br> `gitv get file_name`


## Dont forget!
1. Dont give permission to your token that not needed. You only need to read and download...
2. GitVoyager is for personal use, so interact only when needed with your projetcs. Its not a game...(respect github API).
3. Dont ran gitv as root.
4. This is personal work in progress, feel free to modify it for your needs ;)
