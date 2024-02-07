# Copyright 2023 Carnegie Mellon University.
# MIT (SEI)
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# This material is based upon work funded and supported by the Department of
# Defense under Contract No. FA8702-15-D-0002 with Carnegie Mellon University
# for the operation of the Software Engineering Institute, a federally funded
# research and development center.
# The view, opinions, and/or findings contained in this material are those of
# the author(s) and should not be construed as an official Government position,
# policy, or decision, unless designated by other documentation.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING
# INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON
# UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
# AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR
# PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE
# MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND
# WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release
# and unlimited distribution.  Please see Copyright notice for non-US
# Government use and distribution.
# DM23-0186

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
    libprotobuf-dev \
    protobuf-compiler \
    python3 \
    python3-pip \
    python3-tk \
    sudo \
    vim \
    x11-apps

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
    onnx \
    onnxruntime \
    pandas \
    pydot \
    pyparsing \
    tensorflow==2.12.* \
    tensorrt \
    torch==2.0.1 \
    tqdm && \
    git clone https://github.com/hls-fpga-machine-learning/hls4ml.git && \
    cd hls4ml && \
    pip install .

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
