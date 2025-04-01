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

while true; do
  # Refresh screen.
  clear

  # Print basic headings for usability.
  printf "Systemeye\n"
  printf "#### Total CPU Usage ####\n"

  # Run top, pass output to AWK, and run AWK script.
  top -b -n 1 | awk "${PRINT_CPU_USAGE}"

  # Wait for five seconds before refresh.
  sleep 5
done