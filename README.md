# Alef Union Reverse Proxy

## Install

1. Setup an REHL server with SSH key access for `root`.
2. Run the `deploy.sh` script:
   ```sh
   ./deploy.sh
   ```
3. When prompted, type the remote address (IP or hostname) of the server.
4. When prompted, write the `/etc/reverseproxy/hostmap` file.
   Example:
   ```
   alefunion.com		localhost:8000
   api.alefunion.com	localhost:8001
   ```

To deploy a new version of `reverseproxy`, rerun `deploy.sh`.

Place other servers under `/srv/PROJECT_NAME`.

## Update hostmap

1. Edit `/etc/reverseproxy/hostmap`:
   ```
   vi /etc/reverseproxy/hostmap
   ```
2. Restart service:
   ```
   sudo systemctl restart reverseproxy
   ```
