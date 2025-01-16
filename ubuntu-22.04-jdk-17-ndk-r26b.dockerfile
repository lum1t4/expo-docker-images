# Base Image
FROM ubuntu:jammy-20240911.1

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /

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
    android-sdk && \
    rm -rf /var/lib/apt/lists/* &&\
    apt-get clean


# Install Node.js 18.18.0
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* &&\
    apt-get clean

RUN npm install -g npm@9.8.1 yarn@1.22.19 pnpm@8.9.2 node-gyp@10.1.0

COPY .gradle/gradle.properties /root/.gradle/gradle.properties

# Install Android SDK, NDK r26 (26.1.10909125)
RUN mkdir -p /android-sdk && cd /android-sdk && \
    wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip && unzip platform-tools-latest-linux.zip && rm platform-tools-latest-linux.zip && \
    mkdir -p /android-sdk/ndk && cd /android-sdk/ndk && \
    wget https://dl.google.com/android/repository/android-ndk-r26b-linux.zip && unzip android-ndk-r26b-linux.zip && rm android-ndk-r26b-linux.zip && mv /android-sdk/ndk/android-ndk-r26b /android-sdk/ndk/26.1.10909125 && \
    mkdir -p /android-sdk/cmdline-tools && cd /android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && unzip commandlinetools-linux-7583922_latest.zip && rm commandlinetools-linux-7583922_latest.zip && mv cmdline-tools latest

ENV PATH=/android-sdk/cmdline-tools/latest/bin:$PATH
ENV ANDROID_HOME=/android-sdk
ENV ANDROID_SDK_ROOT=/android-sdk
ENV ANDROID_NDK_HOME=/android-sdk/ndk
ENV EAS_NO_VCS=1
ENV PATH=/android-sdk/platform-tools:$PATH
ENV PATH=/android-sdk/tools:$PATH
ENV PATH=/android-sdk/tools/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
RUN yes | sdkmanager --licenses


RUN npm install -g eas-cli
# Default command
CMD ["bash"]
