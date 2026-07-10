# Claude Wrapper

Claude in a container to restrict its filesystem access.

## Usage

To use the wrapper, start the `bin/claudew` script in your project directory.

If you use `claudew` often, you may consider adding the `bin` directory to your `$PATH`.

### Additional Behavior

#### Access to `.env` files denied

`.env` files in the project directory are overlaid within the container
to ensure that Claude cannot read them.

#### Automatically resume session

Per default, `claudew` will continue the latest conversation for your project.
Override that behavior by passing `--new-session` as a parameter:

```bash
claudew --new-session
```

#### Access container

Pass `--bash` to access the container Claude is running in.
E.g. useful to check, which tools and commands are available.

```bash
claudew --bash
```

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

Rebuild an image with a specific Claude version:
```bash
CLAUDE_VERSION=2.1.74 && docker build --build-arg "CLAUDE_VERSION=${CLAUDE_VERSION}" --tag "claudew:${CLAUDE_VERSION}" .
```

Access container:
```bash
docker run --interactive --tty claudew bash
```


## Further Resources

- [Configure Claude Permissions](https://code.claude.com/docs/en/permissions#permission-rule-syntax)
- [SDKMan Installation](https://sdkman.io/install/)
