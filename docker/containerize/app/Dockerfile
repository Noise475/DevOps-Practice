# your code goes here ...
FROM python:3.8-slim-buster

WORKDIR /home/app/src

ENV FLASK_APP /home/app/src/server.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_RUN_PORT 8000
ENV FLASK_ENV development

COPY . /home/app

RUN pip install -r requirements.txt

CMD ["flask","run"]
