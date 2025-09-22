#!/bin/bash
# Detect pipeline failure in case of any command failure.
set -o pipefail

# The format of AWK scripts comprises:
# pattern { action }
# pattern { action }
# ...
#
# Reference: http://gnu.org/software/gawk/manual/gawk.html#toc-Running-awk-and-gawk

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

# AWK script to extract disk usage and print it.
# Stored in a read-only variable for reuse.
readonly PRINT_DISK_USAGE='
$NF == "/" {
  printf "Total: %s Used: %s Available: %s Use: %s \n", $2, $3, $4, $5
}'

# AWK script to extract top 5 CPU processes and print it.
# Stored in a read-only variable for reuse.
# Prints the header at row 7 as is with NR == 7.
# Prints the top 5 processes which are 8, 9, 10, 11, 12 with NR > 7 && NR <= 12.
readonly PRINT_TOP_PROCESSES='
NR == 7; NR > 7 && NR <= 12 {
	print $0
}'

while true; do
  # Refresh screen.
  clear

  # Print basic headings for usability.
  printf "Systemeye\n"

  printf "#### Total CPU Usage ####\n"

  # Run top, pass output to AWK, and run AWK script.
  top -b -n 1 | awk "${PRINT_CPU_USAGE}"

  printf "#### Total Memory Usage in KB ####\n"

  # Run free, pass output to AWK, and run AWK script.
  free -k | awk "${PRINT_MEMORY_USAGE}"

  printf "#### Total Disk Usage ####\n"

  # Run df, pass output to AWK, and run AWK script.
  df -h | awk "${PRINT_DISK_USAGE}"

  printf "#### Top 5 Processes by CPU Usage ####\n"

  # Run top, pass output to AWK, and run AWK script.
  top -o %CPU -b -n 1 | awk "${PRINT_TOP_PROCESSES}"

  printf "#### Top 5 Processes by Memory Usage ####\n"  

  # Reuse the PRINT_TOP_PROCESSES AWK script.
  # Change the sort override from %CPU to %MEM. 
  top -o %MEM -b -n 1 | awk "${PRINT_TOP_PROCESSES}"

  # Wait for 5 seconds before loop termination.
  sleep 5
done
