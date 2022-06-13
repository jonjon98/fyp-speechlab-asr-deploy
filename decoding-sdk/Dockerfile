FROM ubuntu:20.04

ENV PATH="/opt/conda/bin:${PATH}"

RUN apt-get update \
    && apt-get -y install gcc g++ \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales wget \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && apt clean -y 
RUN wget --quiet 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh' \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm -f Miniconda3-latest-Linux-x86_64.sh
RUN conda install -y 'python=3.8' \
    && conda clean -y --all \
    && conda install -y -c conda-forge pygobject \
    && pip install tornado==4.5.3 pyyaml ws4py==0.3.2 numpy

ENV TINI_VERSION=v0.18.0 
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Using user instead of root
RUN useradd --create-home speechuser
RUN ln -s /home/speechuser/opt/models /opt/models 

RUN mkdir -p /home/speechuser/opt
WORKDIR /home/speechuser/opt

RUN  mkdir -p /home/speechuser/sdk/logs /home/speechuser/sdk/scripts/logs /home/speechuser/opt/logs
RUN  mkdir -p /home/speechuser/opt/models

COPY --chown=speechuser:speechuser scripts/                  /home/speechuser/sdk/scripts/
COPY --chown=speechuser:speechuser lib/                      /home/speechuser/sdk/lib/
COPY --chown=speechuser:speechuser conf_basic.yaml           /home/speechuser/sdk/conf_basic.yaml
COPY --chown=speechuser:speechuser start_master.sh           /home/speechuser/start_master.sh
COPY --chown=speechuser:speechuser start_worker.sh           /home/speechuser/start_worker.sh

EXPOSE 8010
