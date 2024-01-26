# Use an official base image
FROM ubuntu:latest

# Update packages list and install dependencies
RUN apt-get update && \
    apt-get install -y git wget unzip xz-utils zip libglu1-mesa openjdk-11-jdk-headless curl

# Create a new user to run commands as non-root
RUN useradd -ms /bin/bash user

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter && \
    cd /usr/local/flutter && \
    git checkout [CORRECT_FLUTTER_VERSION]

# Change ownership of the Flutter SDK directory to the new user
RUN chown -R user:user /usr/local/flutter

# Set the environment variable for Flutter and Dart SDK
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Switch to the non-root user
USER user
WORKDIR /home/user

# Copy your Flutter project
COPY --chown=user:user . /home/user/app
WORKDIR /home/user/app

# Expose the port that your app runs on
EXPOSE 8080

# Command to run your app (You should define the command to start your app, this is just a placeholder)
CMD ["flutter", "run"]
