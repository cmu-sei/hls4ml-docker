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

```
cd work
python -m test_network.py
cd hls4mlprj_network_Vivado
vivado_hls -f build_prj.tcl 'csim=1 synth=1 cosim=1 validation=1'

# within hls4ml itself
cd hls4ml/test/pytest
# for pytest, use --co to get test names, then something like
python -m pytest test_pytorch_api.py -rP -k 'test_conv2d[io_stream-Vivado-1]'
```
