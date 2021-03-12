FROM python:3.7.9-slim-buster
RUN echo 'Pulling base image.'

RUN echo 'Installing dependencies.'
RUN apt-get update && apt-get -y install \
    gcc \
    g++

RUN pip install --upgrade pip

RUN echo 'Installing Python packages.'
ADD requirements.txt /
RUN pip install --requirement /requirements.txt

RUN echo 'Adding everything in the current directory to /workspace.'
COPY src/ /container_root/src
#COPY notebooks/ container_root/notebooks

RUN echo 'Setting /workspace as WORKDIR.'
WORKDIR /container_root

RUN echo 'Exposing port 8888 for Jupyter Notebooks.'
EXPOSE 8888

RUN echo 'Exposing port 8050 for Dash apps.'
EXPOSE 8050

COPY docker-entrypoint.sh/ /container_root

RUN echo 'Setting ENTRYPOINT to /container_root/docker-entrypoint.sh.'
ENTRYPOINT ["/container_root/docker-entrypoint.sh"]
