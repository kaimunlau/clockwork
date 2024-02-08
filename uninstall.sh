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

# Function to remove the alias and database environment variable from shell configuration
remove_config() {
  if [ -f "$SHELL_CONFIG" ]; then
    # Remove the alias
    sed -i '/alias clock=/d' "$SHELL_CONFIG"
    echo "Configurations removed from $SHELL_CONFIG"
  else
    echo "Unable to find shell configuration file $SHELL_CONFIG"
  fi
}

# Detect shell configuration file and type
detect_shell_config

# Remove the configurations
remove_config

echo "Uninstallation completed successfully."
