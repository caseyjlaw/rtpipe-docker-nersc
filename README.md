# rtpipe-docker-nersc
Builds OpenSUSE with CASA and all requirements to run rtpipe at NERSC

To build image:

    docker build -t rtpipe .

Then run a shell with data directory mounted:

    docker run -it --rm -v /data:/data:rw rtpipe bash
