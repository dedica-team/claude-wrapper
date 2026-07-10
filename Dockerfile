FROM ubuntu:24.04@sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90
LABEL authors="dedica GmbH"

# Use Bash as default shell.
# E.g. important to run SDKMan commands.
SHELL ["bash", "-c"]

RUN apt-get update && apt-get install -y curl wget jq less git zip unzip gh imagemagick ffmpeg golang-go

# Install GitHub CLI (gh) tool
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && mkdir -p -m 755 /etc/apt/sources.list.d \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y

ENV CLAUDE_HOME="/home/claude"
RUN useradd --create-home --shell /bin/bash --home-dir ${CLAUDE_HOME} claude
USER claude

# Ensure that SDKMan and nvm are available in every Bash session.
# Has no effect when the tools have not been installed (yet).
ADD --chown=claude:claude shell-init.sh ${CLAUDE_HOME}/.shell-init.sh
ENV BASH_ENV=${CLAUDE_HOME}/.shell-init.sh

# Install SKDMan to manage Java installations.
# Install script obtained via:
#     curl -s "https://get.sdkman.io?ci=true"
ADD install-sdkman.sh /tmp/install-sdkman.sh
RUN /tmp/install-sdkman.sh
ENV SDKMAN_DIR=${CLAUDE_HOME}/.sdkman
# Install a Java version and some tooling as default.
RUN sdk install java 25.0.2-tem \
    && sdk install maven 3.9.15 \
    && sdk install gradle 9.4.1

# Install nvm to manage Node.js installations.
# Install script obtained via:
#     curl -o install-nvm.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh
ENV NVM_DIR=${CLAUDE_HOME}/.nvm
ADD install-nvm.sh /tmp/install-nvm.sh
RUN PROFILE=${CLAUDE_HOME}/.bashrc bash /tmp/install-nvm.sh \
    && . "${NVM_DIR}/nvm.sh" \
    && nvm install 24.18.0 \
    && nvm alias default 24.18.0
ENV PATH=${NVM_DIR}/versions/node/v24.18.0/bin:${PATH}

# Add the Claude binary location to the path.
ENV PATH=${CLAUDE_HOME}/.local/bin:${PATH}
ARG CLAUDE_VERSION="2.1.200"
ADD install.sh /tmp/install.sh
RUN /tmp/install.sh ${CLAUDE_VERSION}

ENV PROJECT_DIRECTORY=${CLAUDE_HOME}/project
RUN mkdir -p ${PROJECT_DIRECTORY}
WORKDIR ${PROJECT_DIRECTORY}

# Give full permission on the home directory to everybody to ensure
# that the files will even be accessible of another user ID is assigned
# when running the container.
RUN chmod --recursive g+rwx,o+rwx ${CLAUDE_HOME}

# Used to pass additional arguments to Claude.
ENV ADDITIONAL_CLAUDE_ARGUMENTS=""
CMD ["bash", "-c", "claude ${ADDITIONAL_CLAUDE_ARGUMENTS}"]
