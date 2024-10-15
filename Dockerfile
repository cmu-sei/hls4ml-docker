FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

WORKDIR /home

# run apt update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    curl \
    emacs \
    git \
    graphviz \
    locales \
    python3 \
    python3-pip \
    python3-tk \
    sudo \
    vim \
    x11-apps \
    zip && \
    locale-gen en_US.UTF-8

# set up a user
RUN useradd -l -ms /bin/bash hls4ml-user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    adduser hls4ml-user sudo
ARG HLS4MLHOME=/home/hls4ml-user
WORKDIR ${HLS4MLHOME}
USER hls4ml-user

# pytorch-iris needs pytorch and tqdm. other requirements loaded by hls4ml
ARG CONDAPATH=/home/hls4ml-user/miniconda3
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    source ${CONDAPATH}/etc/profile.d/conda.sh && \
    conda init bash && \
    conda update -n base -c defaults conda && \
    conda create --name hls4ml python=3.10 && \
    conda activate hls4ml && \
    pip install --upgrade pip && \
    pip install \
    matplotlib \
    numpy \
    pdbpp \
    pre-commit \
    pydot \
    pyparsing \
    pytest \
    tensorflow==2.12.* \
    tensorrt \
    torch==2.0.1 \
    torchinfo \
    tqdm && \
    git clone https://github.com/hls-fpga-machine-learning/hls4ml.git && \
    cd hls4ml && \
    git submodule update --init && \
    pip install hls4ml[profiling] .

# add files. .bash_aliases gets sourced from the su command in entrypoint.sh
ADD scripts ./scripts
COPY ./scripts/bash_aliases ${HLS4MLHOME}/.bash_aliases
RUN echo "conda activate hls4ml" >> ${HLS4MLHOME}/.bashrc

# create directories to mount
RUN mkdir ${HLS4MLHOME}/work

# go in as root and change user in entrypoint.sh
USER root
# set entrypoint
ENTRYPOINT ["./scripts/entrypoint.sh"]
