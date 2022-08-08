FROM python:3.6
RUN apt-get update
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN pip install -r requiremets.txt
ENV FLASK_ENV="docker"
EXPOSE 5000