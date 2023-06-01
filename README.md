# hls4ml-docker

Make sure docker is configured for our proxy.
```
(base) cat ~/.docker/config.json
{
  "proxies": {
    "default": {
      "httpProxy": "http://cloudproxy.sei.cmu.edu:80",
      "httpsProxy": "http://cloudproxy.sei.cmu.edu:80",
      "noProxy": "sei.cmu.edu,[cert.org|http://cert.org]"
    }
  }
}
```

Build the docker image
```
docker build --rm --pull -f ./Dockerfile -t hls4ml:latest .
```

Run the container with
- X forwarding
- Directories mounted in the container that maintain ownership of host id

```
# for X forwarding to work
cp ~/.Xauthority ./env
docker run --rm -it --network=host --privileged -e DISPLAY=$DISPLAY -e LOCAL_UID=$(id -u) -v `pwd`/env:/home/hls4ml-user/env:rw -v `pwd`/work:/home/hls4ml-user/work hls4ml:latest
# in container test X forwarding
hls4ml-user@etc-gpu-09:~$ xclock
```
