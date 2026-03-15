# Stage 1: compile-image – install dependencies
FROM python:3.11.4-slim-bullseye AS compile-image

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create and activate virtual environment
RUN python -m venv /app
ENV PATH="/app/bin:$PATH"

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip3 install --upgrade --no-cache-dir pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app

# Stage 2: final image – runtime only
FROM python:3.11.4-slim-bullseye

ARG REPO=whittlem/pycryptobot
LABEL org.opencontainers.image.source https://github.com/${REPO}

# Install runtime system dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --no-install-recommends -y \
    libatlas3-base libfreetype6 libjpeg62-turbo \
    libopenjp2-7 libtiff5 libxcb1 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 pycryptobot && \
    useradd -r -u 1000 -g pycryptobot pycryptobot && \
    mkdir -p /app/.config/matplotlib && \
    chown -R pycryptobot:pycryptobot /app

WORKDIR /app
USER pycryptobot

# Set virtual environment path and matplotlib config
ENV PATH="/app/bin:$PATH"
ENV MPLCONFIGDIR="/app/.config/matplotlib"

# Copy the installed virtual environment and code from compile-image
COPY --chown=pycryptobot:pycryptobot --from=compile-image /app /app

# Default command – can be overridden
ENTRYPOINT ["python", "start.py"]
