#!/bin/bash
v_log_file="${HOME}/initsh.log"

function StdoutLog()
{
	cat - | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log
}


