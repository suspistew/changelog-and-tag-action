#!/bin/bash

DEBUG_ENABLED=false
INFO_ENABLED=false

if [ -z $LOG_LEVEL ]; then
    LOG_LEVEL=2
fi

 if [ $LOG_LEVEL > 1 ]; then 
    INFO_ENABLED=true
fi

if [ $LOG_LEVEL > 2 ]; then 
    DEBUG_ENABLED=true
fi

function log_error {
    echo "[ERROR] : " $1
}

function log {
    if [ $INFO_ENABLED ]; then 
        echo "[INFO] : " $1
    fi
}

function debug {
    if [ $DEBUG_ENABLED ]; then 
        echo "[DEBUG] : " $1
    fi
}