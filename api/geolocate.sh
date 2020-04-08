#!/usr/bin/env bash
API_KEY=""

# Matrix
# curl -d @data.json -H "Content-Type: application/json" -i "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?key=${API_KEY}"


curl "http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=redmond%2Cwa&wp.1=Issaquah%2Cwa&avoid=minimizeTolls&key=${API_KEY}"
