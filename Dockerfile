FROM ubuntu:22.04

ARG PY_VERSION=3.11
ARG GO_VERSION=1.22.0
ARG USER=vscode

ENV debian_frontend=noninteractive
ENV PATH=$PATH:/usr/local/go/bin

RUN groupadd --gid 1001 $USER && \
  useradd -s /bin/bash --uid 1001 --gid $USER -m $USER

RUN mkdir /etc/sudoers.d/ && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

# install common utils
RUN apt-get update && \
  apt-get install -y \
  curl gcc python$PY_VERSION \
  git make sudo

# install golang
RUN cd /tmp/ && \
  curl -O https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
  rm -rf /usr/local/go && \
  tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
