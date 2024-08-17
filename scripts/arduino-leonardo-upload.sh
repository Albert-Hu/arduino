#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <HEX file>"
  exit 1
fi

FILE=$1
CURRENT_SCRIPT_PATH=$(dirname $(realpath $0))

if [ ! -f "${FILE}" ]; then
  echo "The input file ${FILE} does not exist"
  exit 1
fi

if [ "${FILE##*.}" != "hex" ]; then
  echo "The input file is not a HEX file"
  exit 1
fi

SCRIPT_PATH=$(dirname $(realpath $0))
PORT=$(${CURRENT_SCRIPT_PATH}/arduino-leonardo-bootloader-port.py)

if [ -z "${PORT}" ]; then
  echo "Can not find the bootloader for Arduino Leonardo"
else
  avrdude -p atmega32u4 -c avr109 -P ${PORT} -b 57600 -U flash:w:${FILE}:i
fi
