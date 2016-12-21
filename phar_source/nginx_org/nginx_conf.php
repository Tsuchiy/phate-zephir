server {
    # --- Edit area --- **Start**
    listen       80;
    server_name  localhost;

    access_log  /var/log/nginx/%%projectName%%.access.log  main;
    error_log   /var/log/nginx/%%projectName%%.error.log  warn;

    set $documentRoot  %%contextRoot%%htdocs/%%projectName%%/;
    set $fastcgiPass   unix:/var/run/php-fpm/www.sock;
    set $serverEnv     local;
    set $debugMode     1;
    # --- Edit area --- **End**
    
    charset utf-8;
    sendfile off;

    
    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }

    location = /robots.txt  { access_log off; log_not_found off; }
    location = /favicon.ico { access_log off; log_not_found off; }


    location ~ \.php$ {
        root           $documentRoot;
        fastcgi_pass   $fastcgiPass;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_param  QUERY_STRING     $query_string;
        fastcgi_param  REQUEST_METHOD   $request_method;
        fastcgi_param  CONTENT_TYPE     $content_type;
        fastcgi_param  CONTENT_LENGTH   $content_length;
    }

    location / {
        root      $documentRoot;
        sendfile  off;
        try_files $uri @phate;
    }

    location @phate {
        fastcgi_pass   $fastcgiPass;
        fastcgi_param  SCRIPT_FILENAME  $documentRoot/index.php;
        include        fastcgi_params;
        fastcgi_param  QUERY_STRING     $query_string;
        fastcgi_param  REQUEST_METHOD   $request_method;
        fastcgi_param  CONTENT_TYPE     $content_type;
        fastcgi_param  CONTENT_LENGTH   $content_length;
        fastcgi_param  DEBUG_MODE       $debugMode;
        fastcgi_param  SERVER_ENV       $serverEnv;
    }
}

