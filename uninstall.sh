#!/usr/bin/env bash

# Function to remove the alias and database environment variable from shell configuration
remove_config() {
  if [ -f "$SHELL_CONFIG" ]; then
    # Remove the alias
    sed -i '/alias clock=/d' "$SHELL_CONFIG"
    # Remove the database environment variable
    sed -i '/export DATABASE_URL='sqlite:\/\/$(pwd)\/db\/database.db'/d' "$SHELL_CONFIG"
    echo "Configurations removed from $SHELL_CONFIG"
  else
    echo "Unable to find shell configuration file $SHELL_CONFIG"
    exit 1
  fi
}

# Detect shell configuration file and type
detect_shell_config

# Remove the configurations
remove_config

echo "Uninstallation completed successfully."
