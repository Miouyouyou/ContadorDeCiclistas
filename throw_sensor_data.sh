#!/bin/bash

test -e simulador_de_sensor || sudo -c \
	"mknod --mode=666 $(pwd)/simulador_de_sensor p"

while true; do
	echo "U:11.33%   T1:22.3C  T2:34.11C P:40Pa Qa:50x" > simulador_de_sensor
	sleep $1
done

exit 0
