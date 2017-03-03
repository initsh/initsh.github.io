#!/bin/bash
function StdoutLog() { cat - | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log; }
