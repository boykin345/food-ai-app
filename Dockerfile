# Use an official base image
FROM ubuntu:latest

# Install dependencies for Flutter
RUN apt-get update && apt-get install -y git wget unzip xz-utils zip libglu1-mesa openjdk-11-jdk-headless curl

# Create a new user to run commands as non-root
RUN useradd -ms /bin/bash user

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Checkout the specific version of Flutter
# Replace 'commit_hash' with the actual commit hash corresponding to Flutter 3.19.0-9.0.pre.170
RUN cd /usr/local/flutter && git checkout 3.16.9

# Change ownership of the Flutter SDK directory to the new user
RUN chown -R user:user /usr/local/flutter

# Set the environment variable for Flutter and Dart SDK
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Switch to the non-root user
USER user
WORKDIR /home/user

# Copy your Flutter project and change ownership
COPY --chown=user:user . /home/user/app
WORKDIR /home/user/app

# Get Flutter packages
RUN flutter pub get

# Optionally, pre-download development binaries, this layers will be cached if the pubspec.yaml doesn't change
RUN flutter precache

# Optionally, run flutter doctor with verbose output
RUN flutter doctor -v

# Expose the port that your app runs on, adjust if necessary
EXPOSE 8080

# Replace with the command to run your app
CMD ["flutter", "run"]
