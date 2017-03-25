#!/bin/bash

# Edit 20170306

# variables
v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"
v_log_file="${HOME}/initsh.log.$(date +%Y%m%d.%H%M%S)"

# functions
function LogInfo()
{
	echo "$1" | awk '{print "'"$(date -Is)"' [INFO]: "$0}' | tee /dev/stderr
}

function LogNotice()
{
	echo "$1" | awk '{print "'"$(date -Is)"' [NOTICE]: "$0}' | tee /dev/stderr
}

function LogError()
{
	echo "$1" | awk '{print "'"$(date -Is)"' [ERROR]: "$0}' | tee /dev/stderr
}


# EOF
