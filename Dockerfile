# BUILD redisfab/redisedge-${ARCH}-${OSNICK}:latest

ARG OSNICK=bionic

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai-cpu-${OSNICK}:latest as ai
FROM redisfab/redistimeseries-${OSNICK}:latest as timeseries
FROM redisfab/redisgears-${OSNICK}:latest as gears

#----------------------------------------------------------------------------------------------
FROM redislabs/redis-${OSNICK}:5.0.5

RUN apt-get update; apt-get install -y libgomp1

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN mkdir -p ${LD_LIBRARY_PATH};

COPY --from=timeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=ai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/
COPY --from=gears /opt/redislabs/lib/modules/redisgears.so ${LD_LIBRARY_PATH}/
COPY --from=gears /opt/redislabs /opt/redislabs

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
