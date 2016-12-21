# only mysql(maria db?)
all:
  common_master:
    host: localhost
    port: 3306
    dbname: %%projectName%%
    user: %%projectName%%
    password: %%projectName%%
    read_only: false
    persistent: true
  common_slave:
    servers:
      common_slave0:
        host: localhost
        port: 3306
        dbname: %%projectName%%
        user: %%projectName%%_r
        password: %%projectName%%_r
        read_only: true
        persistent: true
