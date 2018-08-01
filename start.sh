#!/bin/bash

${JACKPORT:=3000}

# Start JACK
jackd -d net -I0 -O0 -l $JACKPORT &

status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start JACK: $status"
  exit $status
fi

# wait for JACK to get connect to master
while sleep 1; do
	SYSTEM_PORTS="$(jack_lsp 2> /dev/null | grep system)"

	if [ -n "$SYSTEM_PORTS" ]; then
		 echo $SYSTEM_PORTS
		break
	fi
done

# Start stereotool (blocks until terminated)
./stereo_tool_gui_jack_64 

### TODO: cleanup JACK on exit
