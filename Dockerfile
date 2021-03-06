FROM jupyter/datascience-notebook:307ad2bb5fce
#FROM jupyter/datascience-notebook:latest

USER root

RUN apt-get update && \
    apt-get install -y \
    gnupg \
    libssl1.0.0 \
    libssl-dev

# using Ubuntu 18.04 as base image
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install remaining packages
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools && \
    apt-get -y --no-install-recommends install \
	   unixodbc \ 
	   unixodbc-dev \ 
	   odbcinst


USER $NB_UID

RUN conda install --quiet --yes \
    'elasticsearch=7.*' \
    'psycopg2=2.7.*' \
    'pyodbc=4.*' \
    'pymssql=2.1.*' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


USER $NB_UID
