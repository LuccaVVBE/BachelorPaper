#!/bin/bash

cleanup_docker() {
    local folder=$1
    cd $folder

    # Stop all active docker containers
    sudo docker stop $(sudo docker ps -a -q)
    sudo docker network prune -f
    sudo docker container prune -f
    cd -
}


# Function to start Docker and monitor power consumption
run_docker_and_monitor() {
    local folder=$1
    local monitor_script=$2
    local output_file=$3


    # Clean up any existing Docker containers
    cleanup_docker $folder


    # Change to the specified directory
    cd $folder

    # Start Docker containers
    sudo docker-compose up -d

    # Return to scripts
    cd -

    # Run the monitor script
    ./$monitor_script $output_file

    # Back to specified directory
    cd $folder

    # Stop all Docker containers
    sudo docker-compose down

    # Go back to the initial directory
    cd -
}

# Path to the monitor script (relative path)
monitor_script="monitor_power.sh"

# Folder paths for monolith and microservices (relative paths)
monolith_folder="../monolith"
microservices_folder="../microservice"

# Run Docker and monitor for monolith
run_docker_and_monitor $monolith_folder $monitor_script "monolith_power_consumption.csv"

# Run Docker and monitor for microservices
run_docker_and_monitor $microservices_folder $monitor_script "microservices_power_consumption.csv"

# Run the analysis script (relative path)
#python3 analyze_power_consumption.py > analysis_output.log 2>&1

# Optional: Notify that the process is completed
echo "Process completed. Analysis results saved to analysis_output.log"
