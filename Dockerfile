FROM ubuntu:24.04

ARG PYTHON_VERSION
ARG GO_VERSION
ARG USER vscode

LABEL version=0.5.0
LABEL maintainer=crownless@me.com

ENV TZ "Europe/Moscow"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH "${PATH}:/usr/local/go/bin:/home/vscode/go/bin:/home/vscode/.local/bin"

RUN groupadd --gid 1001 $USER && \
  useradd -s /bin/bash --uid 1001 --gid $USER -m $USER

RUN mkdir /etc/sudoers.d/ && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get install -y sudo git curl zip vim \
  python${PYTHON_VERSION} \
  pipx \
  sqlite3 \
  nginx \
  ansible

RUN apt clean && rm -rf /var/lib/apt/lists/*
# install python and tools
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
  pipx install ruff && pipx install mypy && pipx install uv

# install golang & golangci-lint
WORKDIR /tmp
RUN curl -O https://dl.google.com/go/go${GO_VERSION}.linux-arm64.tar.gz && \
  rm -rf /usr/local/go && \
  tar -C /usr/local -xzf go${GO_VERSION}.linux-arm64.tar.gz && \
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.4.0 && \
  go version

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
  apt-get install -y nodejs && \
  npm i -g @openai/codex
