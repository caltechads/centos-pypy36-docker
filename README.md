# centos-pypy36-docker

[PyPy](https://pypy.org) is a replacement for CPython. It is built using the
RPython language that was co-developed with it. The main reason to use it
instead of CPython is speed: it runs generally faster.

This project provides a version of the base `centos:7` image (see the
[DockerHub centos page](https://hub.docker.com/_/centos)) with the current
stable version of pypy-3.6 (v7.1.1) installed into `/opt/pypy`.

[Repository page on Docker Hub](https://cloud.docker.com/u/caltechads/repository/docker/caltechads/pypy36)

## Available image tags in Docker Hub

 * `caltechads/pypy36:3.6-v7.1.1`: the latest version of the Earthworm 7.9 container
 * `caltechads/pypy36:3.6-v7.1.1-build1`: the specific tag of latest version of the
   pypy3 7.9 container.  Use this is you want to pin to a specific build of
   `caltechads/pypy36:3.6-v7.1.1`

## Testing

You can run the container via

```
docker-compose up
```

And then exec into the container like so:

```
docker exec -ti pypy3 bash
```

## Pushing a new release to Docker Hub

When you are ready to push a new release to [DockerHub](https://hub.docker.com), commit
all your changes to `master`, then:

```
pip install -r requirements.txt
bumpversion patch
git checkout build
git merge master
git push --tags origin master build
```

Docker Hub will see the commits and build the new container images.  This takes
up to 15 minutes.
