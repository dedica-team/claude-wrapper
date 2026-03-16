# Claude Wrapper

Claude in a container to restrict its filesystem access.

## Usage

To use the wrapper, start the `bin/claudew` script in your project directory.

If you use `claudew` often, you may consider adding the `bin` directory to your `$PATH`.

### Additional Behavior

Per default, `claudew` will continue the latest conversation for your project.
Override that behavior by passing "--new-session" as a parameter.


## claudew Development

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