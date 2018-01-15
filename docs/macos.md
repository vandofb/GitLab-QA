# Run Geo QA tests against your Geo GDK setup

Run from the `gdk-ee/gitlab/qa` directory with GDK primary and secondary running:

```
# Run in the background
bin/qa QA::EE::Scenario::Test::Geo --primary-address http://localhost:3001 --secondary-address http://localhost:3002 --primary-name primary --secondary-name secondary --without-setup

# Run in visible Chrome browser
CHROME_HEADLESS=false bin/qa QA::EE::Scenario::Test::Geo --primary-address http://localhost:3001 --secondary-address http://localhost:3002 --primary-name primary --secondary-name secondary --without-setup
```

# QA Tool support on Mac OS

Most of our development for GitLab is done on Mac OS. This brings some challenges as Docker on
Mac OS doesn't have feature parity with it's Linux conterpart.

There are two ways of running Docker on a Mac. Use a docker-machine provisioned virtual-machine
or use "native" Docker GUI based support.

When using docker-machine you can run your machines in the cloud or locally using something like
VirtualBox. This brings some extra options on how to expose network between Mac OS and the Linux
host VM, but requires extra steps like mapping `$DOCKER_HOST`, booting up and down the VMs with
docker-machine and possibly customizing network settings in the virtualization platform of choice.

Native Docker bundles it's own lightweight virtualization technology that works just like VirtualBox,
but without requiring manual intervention. This provides less opportunity to customize network between
docker containers and the host machine, but works out of the box when mapping container ports to ports 
on localhost.

The major difference is that it never exposes the network as `bridge` to Mac OS, and so `--hostname` 
and `--network` only work inside docker, it has no effect when trying to access the containers from Mac OS.

There are people in Docker's forum that claim to be able to [expose the network][Docker Route]
when using a mix of docker-machine and `route` CLI command.

When using the `route` command to expose the internet network, you still need to glue the DNS part.
There is another tool called [dnsdock][dnsdock] that may do the trick. That means you need to change
your DNS and point to the IP/port of `dnsdock` application.

# Native Docker GUI caveats

When using OS X Docker, you need to go to Preferences > Advanced and allocate at least **5.0 GB**,
otherwise some steps may fail to execute the `chrome-webdriver`.

This is required because chrome-webdriver makes use of `/dev/shm` shared memory. The VM will normally use
~ 3Gb but unless you allocate 5.0 or more some magic numbers may not enable a bigger /dev/shm in the
'host' VM that "native" docker runs on.

Please note that while it's possible to run multi-node tests like Geo Primary and Secondary, you can't
access the machines from your host machine, as they are all exposed as `0.0.0.0:port`, and because
of that they don't match the configured VHOSTs in your GitLab installation, so the redirect login
fails.

It has to do with the lack of `bridge` support from Docker on Mac OS, also this is also something 
Docker Inc [doesn't want to fix][Docker bridge issue].

To see if this limitation is still present, check the [documentation][Docker Networking].

## Workarounds

One possible workaround to connect to a multi-node environment like Geo, is to run a reverse proxy on your
development machine that maps the VHOST to `localhost:port`, changing to the ports listed in `docker ps`.

You first need to map the hostnames to the local ip:

Edit the `/etc/hosts` file
```
127.0.0.1 gitlab-primary.geo gitlab-secondary.geo
```
We are going to use [caddyserver](https://caddyserver.com/) in this example. You can install caddy with `brew install caddy`.

After booting-up your containers, list the assigned ports:

```bash
$ docker ps

CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS                                     PORTS                                    NAMES
d28cc97870b4        gitlab/gitlab-ee:nightly   "/assets/wrapper"   1 second ago        Up Less than a second (health: starting)   22/tcp, 443/tcp, 0.0.0.0:32775->80/tcp   gitlab-secondary
41f86bb951c5        gitlab/gitlab-ee:nightly   "/assets/wrapper"   2 minutes ago       Up 2 minutes (healthy)                     22/tcp, 443/tcp, 0.0.0.0:32774->80/tcp   gitlab-primary
```

Create a Caddyfile, mapping the VHOSTs with the `localhost:port` combination:

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

And run caddy:

```bash
caddy -conf Caddyfile
```

You should be able to use your navigator and point it to `http://gitlab-primary.geo` or `http://gitlab-secondary.geo`.

[Docker Route]: https://forums.docker.com/t/access-container-from-dev-machine-by-ip-dns-name/24631/5
[Docker Networking]: https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds
[Docker bridge issue]: https://github.com/moby/moby/issues/22753#issuecomment-253534261
[dnsdock]: https://github.com/aacebedo/dnsdock

