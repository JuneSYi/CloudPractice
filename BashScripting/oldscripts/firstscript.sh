#!/bin/bash

# This script prints system info
echo "Welcome to bash script."
echo

# checking system uptime
echo "#############################"
echo "The uptime of the system is: "
uptime

# Memory Utilization
echo "#############################"
echo "Memory Utilization"
free -m

# Disk Utilization
echo "#############################"
echo "Disk Utilization"
df -h
