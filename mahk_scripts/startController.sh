#!/bin/bash

echo "Start: $(date +"%T.%3N")"

sudo docker start $1

echo "End: $(date +"%T.%3N")"
