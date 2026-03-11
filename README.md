# Claude Wrapper

Claude in a container to restrict its filesystem access.

## Development

Update the installation script:
```bash
curl -fsSL https://claude.ai/install.sh > install.sh
chmod +x install.sh
```

Build Docker image:
```bash
docker build . --tag claudew
```

Access container:
```bash
docker run --interactive --tty claudew bash
```