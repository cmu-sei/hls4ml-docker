Copyright 2023 Carnegie Mellon University.
MIT (SEI)
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
This material is based upon work funded and supported by the Department of
Defense under Contract No. FA8702-15-D-0002 with Carnegie Mellon University
for the operation of the Software Engineering Institute, a federally funded
research and development center.
The view, opinions, and/or findings contained in this material are those of
the author(s) and should not be construed as an official Government position,
policy, or decision, unless designated by other documentation.
NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING
INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON
UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR
PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE
MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND
WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
[DISTRIBUTION STATEMENT A] This material has been approved for public release
and unlimited distribution.  Please see Copyright notice for non-US
Government use and distribution.
DM23-0186


# hls4ml-docker

Build the docker image
```
docker compose build hls4ml
# or
docker build --rm --pull -f ./Dockerfile -t hls4ml:latest .
```

Put some work in work
```
cd work
git clone git@github.com:cmu-sei/pytorch-iris.git
cd pytorch-iris
git checkout hls4ml
cd ../
# see pytorch-iris README.md for usage with hls4ml docker
```

Run the container
```
# put your Xilinx license in ./env
cp /path/to/Xilinx.lic ./env
# for X forwarding to work
cp ~/.Xauthority ./env
# preferred
docker compose run --rm -e UID=$(id -u) -e GID=$(id -g) hls4ml
# or without compose. To run the synthesis tools must have vivado configured.
docker run --rm -it --network=host --privileged -e DISPLAY=$DISPLAY -e UID=$(id -u) -e GID=$(id -g) -v`pwd`/env:/home/hls4ml-user/env:rw -v`pwd`/work:/home/hls4ml-user/work hls4ml:latest
# in container test X forwarding
hls4ml-user@etc-gpu-09:~$ xclock
```
