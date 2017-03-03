#!/bin/bash
function StdoutLog() { cat - | awk '{print "'$(date -Is)' "$0}'; }
