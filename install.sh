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

# Function to check if Oh My Zsh is installed
check_oh_my_zsh() {
  if [ "$SHELL_TYPE" = "zsh" ] && [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is installed. Please ensure you switch to Zsh shell for full functionality."
  fi
}

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
  echo "Ruby is not installed. Please install Ruby before proceeding."
  exit 1
fi

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
  echo "Bundler is not installed. Installing Bundler..."
  gem install bundler
fi

# Change directory to the program's directory
cd "$(dirname "$0")" || exit

# Install dependencies
bundle install

# Run database migrations
rake db:migrate

# Create an alias
detect_shell_config
echo "alias clock='ruby $(pwd)/lib/clockwork.rb'" >> "$SHELL_CONFIG"

# Source the shell configuration file to apply the alias immediately
source "$SHELL_CONFIG"

# Check if Oh My Zsh is installed
check_oh_my_zsh

echo "Installation completed successfully. Run 'clock' to start the clock. Run 'clock -h' for help. Enjoy!"
