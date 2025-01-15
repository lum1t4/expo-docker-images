# Base Image
FROM ubuntu:jammy-20240911.1

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gnupg \
    build-essential \
    python3 \
    python3-pip \
    openjdk-17-jdk \
    android-sdk \
    && apt-get clean

COPY .gradle/gradle.properties /root/.gradle/gradle.properties


RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && unzip commandlinetools-linux-9477386_latest.zip
RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip && unzip platform-tools-latest-linux.zip
RUN mkdir -p /android-sdk/cmdline-tools/latest && mv ./cmdline-tools/* ./android-sdk/cmdline-tools/latest
RUN mkdir -p /android-sdk/platform-tools && mv ./platform-tools/* ./android-sdk/platform-tools
ENV PATH=/android-sdk/cmdline-tools/latest/bin:$PATH
ENV ANDROID_SDK_ROOT=/android-sdk
ENV EAS_NO_VCS=1
RUN yes | sdkmanager --licenses


# Install Node.js 18.18.0
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@9.8.1

# Install Yarn 1.22.21
RUN npm install -g yarn@1.22.21

# Install pnpm 9.3.0
RUN npm install -g pnpm@9.3.0


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

# Install Bun 1.1.13
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL=/root/.bun
ENV PATH=$BUN_INSTALL/bin:$PATH


RUN bun install -g eas-cli


# WORKDIR root
# COPY .npmrc /root/.npmrc
# COPY .yarnrc.yaml /root/.yarnrc.yaml


ENV EAS_NO_VCS 1
# Default command
CMD ["bash"]
