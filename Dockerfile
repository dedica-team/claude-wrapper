FROM ubuntu:24.04
LABEL authors="dedica GmbH"

RUN apt-get update && apt-get install -y curl jq less git

ENV CLAUDE_HOME="/home/claude"
RUN useradd --create-home --shell /bin/bash --home-dir ${CLAUDE_HOME} claude
USER claude

# Add the Claude binary location to the path.
ENV PATH=${CLAUDE_HOME}/.local/bin:${PATH}
ARG CLAUDE_VERSION="2.1.72"
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
CMD ["bash", "-c", "cd ${PROJECT_DIRECTORY} && claude ${ADDITIONAL_CLAUDE_ARGUMENTS}"]
