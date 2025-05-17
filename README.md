# GitVoyager

GitVoyager is a lightweight command-line tool that allows users to search, list, and download files or entire folders from GitHub repositories efficiently. Designed with simplicity in mind, it's a great solution for users who want to interact with GitHub repositories without cloning the entire repo.

---

## Features

- **Search**: Look for specific files or folders in a GitHub repository.
- **List**: Display all contents of a repository in a JSON format.
- **Download**: Fetch individual files or entire folders directly to your local machine.
- **Easy Configuration**: Set up your GitHub token and repository details in a simple config file.
- **Lightweight**: No need to clone repositories; just grab what you need!
- **Docker Support**: Run GitVoyager in a lightweight containerized environment.

---

## Installation

Clone the repository and set up the tool:

```bash
git clone https://github.com/rizitis/GitVoyager.git
cd GitVoyager
bash install.sh
```

Last command will place GitVoyager in $HOME/.local/bin/ (Please make sure that it is in your $USER $PATH)

---

## Setup

1. **Generate a GitHub Token**:
   - Go to your GitHub account settings → Developer settings → Personal Access Tokens → Tokens (classic).
   - Generate a token with `repo` scope for accessing public repositories.

2. **Configure `gitv.conf`**:
   Use the `gitv setup` command to open the configuration file for editing:
   ```bash
   gitv setup
   ```
   Update the file with your token and repository details:
   ```
   TOKEN_FILE_PATH="$HOME/.config/github_token.txt"
   REPO_OWNER="your-github-username"
   REPO_NAME="target-repo-name"
   BRANCH="main"
   LOC_DIR="$HOME/GitV_WORK"
   ```

3. **Save Your Token**:
   Place your GitHub token in the file you specified in `TOKEN_FILE_PATH`.


---

## Usage

- **Fetch Initial Data**:
   ```bash
   gitv fetch
   ```

- **List Repository Contents**:
   ```bash
   gitv list
   ```

- **Search for a File or Folder**:
   ```bash
   gitv search <file_name>
   ```

- **Download a File**:
   ```bash
   gitv get <file_name>
   ```

- **Download a Folder**:
   ```bash
   gitv get <folder_name>
   ```

### Example:
To download the `ffmpeg` folder and all its contents:
```bash
gitv get ffmpeg
```

---

## Help

If you command `gitv help`:
```
> gitv help

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
 Then edit /home/user/.local/bin/GitVoyager/gitv.conf and add you token.
 In gitv.conf also add github project name etc, as and the local dir path for download files.

Usage: gitv <command> [<file>]
Commands:
  get <file_name>  - Download from github file_name to /home/user/GitV_WORK.
  search <file_name>   - Search if file exist in remote and print info.
  list               - Print all contents of remote in a json file format.
  fetch               - This command create the first database and also update database if exist
  setup               - This command will open gitv.conf for edit, using your system default text editor

  help               - Display this help message
  uninstall          - Uninstall gitv and delete all file but not /home/user/GitV_WORK
```

---

## Docker Support

**NOTE: DOCKER SUPPORT IS IN Alpha stage still in Developer status!!!** <br>

You can run GitVoyager in a Docker container for an isolated and lightweight setup. Follow these steps:

> **DOCKER NOTE**:
>
> If you prefer docker-compose, please read
>
> [DOCKER_COMPOSE_USAGE_Version3.md](./DOCKER_COMPOSE_USAGE_Version3.md)


### Step 1: 
In the terminal, navigate to the GitVoyager project directory.

### Step 2: Build the Docker Image
Run:
```bash
docker build -t gitvoyager .
```

### Step 3: Create Configuration and Download Directories
Create directories on your local machine for the configuration file and downloaded files:
```bash
mkdir -p $(pwd)/config
mkdir -p $(pwd)/downloads
```

### Step 4: Edit the Configuration File
Create a `gitv.conf` file in the `config` directory and add your GitHub token and repository details:
```bash
nano $(pwd)/config/gitv.conf
```
Add the following content (replace placeholders with your details):
```
TOKEN_FILE_PATH="/config/github_token.txt"
REPO_OWNER="your-github-username"
REPO_NAME="target-repo-name"
BRANCH="main"
LOC_DIR="/downloads"
```

### Step 5: Run the Docker Container
Run the container, mounting the configuration and downloads directories:
```bash
docker run --rm -it \
    -v $(pwd)/config:/config \
    -v $(pwd)/downloads:/downloads \
    gitvoyager
```

### Step 6: Use GitVoyager
Inside the container, you can now use all the `gitv` commands (e.g., `fetch`, `list`, `get`).

### Step 7: Persist Downloads
All downloaded files will be saved to your local `downloads` directory, as it’s mounted to `/downloads` in the container.

 
---

## Notes

- The `gitv setup` command will use your system's default text editor to open the configuration file for editing.
- This tool respects your GitHub token permissions. Only provide the minimum scopes (e.g., `read` and `download`).
- For private repositories, ensure your token has the necessary permissions.

---

## Contribution

Feel free to fork the repository, suggest changes, or submit pull requests for improvements. Contributions are always welcome!

---

## License

This project is licensed under the [MIT License](LICENSE).
