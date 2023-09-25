FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone 

RUN apt-get update -y && apt-get install -y \
    libgl1-mesa-glx wget curl git \
    tmux imagemagick htop libsndfile1 \
    nodejs npm nfs-common unzip \
    python3 python3-pip\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install \
    wrapt --upgrade --ignore-installed \
    gym gym-minigrid pyopengl pylint natsort kfp \
    git+https://github.com/h2oai/datatable

RUN npm install n -g \
    && n stable

# Minicondaのインストール
ENV MINICONDA_VERSION py38_4.9.2
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh

# Condaの設定
ENV PATH="/opt/conda/bin:${PATH}"
RUN conda update -y conda \
    && conda install -c conda-forge jupyterlab

# RUN pip install matplotlib lightgbm

# code serverのインストール
RUN conda install jupyter-server-proxy -c conda-forge \
    && pip install jupyter-vscode-proxy \
    && pip install ipywidgets widgetsnbextension \
    && pip install jupyterlab-lsp \
    && pip install 'python-lsp-server[all]'

# RUN conda install -y libgcc numpy \
#     && conda update -y numpy

RUN curl -fOL https://github.com/cdr/code-server/releases/download/v3.4.1/code-server_3.4.1_amd64.deb \
    && dpkg -i code-server_3.4.1_amd64.deb

RUN apt-get update -y && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y dbus-x11 \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/yuvipanda/jupyter-desktop-server.git /opt/install
RUN cd /opt/install && \
   conda env update -n base --file environment.yml

# 追加パッケージのインストール
RUN conda install -y libgcc numpy \
    && conda update -y numpy \
    && pip install pandas polars seaborn matplotlib lightgbm

# Since uid and gid will change at entrypoint, anything can be used
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV USER_NAME=jovyan
RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -d /home/${USER_NAME} -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
WORKDIR /home/${USER_NAME}

USER ${USER_NAME}
ENV HOME /home/${USER_NAME}

USER root
RUN mkdir -p $HOME/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/ \
    && mkdir -p $HOME/.jupyter/lab/user-settings/@jupyterlab/terminal-extension \
    && mkdir -p $HOME/.local/share/code-server/User

# set jupyterlab config  
RUN echo '\n\
{ \n\
    "codeCellConfig": { \n\
        "autoClosingBrackets": true, \n\
        "lineNumbers": true \n\
    } \n\
} \n\
' > $HOME/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

USER root

ENV NB_PREFIX /
ENV SHELL=/bin/bash

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]