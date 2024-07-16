#!/bin/bash

#form outout to file 
#wrk -c10 -d1 -t2 --latency -s sample.lua http://192.168.1.120:870 > sample.txt

wrk -c10 -d1 -t2 --latency -s sample.lua http://192.168.1.120:870

