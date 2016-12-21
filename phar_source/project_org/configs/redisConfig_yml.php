all:
  default:
    servers:
      default1:
        domain: /var/run/redis/redis.sock
        connection_timeout: 1
        read_write_timeout: 1
        serialize: false
        database: 0
        persistent: false
      default2:
        host: 127.0.0.1
        port: 6379
        connection_timeout: 1
        read_write_timeout: 1
        serialize: false
        persistent: false
        database: 0
  auth:
    host: 127.0.0.1
    port: 6379
    connection_timeout: 1
    read_write_timeout: 1
    serialize: false
    database: 1
