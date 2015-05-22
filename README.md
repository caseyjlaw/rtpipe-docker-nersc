# rtpipe-docker-nersc
Builds OpenSUSE with CASA and all requirements to run rtpipe at NERSC

<<<<<<< HEAD
To build image:
    docker build -t rtpipe .

Then run a shell with data directory mounted:
    docker run -it --rm -v /data:/data:rw rtpipe bash
=======
To build image and run shell:

    docker build -t rtpipe .
    docker run -it rtpipe /bin/bash
>>>>>>> 7df14114eafb15fc0791ffb4b5657c73c4aeca2d
