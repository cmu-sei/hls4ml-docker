FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

WORKDIR /home

# run apt update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    emacs \
    git \
    python3 \
    python3-pip \
    python3-tk \
    sudo \
    x11-apps

# set up a user
RUN useradd -l -ms /bin/bash hls4ml-user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    adduser hls4ml-user sudo
ARG HLS4MLHOME=/home/hls4ml-user
WORKDIR ${HLS4MLHOME}
USER hls4ml-user

# pytorch-iris needs pytorch and tqdm. other requirements loaded by hls4ml
RUN pip install torch==2.0.1 tqdm && \
    git clone https://github.com/hls-fpga-machine-learning/hls4ml.git && \
    cd hls4ml && \
    pip install hls4ml[profiling]

# add files. .bash_aliases gets sourced from the su command in entrypoint.sh
ADD scripts ./scripts
COPY ./scripts/bash_aliases ${HLS4MLHOME}/.bash_aliases

# create directories to mount
RUN mkdir ${HLS4MLHOME}/results

# go in as root and change user in entrypoint.sh
USER root
# set entrypoint
ENTRYPOINT ["./scripts/entrypoint.sh"]
