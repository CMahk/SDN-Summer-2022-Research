#!/bin/bash

echo "Start: $(date +"%T.%3N")"

sudo docker stop $1

echo "End: $(date +"%T.%3N")"
