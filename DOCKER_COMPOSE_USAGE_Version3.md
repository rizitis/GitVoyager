# Docker Compose Usage for GitVoyager

This guide explains how to use Docker Compose to set up and run the GitVoyager project in a containerized environment.

---

## Prerequisites

Ensure you have the following installed on your system:
- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)

---

## Step 1: Add the `docker-compose.yml` File

Create a `docker-compose.yml` file in the root of your GitVoyager project directory with the following content:

```yaml name=docker-compose.yml
version: "3.9"
services:
  gitvoyager:
    build: .
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    stdin_open: true
    tty: true
```

### Explanation:
- **`version: "3.9"`**: Specifies the version of the Docker Compose file format. Version 3.9 is compatible with the latest Docker Compose features.
- **`services`**: Defines the containers (services) to be run.
- **`gitvoyager`**: The name of the service (container). This can be customized, but it’s good to use meaningful names like `gitvoyager`.
- **`build: .`**: Instructs Docker Compose to build the image using the `Dockerfile` in the current directory (`.`).
- **`volumes`**: Maps local directories to directories inside the container:
  - `./config:/config`: Maps the local `config` folder to `/config` inside the container for configuration files.
  - `./downloads:/downloads`: Maps the local `downloads` folder to `/downloads` inside the container for storing downloaded files.
- **`stdin_open: true` and `tty: true`**: Keeps the container interactive, which is useful for command-line tools like GitVoyager.

---

## Step 2: Set Up Configuration and Downloads Directories

Create the required directories on your local machine:
```bash
mkdir -p $(pwd)/config
mkdir -p $(pwd)/downloads
```

---

## Step 3: Add the Configuration File

Create a `gitv.conf` file in the `config` directory:
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

Save and close the file.

---

## Step 4: Build and Start the Container

Run the following command to build the Docker image and start the container:
```bash
docker-compose up
```

Docker Compose will:
1. Build the Docker image using the `Dockerfile`.
2. Start a container for the `gitvoyager` service.

---

## Step 5: Access the Container

If you need to interact with the container directly, open a terminal and run:
```bash
docker exec -it <container_name> /bin/bash
```

To find the container name, list all running containers:
```bash
docker ps
```

---

## Step 6: Use GitVoyager

Inside the container, you can use the `gitv` commands:
- **Fetch repository data**:
  ```bash
  ./gitv fetch
  ```
- **List repository contents**:
  ```bash
  ./gitv list
  ```
- **Search for a file or folder**:
  ```bash
  ./gitv search <file_name>
  ```
- **Download a file**:
  ```bash
  ./gitv get <file_name>
  ```
- **Download a folder**:
  ```bash
  ./gitv get <folder_name>
  ```

---

## Step 7: Persist Downloads

All files downloaded by GitVoyager will be saved to your local `downloads` directory, as it is mounted to `/downloads` in the container.

---

## Step 8: Stop the Container

When you’re done, stop and clean up the container using:
```bash
docker-compose down
```

---

## Advanced: Using Multiple Compose Files
If you have multiple Compose files (e.g., for development and production), you can specify them with the `-f` option:
```bash
docker-compose -f docker-compose.yml -f docker-compose.override.yml up
```

---

## Notes

- Make sure your `gitv.conf` file is correctly configured with your GitHub token and repository details.
- If you need to customize the environment, you can update the `docker-compose.yml` file accordingly.
- Use `docker-compose logs` to view container logs for debugging.

---

Let me know if you encounter any issues or need further assistance! 🚀
