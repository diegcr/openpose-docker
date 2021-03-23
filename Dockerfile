# https://hub.docker.com/r/cwaffles/openpose
FROM nvidia/cuda:10.0-cudnn7-devel

#get deps
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
python3-setuptools python3-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev

#for python api
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install numpy
RUN pip3 install opencv-python

#replace cmake as old version has CUDA variable bugs
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.tar.gz && \
tar xzf cmake-3.16.0-Linux-x86_64.tar.gz -C /opt && \
rm cmake-3.16.0-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.16.0-Linux-x86_64/bin:${PATH}"

#get openpose
WORKDIR /openpose
RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git .

#build it
WORKDIR /openpose/build
RUN cmake -DBUILD_PYTHON=ON -DCUDA_ARCH="Turing \(CUDA >= 10\)" .. && make -j `nproc`
WORKDIR /openpose