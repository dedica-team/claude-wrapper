FROM ubuntu:24.04
LABEL authors="dedica GmbH"

RUN apt-get update && apt-get install -y curl jq

ENV CLAUDE_VERSION="2.1.72"
ADD install.sh /tmp/install.sh
RUN /tmp/install.sh ${CLAUDE_VERSION}

CMD ["bash", "-c", "claude"]
