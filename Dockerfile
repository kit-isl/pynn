FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-dev python3-pip build-essential libxml2

# make python3 the default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

# Python libraries
RUN python -m pip install numpy==1.20 scipy webrtcvad Cython==0.29.7
RUN python -m pip install torch==1.9.0+cpu -f https://download.pytorch.org/whl/torch_stable.html

# install the MCloud Python wrapper
COPY python_worker_template /opt/python_worker_template
WORKDIR /opt/python_worker_template/src
RUN ./setup.sh
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/python_worker_template/src/linux_lib64"
ENV PYTHONPATH="$PYTHONPATH:/opt/python_worker_template/src/src/lib"

# install the pynn ASR worker
COPY . /opt/pynn
ENV PYTHONPATH="$PYTHONPATH:/opt/pynn/src"
WORKDIR /opt/pynn/worker

CMD ./docker-entrypoint.sh
