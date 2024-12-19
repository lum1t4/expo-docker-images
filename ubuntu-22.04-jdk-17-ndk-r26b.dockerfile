# Base Image
FROM ubuntu:jammy-20240911.1

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    build-essential \
    python3 \
    python3-pip \
    openjdk-17-jdk \
    && apt-get clean

# Install Node.js 18.18.0
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@9.8.1

# Install Yarn 1.22.21
RUN npm install -g yarn@1.22.21

# Install pnpm 9.3.0
RUN npm install -g pnpm@9.3.0

# Install Bun 1.1.13
RUN curl -fsSL https://bun.sh/install | bash

# Install Android NDK r26 (26.1.10909125)
RUN mkdir -p /opt/android-sdk && \
    cd /opt/android-sdk && \
    wget https://dl.google.com/android/repository/android-ndk-r26b-linux.zip && \
    apt-get install -y unzip && \
    unzip android-ndk-r26b-linux.zip && \
    rm android-ndk-r26b-linux.zip && \
    ln -s /opt/android-sdk/android-ndk-r26b /opt/android-sdk/ndk

# Set NDK path
ENV ANDROID_NDK_HOME=/opt/android-sdk/ndk

# Install node-gyp 10.1.0
RUN npm install -g node-gyp@10.1.0


# Default command
CMD ["bash"]
