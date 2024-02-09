# Clock Work
### Log the time you spend working on projects

## Requirements

- Ruby v2 or later
- Bundler v2.4.22 or later

## Installation

1. Clone, fork, or download the repository directly.

    If you download the repository directly, unzip the file.
2. Run the installation script:

    ```bash
    ./install.sh
    ```

   If the installation script fails, you can follow these manual steps:

    1. Install dependencies
   ```bash
   bundle install
   ```
    2. Run migrations
    ```bash
   rake db:migrate
   ```
    3. add the following in your shell configuration. Depending on your shell, this could be `~/.zhrc` or `~/.bashrc`
    ```bash
   alias clock='ruby <PATH TO CLOCKWORK>/lib/clockwork.rb' # Replace <PATH TO CLOCKWORK> with the actual path to the Clockwork directory
   ```
3. Restart your terminal session

## Usage

The program supports the following options:

- `-n`, `--new`: Add a new project and start the clock.
- `-s`, `--start [PROJECT (optional)]`: Start the clock for the specified project.
- `-p`, `--pause`: Pause the clock.
- `-t`, `--total [PROJECT (optional)]`: Display the total time worked for the specified project.
- `-l`, `--list`: List all projects.
- `-d`, `--delete [PROJECT (optional)]`: Delete the specified project.

### Example

```bash
# Add a new project and start the clock
clock -n

# Start the clock for a project named "Project X"
clock -s "Project X"

# Pause the clock
clock -p

# Display the total time worked for "Project Y"
clock -t "Project Y"

# List all projects
clock -l

# Delete a project named "Old Project"
clock -d "Old Project"
```
