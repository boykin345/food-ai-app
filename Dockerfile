# Use an official base image
FROM ubuntu:latest

# Update packages list and install required packages in one layer
RUN apt-get update && \
    apt-get install -y sudo git wget unzip xz-utils zip libglu1-mesa openjdk-11-jdk-headless curl && \
    rm -rf /var/lib/apt/lists/*

# Install Android SDK
ENV ANDROID_HOME="/usr/local/android-sdk"
ENV ANDROID_SDK_ROOT="$ANDROID_HOME"
RUN mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools" && \
    cd "$ANDROID_SDK_ROOT/cmdline-tools" && \
    wget -O cmdline-tools.zip "https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip" && \
    unzip cmdline-tools.zip && \
    rm cmdline-tools.zip && \
    mv cmdline-tools latest

# Set environment variables
ENV PATH="$PATH:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Accept Android SDK licenses, install build tools and platforms
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;30.0.3"

# Clone Flutter SDK and checkout the specific version
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter && \
    cd /usr/local/flutter && \
    git checkout 3.16.9

# Create a new user and change the ownership of SDKs to non-root user
RUN useradd -ms /bin/bash user && \
    chown -R user:user $ANDROID_SDK_ROOT /usr/local/flutter

# Switch to the non-root user
USER user
WORKDIR /home/user

# Copy the Flutter project
COPY --chown=user:user . /home/user/app
WORKDIR /home/user/app

# Get Flutter packages and pre-download development binaries
RUN flutter pub get && \
    flutter precache

# Run flutter doctor with verbose output
RUN flutter doctor -v

# Expose the port that your app runs on (adjust if necessary)
EXPOSE 8080

# Command to run your app
CMD ["flutter", "run"]