all:
  base_uri: 
  timer:
    timezone: Asia/Tokyo
    application_reset_time: 00:00:00
  logger_config_file: %%projectName%%_logger.yml
  database_config_file: %%projectName%%_database.yml
  apcu_config_file: %%projectName%%_apcu.yml
  memcache_config_file: %%projectName%%_memcache.yml
  redis_config_file: %%projectName%%_redis.yml
  filter_config_file: %%projectName%%_filter.yml
  autoload:
    - %%CONTEXT_ROOT%%/projects/%%projectName%%/models
    - %%CONTEXT_ROOT%%/projects/%%projectName%%/database
