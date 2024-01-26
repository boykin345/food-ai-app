# Use an official base image
FROM ubuntu:latest

# Update packages list
RUN echo "Updating packages list..."
RUN apt-get update

# Install dependencies for Flutter
RUN echo "Installing dependencies..."
RUN apt-get install -y git wget unzip xz-utils zip libglu1-mesa openjdk-11-jdk-headless curl

# Create a new user to run commands as non-root
RUN echo "Creating a new user..."
RUN useradd -ms /bin/bash user

# Install Flutter SDK
RUN echo "Cloning Flutter SDK..."
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Checkout the specific version of Flutter
# Replace 'commit_hash' with the actual commit hash corresponding to Flutter 3.19.0-9.0.pre.170
RUN echo "Checking out specific Flutter version..."
RUN cd /usr/local/flutter && git checkout 3.16.9

# Change ownership of the Flutter SDK directory to the new user
RUN echo "Changing ownership of the Flutter SDK directory..."
RUN chown -R user:user /usr/local/flutter

# Set the environment variable for Flutter and Dart SDK
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Switch to the non-root user
USER user
WORKDIR /home/user

# Copy your Flutter project and change ownership
RUN echo "Copying Flutter project..."
COPY --chown=user:user . /home/user/app
WORKDIR /home/user/app

# Get Flutter packages
RUN echo "Getting Flutter packages..."
RUN flutter pub get

# Pre-download development binaries, this layers will be cached if the pubspec.yaml doesn't change
RUN echo "Pre-caching development binaries..."
RUN flutter precache

# Run flutter doctor with verbose output
RUN echo "Running flutter doctor..."
RUN flutter doctor -v

# Expose the port that your app runs on, adjust if necessary
EXPOSE 8080

# Command to run your app
CMD echo "Running the app..." && flutter run
