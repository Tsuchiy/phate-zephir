all:
  # DEBUG:1 | INFO:2 | WARNING:4 | ERROR:8 | CRITICAL:16
  debug_logging_level: 31
  normal_logging_level: 28

  debug:
    log_file_path: %%contextRoot%%/logs/
    log_file_name: %%projectName%%_debug.log
  info:
    log_file_path: %%contextRoot%%/logs/
    log_file_name: %%projectName%%_debug.log
  warning:
    log_file_path: %%contextRoot%%/logs/
    log_file_name: %%projectName%%_error.log
  error:
    log_file_path: %%contextRoot%%/logs/
    log_file_name: %%projectName%%_error.log
  critical:
    log_file_path: %%contextRoot%%/logs/
    log_file_name: %%projectName%%_error.log
  fatal:
    log_file_path: %%contextRoot%%/logs/
    log_file_name: %%projectName%%_fatal.log
  fluentd:
    socket: unix:///var/run/td-agent/td-agent.sock
#    # host: localhost
#    # port: 24224
