#!/bin/bash
awk 'BEGIN{i=0;j=0;k=0;l=0}; /^MemTotal:/{i=$2}; /^MemFree:/{j=$2}; /^Active\(file\):/{k=$2}; /^Inactive\(file\):/{l=$2}; END{print (i-j-k-l)*100/i}' /proc/meminfo
