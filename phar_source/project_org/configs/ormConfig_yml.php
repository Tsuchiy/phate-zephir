project_name: %%projectName%%
server_env: local
common_master: 
  slave_name: common_slave
  sharding: false
  tables: 
    - 
      table_name: system_m
      read_only: true
    - 
      table_name: user_m
      read_only: false
    
    