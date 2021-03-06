# stereotool-docker
Running Stereotool in a Docker container.

Find the ready-to-run container at https://hub.docker.com/r/hlippke/stereotool-docker/

Stereotool is a shareware broadcast audio processor running on your PC. Visit www.stereotool.com for more information. 

Currently Stereotool in Linux does not allow to run multiple instances simultaneously. You can run more than one instance of the ALSA version, but both will grab its settings from a single stereo_tool.rc file in your home-dir.
Additionaly, the ALSA version which uses PortAudio, won't play nice with Jack - it does chose more or less random names.
To solve this, this Docker image can be used to run Steretool on top of Jack1 running as a netONE slave.

## Prerequisites
Host machine with jackd2 oder jackd1 and Docker >= 18.x installed, I recommend jackd2.

## Setup
Allow X Window requests:
```bash
# xhost local:root
```
Run the container:
```bash
# docker run -d --network host -e "JACKPORT=3000" --privileged=true --cap-add=ALL --ulimit rtprio=99 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --name stereotool stereotool
```
or, once created, just start the container:
```bash
# docker start stereotool
```

The container keeps waiting until a JACK master appears and the slave connection is started (see below)

Run Jack on your preferred soundcard and add a slave: 
```bash
$ jack_netsource -H 127.0.0.1 -p 3000 -N Docker1
```
## Multiple instances
On each instance, change the JACKPORT environment variable to a unique and free port number. Use the same port number when setting up the slave with jack_netsource. Don't forget to supply a unique name to jack_netsource, too.

## Known issues
Sometimes the GUI won't show up. Restart the container if this happens.

## TODO
Limit CAPS and privileges.
