FROM amberframework/amber:1.3.2 as final

WORKDIR /app
RUN apt-get update && apt-get install -y postgresql-client

COPY shard.* /app/
RUN shards install

COPY . /app
COPY ./docker/wait-for-db.sh ./wait-for-db.sh
RUN chmod +x wait-for-db.sh
#     ./wait-for-db.sh \
#     amber db migrate

CMD amber watch
