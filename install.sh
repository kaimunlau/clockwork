#!/usr/bin/env bash

# Function to detect the user's default shell configuration file and shell type
detect_shell_config() {
  if [ -f "$HOME/.bashrc" ]; then
    SHELL_TYPE="bash"
    SHELL_CONFIG="$HOME/.bashrc"
  elif [ -f "$HOME/.zshrc" ]; then
    SHELL_TYPE="zsh"
    SHELL_CONFIG="$HOME/.zshrc"
  else
    echo "Unable to detect shell configuration file (.bashrc or .zshrc). Please create the alias manually."
    exit 1
  fi
}

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
  echo "Ruby is not installed. Please install Ruby before proceeding."
  exit 1
fi

# Check if Bundler is installed and if its version is smaller than 2
bundler_version=$(bundle --version | awk '{print $3}')
if [[ -z "$bundler_version" || "$(echo "$bundler_version < 2" | bc)" -eq 1 ]]; then
  echo "Bundler is not installed or the version is smaller than 2. Installing/updating Bundler..."

  # Attempt to install/update Bundler without sudo first
  gem install bundler -v "$(grep -o 'BUNDLED WITH[^,]*' Gemfile.lock | cut -d' ' -f3)" || {
    # If it fails due to permission, retry with sudo
    echo "Attempting to install/update Bundler with sudo..."
    sudo gem install bundler -v "$(grep -o 'BUNDLED WITH[^,]*' Gemfile.lock | cut -d' ' -f3)"
  }
fi

# Change directory to the program's directory
cd "$(dirname "$0")" || exit

# Install dependencies
bundle install || {
  echo "Attempting to install gems with sudo..."
  sudo bundle install
}

# Run database migrations
rake db:migrate

# Create an alias
detect_shell_config

echo "alias clock='ruby $(pwd)/lib/clockwork.rb'" >> "$SHELL_CONFIG"

echo "Installation completed successfully. Please restart your shell to use the 'clock' command."
