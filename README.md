# redisedge - a Docker image with select Redis Labs modules for the Edge

This simple container image bundles together the latest release [Redis](https://redis.io), and select Redis modules from [Redis Labs](https://redislabs.com).

# Quickstart

```text
$ docker pull redislabs/redisedge
Using default tag: latest
...
$ docker run -p 6379:6379 redislabs/redisedge
1:C 04 Feb 2019 21:26:05.335 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
...
1:M 04 Feb 2019 21:26:05.337 * Module 'tsdb' loaded from /usr/lib/redis/modules/redistimeseries.so
1:M 04 Feb 2019 21:26:05.341 * Module 'ai' loaded from /usr/lib/redis/modules/redisai.so
1:M 04 Feb 2019 21:26:05.341 * Ready to accept connections
```

## Modules included in the container

* [RedisTimeSeries](https://oss.redislabs.com/redistimeseries/): a timeseries database
* [RedisAI](https://oss.redislabs.com/redisai/): a tensor and deep learning graphs server

## Configuring the Redis server

This image is based on the [official image of Redis from Docker](https://hub.docker.com/_/redis/). By default, the container starts with Redis' default configuration and all included modules loaded.

You can, of course, override the defaults. This can be done either by providing additional command line arguments to the `docker` command, or by providing your own [Redis configuration file](http://download.redis.io/redis-stable/redis.conf).

### Running the container with command line arguments

You can provide Redis with configuration directives directly from the `docker` command. For example, the following will start the container, mount the host's `/home/user/data` volume to the container's `/data`, load the RedisAI module, and configure Redis' working directory to `/data` so that the data will actually be persisted there.

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  redislabs/redisedge \
  --loadmodule /usr/lib/redis/modules/redisai.so \
  --dir /data
```

### Running the container with a configuration file

Assuming that you have put together a configration file such as the following, and have stored it at `/home/user/redis.conf`:

```text
requirepass foobared
dir /data
loadmodule /usr/lib/redis/modules/redisai.so
```

And then execute something along these lines:

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  -v /home/user/redis.conf:/usr/local/etc/redis/redis.conf \
  redislabs/redisedge \
  /usr/local/etc/redis/redis.conf
```

Your dockerized Redis server will start and will be listening at the default Redis port (6379) of the host. In addition, the Redis server will require password authentication ("foobared"), will store the data to the container's `/data` (that is the host's volume `/home/user/data`), and will have loaded only the RedisAI module.

## License

This Docker image is licensed under the 3-Clause BSD License.

Redis is distributed under the 3-Clause BSD License. The Redis trademark and logos are owned by Redis Labs Ltd, please read the Redis trademark guidelines (https://redis.io/topics/trademark) for our policy about the use of the Redis trademarks and logo.

The copyright of the Redis modules in this container belongs to Redis Labs, and the modules are distributed under the Apache 2.0 license with Commons Clause.

