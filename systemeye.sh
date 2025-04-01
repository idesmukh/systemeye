#!/bin/bash
#
# Copyright (c) 2025 Ibad Desmukh
#
# SPDX-License-Identifier: MIT
#
# Systemeye.
# Bash script to analyze server performance statistics in real-time.
#

# Detect pipeline failure in case of any command failure.
set -o pipefail

# AWK script to extract idle CPU % and print it.
# Stored in a read-only variable for reuse.
readonly PRINT_CPU_USAGE='
/^%Cpu/ {
  cpu_idle = substr($0, 37, 4)
  cpu_usage = 100.0 - cpu_idle
  printf "%.1f%%\n", cpu_usage
}'

# AWK script to extract memory usage and print it.
# Stored in a read-only variable for reuse.
readonly PRINT_MEMORY_USAGE='
/^Mem:/ {
  memory_total = $2
  memory_used = $3
  memory_used_percent = (memory_used / memory_total) * 100
  memory_available = $7
  memory_available_percent = (memory_available / memory_total) * 100
  printf "Total: %s Used: %s (%.1f%%) Available: %s (%.1f%%)\n", memory_total, memory_used, memory_used_percent, memory_available, memory_available_percent
}'

while true; do
  # Refresh screen.
  clear

  # Print basic headings for usability.
  printf "Systemeye\n"

  printf "#### Total CPU Usage ####\n"

  # Run top, pass output to AWK, and run AWK script.
  top -b -n 1 | awk "${PRINT_CPU_USAGE}"

  printf "#### Total Memory Usage ####\n"

  # Run free, pass output to AWK, and run AWK script.
  free -h | awk "${PRINT_MEMORY_USAGE}"

  # Wait for five seconds before refresh.
  sleep 5
done