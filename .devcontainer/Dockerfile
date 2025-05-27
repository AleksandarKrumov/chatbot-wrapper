ARG VARIANT="3.12"
FROM python:${VARIANT}-slim

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git \
        curl \
        wget \
        build-essential \
        pkg-config \
        libssl-dev \
        libffi-dev \
        libpq-dev \
        sudo \
        zsh \
        fish \
        vim \
        nano \
        htop \
        procps \
        lsb-release \
        ca-certificates \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install UV as root first
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

# Create non-root user with zsh as default shell
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID devuser \
    && useradd --uid $USER_UID --gid $USER_GID -m devuser -s /bin/zsh \
    && echo devuser ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devuser \
    && chmod 0440 /etc/sudoers.d/devuser

# Create workspace directory and set permissions
RUN mkdir -p /workspace && chown -R devuser:devuser /workspace

# Switch to devuser for remaining setup
USER devuser
WORKDIR /home/devuser

# Install UV for the user
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install zsh-in-docker (proven solution for oh-my-zsh in containers)
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t agnoster \
    -a 'export PATH="/home/devuser/.cargo/bin:$PATH"' \
    -a 'export PYTHONPATH="/workspace/src"'

# Configure git safe directory
RUN git config --global --add safe.directory /workspace \
    && git config --global init.defaultBranch main

# Set up environment in bashrc as fallback
RUN echo 'export PATH="/home/devuser/.cargo/bin:$PATH"' >> ~/.bashrc \
    && echo 'export PYTHONPATH="/workspace/src"' >> ~/.bashrc

# Set working directory
WORKDIR /workspace

# Ensure proper ownership of workspace
USER root
RUN chown -R devuser:devuser /workspace
USER devuser

# Keep container running
CMD ["sleep", "infinity"]
