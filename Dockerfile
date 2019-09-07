# BUILD redisfab/redisedge-${OSNICK}:M.m.b-${ARCH}

# OSNICK=stretch|bionic|buster
ARG OSNICK=buster

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai-cpu-${OSNICK}:0.3.2 as ai
FROM redisfab/redistimeseries-${OSNICK}:1.0.2 as timeseries
FROM redisfab/redisgears-${OSNICK}:0.3.1 as gears

#----------------------------------------------------------------------------------------------
FROM redisfab/redis-${ARCH}-${OSNICK}:5.0.5

RUN set -e ;\
	apt-get -qq update; apt-get -q install -y libgomp1

ENV LIBDIR /usr/lib/redis/modules
ENV LD_LIBRARY_PATH $LIBDIR
WORKDIR /data
RUN mkdir -p ${LIBDIR}

COPY --from=timeseries ${LIBDIR}/*.so ${LIBDIR}/
COPY --from=ai ${LIBDIR}/*.so* ${LIBDIR}/
COPY --from=gears /opt/redislabs/lib/modules/redisgears.so ${LIBDIR}/
COPY --from=gears /opt/redislabs/ /opt/redislabs/

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
