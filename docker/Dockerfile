FROM jenkins/agent

USER root

RUN apt-get update && apt-get install -y \
    # build tools
    build-essential cmake \
    # build dependencies
    qt6-base-dev \
    # analysis tools
    cppcheck valgrind clang-tidy \
    # robot framework requires python
    python3 python3-venv

USER jenkins

RUN mkdir -p ~/.ssh/ && ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts

CMD ["bash"] # Docker image CMD must either be empty or simply sit and wait forever, e.g. /bin/bash