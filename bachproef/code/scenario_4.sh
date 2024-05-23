#!/bin/bash

# Function to send requests in batches with a delay
send_requests() {
    local count=$1
    local url=$2
    local method=$3
    local data=$4

    for ((i = 0; i < count; i++)); do
        if [[ $method == "POST" ]]; then
            curl -s -o /dev/null -X POST -d "$data" -H "Content-Type: application/json" $url 
        else
            curl -s -o /dev/null -X GET $url 
        fi

        # Control the batch size and add a small delay
        if ((i % 10 == 9)); then
            wait
        fi
    done
    wait
}

# Send 834 POST requests to the first page
send_requests 834 "http://localhost:8081/public/" "POST" '{"username":"user1", "password":"password"}'

# Send 833 GET requests to the second page
send_requests 833 "http://localhost:8081/public/dashboard" "GET"

# Send 833 GET requests to the third page
send_requests 833 "http://localhost:8081/public/usage?number=1" "GET"

