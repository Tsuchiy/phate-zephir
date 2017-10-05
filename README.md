# Phate

### (Extension Version with Zephir)


### "Phate" as "PHP http(s) application thin engine"

---
### Dependencies:


- Linux Operating system
- PHP 5.6 or later
- Zephir (https://zephir-lang.com/)
- php modules
```
pdo
mysqlnd
mbstring
mcrypt
xml
```
- pecl extensions

```
zendopcache
msgpack
apcu
yaml
redis
memcached
```
- any http engine (nginx + php-fpm recommended)
- database require mysql interface
- simple fluent extention( https://github.com/Tsuchiy/SimpleFluent-Zephir )


### Installation (Extension):

1. install zephir( https://zephir-lang.com/ )

2. clone this repository

3. execute "zephir init phate" in any directory(e.g./usr/src/zephir/)

4. copy souce code
(e.g. `cp phate-zepher/zephir/phate/*.zep /usr/src/zephir/phate/phate/.` )

5. execute "zephir build" in "config.json" existing directory
(e.g. `cd /usr/src/zephir/phate/ && zephir build` )

6. add setting to php.ini


### Installation ("phate" command):

"phate" command will help you scaffolding project.

1. put "phate.phar" (e.g. `sudo cp phate.phar /usr/local/bin/phate`)
2. grant execution (e.g. `sudo chmod +x /usr/local/bin/phate`)
3. execute "phate" to test (will be displayed any help message)




### More documents coming soon...


Copyright (c) 2017 Nobuo Tsuchiya  


