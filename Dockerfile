FROM python:3.6.10-buster

RUN pip install -U pytest && \
    pip install -U requests && \
    pip install -U pytest-html
