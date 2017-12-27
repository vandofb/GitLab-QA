# QA Tool support on Mac OS

Most of our development for GitLab is done in Mac OS. This brings some challenges as Docker on
Mac OS doesn't have feature parity with it's Linux conterpart.

There are two ways of running Docker on a Mac. Use a docker-machine provisioned virtual-machine
or user "native" Docker GUI based support.

When using docker-machine you can run your machines in the cloud or locally using something like
VirtualBox. This brings some extra options on how to expose network between Mac OS and the Linux
host VM, but requires extra steps like mapping `$DOCKER_HOST`, booting up and down the VMs with
docker-machine and possibly customizing network settings in the virtualization platform of choice.

Native docker bundles it's own lightweight virtualization technology that works just like virtualbox,
but without requiring manual intervention. This provides less opportunity to customize network,
but works out of the box when mapping container ports to ports on localhost.

The major difference is that it never exposes the network as "bridge", and so `--host=` never works.

There are people in Docker's forum that claims to be able to [expose the network](Docker Route)
when using a mix of docker-machine and `route` CLI command.

When using the `route` command to expose the internet network, you still need to glue the DNS part.
There is another tool called [dnsdock](dnsdock) that may do the trick. That means you need to change
your DNS and point to the IP/port of `dnsdock` application.

# Native Docker GUI caveats

When using OS X Docker, you need to go to Preferences > Advanced and allocate at least **5.0 GB**,
otherwise some steps may fail to execute the `chrome-webdriver`.

This is required because chrome-webdriver makes use of `/dev/shm` shared memory. The VM will normally use
~ 3Gb but unless you allocate 5.0 or more some magic numbers may not enable a bigger /dev/shm in the
'host' VM that "native" docker runs on.

Please note that while it's possible to run multi-node tests like Geo primary and Secondary, you can't
access the machines from your host machine, as they are all exposed as `localhost:port`, and because
of that they don't match the configured VHOSTs in your GitLab installation, so the redirect login
fails.

To see if this limitation is still present, check the [documentation](Docker Networking).

## Workarounds

One possible workaround to connect to a multi-node environment like Geo, is to run a reverse proxy on your
development machine that maps the VHOST to `localhost:port`, changing to the ports listed in `docker ps`.

Here is an example using a `Caddyfile` (you can install caddy with `brew install caddy`):

```bash
$ docker ps

CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS                                     PORTS                                    NAMES
d28cc97870b4        gitlab/gitlab-ee:nightly   "/assets/wrapper"   1 second ago        Up Less than a second (health: starting)   22/tcp, 443/tcp, 0.0.0.0:32775->80/tcp   gitlab-secondary
41f86bb951c5        gitlab/gitlab-ee:nightly   "/assets/wrapper"   2 minutes ago       Up 2 minutes (healthy)                     22/tcp, 443/tcp, 0.0.0.0:32774->80/tcp   gitlab-primary
```

Caddyfile:

```
http://gitlab-primary.geo {
  proxy / localhost:32774 {
    transparent
  }
}

http://gitlab-secondary.geo {
  proxy / localhost:32775 {
    transparent
  }
}
```

To execute it:

```bash
caddy -conf Caddyfile
```

[Docker Route]: https://forums.docker.com/t/access-container-from-dev-machine-by-ip-dns-name/24631/5
[Docker Networking]: https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds
[dnsdock]: https://github.com/aacebedo/dnsdock

