FROM amberframework/amber:1.3.2

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

CMD amber watch
