# Alef Union Reverse Proxy

## Install

1. Setup an REHL server with SSH key access for `root`.
2. Download the repository on your local machine:
   ```sh
   git clone https://github.com/alefunion/reverseproxy
   ```
3. Run the `deploy.sh` script:
   ```sh
   ./deploy.sh
   ```
4. When prompted, type the remote address (IP or hostname) of the server.
5. When prompted, write the `/etc/reverseproxy/hostmap` file.
   Example:
   ```
   alefunion.com		localhost:8000
   api.alefunion.com	localhost:8001
   ```

To deploy a new version of `reverseproxy`, rerun `deploy.sh`.

Place other servers under `/srv/PROJECT_NAME`.

## Update hostmap

1. Edit `/etc/reverseproxy/hostmap`:
   ```sh
   sudo vi /etc/reverseproxy/hostmap
   ```
2. Restart service:
   ```sh
   sudo systemctl restart reverseproxy
   ```
