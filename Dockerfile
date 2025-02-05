# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:slim

EXPOSE 8003

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		python3-pip \
		python3-dev \
		unattended-upgrades && \
	rm -r /var/lib/apt/lists/*

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
COPY ./app /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
# File wsgi.py was not found in subfolder: 'docker-django-example'. Please enter the Python path to wsgi file.
CMD ["gunicorn", "--bind", "0.0.0.0:8003", "app.wsgi"]
