ARG VARIANT="3.12"
FROM python:${VARIANT}-slim

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git \
        curl \
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
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

# Create non-root user with specific UID/GID for security
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID devuser \
    && useradd --uid $USER_UID --gid $USER_GID -m devuser -s /bin/bash \
    && echo devuser ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devuser \
    && chmod 0440 /etc/sudoers.d/devuser

# Install UV for the user
USER devuser
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/devuser/.cargo/bin:$PATH"

# Set up workspace
WORKDIR /workspace
USER devuser

# Configure git safe directory
RUN git config --global --add safe.directory /workspace

# Install zsh with oh-my-zsh for better terminal experience
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc \
    && echo 'export PATH="/home/devuser/.cargo/bin:$PATH"' >> ~/.zshrc \
    && echo 'export PYTHONPATH="/workspace/src"' >> ~/.zshrc

# Default command
CMD ["sleep", "infinity"]
