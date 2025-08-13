FROM ubuntu:22.04

ARG PYTHON_VERSION
ARG GO_VERSION
ARG USER vscode

LABEL version 0.3.0
LABEL maintainer crownless@me.com

ENV debian_frontend noninteractive
ENV TZ "Europe/Moscow"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH "${PATH}:/usr/local/go/bin"
ENV GOARCH=arm64 
ENV GOOS=linux

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
  python${PYTHON_VERSION}-venv \
  pipenv \
  pipx \
  sqlite3 \
  nginx \
  ansible

RUN apt clean && rm -rf /var/lib/apt/lists/*
# install python and various useful linters
RUN pipx install ruff && pipx install mypy
# install golang
WORKDIR /tmp
RUN curl -O https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
RUN rm -rf /usr/local/go
RUN tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
