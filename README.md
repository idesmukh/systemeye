# Systemeye

Systemeye is a bash script to analyze basic server performance statistics on Ubuntu systems. It is designed for system monitoring and debugging.

## Features

Systemeye prints the following performance statistics to the terminal and refreshes every 5 seconds.
- Total CPU Usage
- Total Memory Usage
- Total Disk Usage
- Top 5 Processes by CPU Usage
- Top 5 Processes by Memory Usage

## Getting Started

### Prerequisites

- An Ubuntu-based server or desktop environment.
- Bash shell access.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/idesmukh/systemeye.git
    cd systemeye
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x systemeye.sh
    ```

### Usage

Run the script from your terminal:

```bash
./systemeye.sh
```

## License

This code is provided under the MIT license.
