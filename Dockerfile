FROM forecasting_base

ARG FC_VERSION

RUN echo 'Adding everything in the current directory to /workspace.'
COPY . /app

RUN echo 'Setting /workspace as WORKDIR.'
WORKDIR /app

RUN echo 'Installing foodcast'
RUN python -m pip install ./packages/$FC_VERSION

RUN echo 'Exposing port 8888 for Jupyter Notebooks.'
EXPOSE 8888

RUN echo 'Exposing port 8050 for Dash apps.'
EXPOSE 8050

RUN echo 'Setting ENTRYPOINT to /app/docker-entrypoint.sh.'
ENTRYPOINT ["/app/docker-entrypoint.sh"]
