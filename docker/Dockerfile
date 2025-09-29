FROM jenkins/agent

USER root

RUN apt-get update && apt-get install -y build-essential cmake cppcheck valgrind clang-tidy qt6-base-dev

# COPY your-favorite-tool-here

USER jenkins

RUN mkdir -p ~/.ssh/ && ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts

CMD ["bash"] # Docker image CMD must either be empty or simply sit and wait forever, e.g. /bin/bash