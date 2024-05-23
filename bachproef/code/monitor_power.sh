#!/bin/bash

# Ensure an output file name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 output_file.csv"
    exit 1
fi

output_file=$1

# Function to stop powerjoular and extract the data
stop_powerjoular() {
    if ps -p $POWERJOULAR_PID > /dev/null; then
        # Kill the powerjoular process
        sudo kill -INT $POWERJOULAR_PID

        # Wait for powerjoular to terminate
        wait $POWERJOULAR_PID

        # Give powerjoular some time to log the data
        sleep 1

        # Extract the energy data from the log file
        CPU_ENERGY=$(grep "CPU energy" powerjoular.log | awk '{print $3}')
        GPU_ENERGY=$(grep "GPU energy" powerjoular.log | awk '{print $3}')
        TOTAL_ENERGY=$(grep "Total energy" powerjoular.log | awk '{print $3}')

        # Write the data to the CSV file
        echo "$ROUND,$SCENARIO,$CPU_ENERGY,$GPU_ENERGY,$TOTAL_ENERGY,$TOTAL_TIME" >> $output_file

        # Clear the log file for the next script
        > powerjoular.log
    fi
}

# Trap the EXIT signal to ensure powerjoular stops even if the script is interrupted
trap stop_powerjoular EXIT

# Initialize CSV file with headers
echo "Ronde,Scenario,CPU Energie,GPU Energie,Total Energie,Tijd" > $output_file

# Array of scripts to execute
scripts=("scenario_1.sh" "scenario_2.sh" "scenario_3.sh" "scenario_4.sh")  # Add your script names here

# Loop through each script and execute each script 10 times
for SCRIPT_NAME in "${scripts[@]}"; do
    # Extract the scenario number from the script name
    SCENARIO=$(echo $SCRIPT_NAME | grep -oP '(?<=scenario_)\d+')

    for ROUND in {1..50}; do
    	echo "Ronde: $ROUND - Scenario: $SCENARIO"
        # Start powerjoular in the background and redirect its output to a log file
        sudo powerjoular -a dockerd -t > powerjoular.log 2>&1 &
        POWERJOULAR_PID=$!

        # Start the timer
        START_TIME=$(date +%s)

        # Execute the script
        ./$SCRIPT_NAME

        # Stop the timer
        END_TIME=$(date +%s)

        # Calculate the total time
        TOTAL_TIME=$((END_TIME - START_TIME))

        # Stop powerjoular and log the data
        stop_powerjoular
    done
done

echo "All scripts executed and powerjoular data recorded."

