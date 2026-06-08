# Лабораторная работа по работе с docker
Работа посвящена изучению технологии работы с контейнерами

Задаём пространство
```sh
$ export GITHUB_USERNAME=<имя_пользователя> 
$ export GIST_TOKEN=<сохраненный_токен> 
$ alias edit=<nano|vi|vim|subl>
```

```python
$ git clone https://github.com/${GITHUB_USERNAME}/lab06 projects/lab_docker 
$ cd projects/lab_docker 
$ git remote remove origin 
$ git remote add origin https://github.com/${GITHUB_USERNAME}/lab_docker
```

```sh
Cloning into 'projects/lab_docker'...
remote: Enumerating objects: 202, done.
remote: Counting objects: 100% (202/202), done.
remote: Compressing objects: 100% (120/120), done.
remote: Total 202 (delta 67), reused 177 (delta 45), pack-reused 0 (from 0)
Receiving objects: 100% (202/202), 361.49 KiB | 1.20 MiB/s, done.
Resolving deltas: 100% (67/67), done.
```

Скачиваем Docker
```sh
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker --version
docker compose version
```

```sh
Hit:1 http://ru.archive.ubuntu.com/ubuntu noble InRelease
Hit:2 http://ru.archive.ubuntu.com/ubuntu noble-updates InRelease              
Hit:3 http://ru.archive.ubuntu.com/ubuntu noble-backports InRelease            
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease               
Hit:5 https://download.docker.com/linux/ubuntu noble InRelease             
Get:6 https://cli.github.com/packages stable InRelease [3,917 B]
Err:6 https://cli.github.com/packages stable InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 23F3D4EA75716059
Reading package lists... Done
W: GPG error: https://cli.github.com/packages stable InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 23F3D4EA75716059
E: The repository 'https://cli.github.com/packages stable InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
docker-ce is already the newest version (5:29.5.3-1~ubuntu.24.04~noble).
docker-ce-cli is already the newest version (5:29.5.3-1~ubuntu.24.04~noble).
containerd.io is already the newest version (2.2.4-1~ubuntu.24.04~noble).
docker-buildx-plugin is already the newest version (0.34.1-1~ubuntu.24.04~noble).
docker-compose-plugin is already the newest version (5.1.4-1~ubuntu.24.04~noble).
0 upgraded, 0 newly installed, 0 to remove and 246 not upgraded.
Docker version 29.5.3, build d1c06ef
Docker Compose version v5.1.4
```

Создаём необходимые файлы
```sh
cat >> main.py <<EOF
print("Hello, Docker!")
EOF

cat >> requirements.txt <<EOF
flask
requests
EOF

cat >> Dockerfile <<EOF
FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential 

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "main.py"]
EOF
```

Собираем образ и запускаем контейнер
```sh
docker build -t lab-docker .
docker run --rm -it lab-docker
```

```sh
[+] Building 46.4s (11/11) FINISHED                              docker:default
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 250B                                       0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim         0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => CACHED [1/6] FROM docker.io/library/python:3.9-slim@sha256:2d97f6910b  0.1s
 => => resolve docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338  0.1s
 => [internal] load build context                                          0.0s
 => => transferring context: 3.77kB                                        0.0s
 => [2/6] WORKDIR /app                                                     0.1s
 => [3/6] RUN apt-get update && apt-get install -y     build-essential    23.3s
 => [4/6] COPY requirements.txt .                                          0.1s 
 => [5/6] RUN pip install --no-cache-dir -r requirements.txt               4.5s 
 => [6/6] COPY . .                                                         0.1s 
 => exporting to image                                                    17.9s 
 => => exporting layers                                                   13.1s 
 => => exporting manifest sha256:9b4b728e65b4838524fe72d677e8a6257001b80b  0.0s 
 => => exporting config sha256:0d0b2f2a935a901edce017d15df562bd363655096e  0.0s 
 => => exporting attestation manifest sha256:88202a4546b1eea922ed98450c0c  0.0s 
 => => exporting manifest list sha256:30b944ba9623a9102ff1fd3e6673699931f  0.0s
 => => naming to docker.io/library/lab-docker:latest                       0.0s
 => => unpacking to docker.io/library/lab-docker:latest                    4.7s
Hello, Docker!
```

```sh
# Просмотр образов
docker images

# Просмотр запущенных контейнеров
docker ps

# Просмотр всех контейнеров (включая остановленные)
docker ps -a

# Остановка контейнера
docker stop <container_id>

# Удаление контейнера
docker rm <container_id>

# Удаление образа
docker rmi lab-docker
```

```sh
                                                            i Info →   U  In Use
IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
lab-docker:latest   30b944ba9623        731MB          189MB        
python:3.9-slim     2d97f6910b16        185MB         47.2MB        
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
bash: syntax error near unexpected token `newline'
bash: syntax error near unexpected token `newline'
Untagged: lab-docker:latest
Deleted: sha256:30b944ba9623a9102ff1fd3e6673699931f29bd93864892e795fa096ad01db4f
```

Устанавливаем переменные и создаём файл docker-compose.yml
```sh
export DB_HOST=db
export DB_USER=app_user
export DB_PASSWORD=secure_password
export DB_NAME=app_db
export DB_ROOT_PASSWORD=root_password

cat >> docker-compose.yml <<EOF
version: '3.8'

services:
  app:
    build: . 
    container_name: lab_docker
    depends_on:
      db:
        condition: service_healthy
    environment:
      - DB_HOST=\${DB_HOST}
      - DB_USER=\${DB_USER}
      - DB_PASSWORD=\${DB_PASSWORD}
      - DB_NAME=\${DB_NAME}

  db:
    image: mysql:8.0
    container_name: mysql_db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: \${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: \${DB_NAME}
      MYSQL_USER: \${DB_USER}
      MYSQL_PASSWORD: \${DB_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db_data:
EOF
```

```sh
# Сборка и запуск всех сервисов
docker compose up --build

# Для запуска в фоновом режиме
docker compose up -d --build

# Просмотр логов
docker compose logs

# Просмотр статуса сервисов
docker compose ps

# Остановка сервисов
docker compose down

# Остановка с удалением томов (очистка данных БД)
docker compose down -v
```

```sh
WARN[0000] /home/ubumba64/projects/lab_docker/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] up 1/1
 ✔ Image mysql:8.0 Pulled                                                             3.8s
[+] Building 5.0s (13/13) FINISHED                                                        
 => [internal] load local bake definitions                                           0.0s
 => => reading from stdin 514B                                                       0.0s
 => [internal] load build definition from Dockerfile                                 0.0s
 => => transferring dockerfile: 250B                                                 0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim                   0.0s
 => [internal] load .dockerignore                                                    0.0s
 => => transferring context: 2B                                                      0.0s
 => [1/6] FROM docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338d3060f261f  0.0s
 => => resolve docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338d3060f261f  0.0s
 => [internal] load build context                                                    0.0s
 => => transferring context: 4.55kB                                                  0.0s
 => CACHED [2/6] WORKDIR /app                                                        0.0s
 => CACHED [3/6] RUN apt-get update && apt-get install -y     build-essential        0.0s
 => CACHED [4/6] COPY requirements.txt .                                             0.0s
 => CACHED [5/6] RUN pip install --no-cache-dir -r requirements.txt                  0.0s
 => [6/6] COPY . .                                                                   0.1s
 => exporting to image                                                               4.5s
 => => exporting layers                                                              0.1s
 => => exporting manifest sha256:4888d8357c75197e435f449964c8205b6e76468b5a38a9b3c0  0.0s
 => => exporting config sha256:63961ca8e26442a59be6bd2e4ca82c6fcc3f5d284ef9545424ee  0.0s
 => => exporting attestation manifest sha256:f15f86302dea58733d4d3e2dd53b0d5f0c1a5c  0.0s
 => => exporting manifest list sha256:f8966b24ec9b0186bd67c2770358913872d30bab0b454  0.0s
 => => naming to docker.io/library/lab_docker-app:latest                             0.0s
[+] up 6/6acking to docker.io/library/lab_docker-app:latest                          4.2s
 ✔ Image mysql:8.0            Pulled                                                  3.8s
 ✔ Image lab_docker-app       Built                                                   5.1s
 ✔ Network lab_docker_default Created                                                 0.1s
 ✔ Volume lab_docker_db_data  Created                                                 0.0s
 ✔ Container mysql_db         Created                                                 1.1s
 ✔ Container lab_docker       Created                                                 0.1s
Attaching to lab_docker, mysql_db
Container mysql_db Waiting 
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Initializing database files
mysql_db  | 2026-06-08T11:32:11.366476Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T11:32:11.366549Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.46) initializing of server in progress as process 80
mysql_db  | 2026-06-08T11:32:11.389924Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T11:32:12.387942Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T11:32:13.952008Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
mysql_db  | 2026-06-08 11:32:17+00:00 [Note] [Entrypoint]: Database files initialized
mysql_db  | 2026-06-08 11:32:17+00:00 [Note] [Entrypoint]: Starting temporary server
mysql_db  | 2026-06-08T11:32:18.375781Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T11:32:18.385578Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 124
mysql_db  | 2026-06-08T11:32:18.418082Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T11:32:18.825359Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T11:32:19.137841Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db  | 2026-06-08T11:32:19.137930Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db  | 2026-06-08T11:32:19.141953Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db  | 2026-06-08T11:32:19.169477Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
mysql_db  | 2026-06-08T11:32:19.169552Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
mysql_db  | 2026-06-08 11:32:19+00:00 [Note] [Entrypoint]: Temporary server started.
mysql_db  | '/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/leapseconds' as time zone. Skipping it.
Container mysql_db Healthy 
lab_docker  | Hello, Docker!
lab_docker exited with code 0
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/tzdata.zi' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Creating database mydb
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Creating user user
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Giving user user access to schema mydb
mysql_db    | 
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Stopping temporary server
mysql_db    | 2026-06-08T11:32:22.867442Z 14 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.46).
mysql_db    | 2026-06-08T11:32:24.187671Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.46)  MySQL Community Server - GPL.
mysql_db    | 2026-06-08 11:32:24+00:00 [Note] [Entrypoint]: Temporary server stopped
mysql_db    | 
mysql_db    | 2026-06-08 11:32:24+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
mysql_db    | 
mysql_db    | 2026-06-08T11:32:25.209852Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db    | 2026-06-08T11:32:25.213219Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 1
mysql_db    | 2026-06-08T11:32:25.222357Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db    | 2026-06-08T11:32:25.439228Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db    | 2026-06-08T11:32:25.602583Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db    | 2026-06-08T11:32:25.602659Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db    | 2026-06-08T11:32:25.606307Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db    | 2026-06-08T11:32:25.635585Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
mysql_db    | 2026-06-08T11:32:25.635648Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

```sh
# Просмотр работающих контейнеров  
docker ps  
  
# Просмотр логов  
docker compose logs  
  
# Просмотр логов в реальном времени  
docker compose logs -f  
  
# Остановка и удаление контейнеров  
docker compose down  
  
# Остановка, удаление контейнеров и томов (данных БД)  
docker compose down -v
```

```sh
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS                   PORTS                                                    NAMES
ab4b346bb6bd   mysql:8.0   "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes (healthy)   0.0.0.0:3306->3306/tcp, [::]:3306->3306/tcp, 33060/tcp   mysql_db
WARN[0000] /home/ubumba64/projects/lab_docker/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
lab_docker  | Hello, Docker!
mysql_db    | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db    | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
mysql_db    | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db    | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Initializing database files
mysql_db    | 2026-06-08T11:32:11.366476Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db    | 2026-06-08T11:32:11.366549Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.46) initializing of server in progress as process 80
mysql_db    | 2026-06-08T11:32:11.389924Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db    | 2026-06-08T11:32:12.387942Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db    | 2026-06-08T11:32:13.952008Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
mysql_db    | 2026-06-08 11:32:17+00:00 [Note] [Entrypoint]: Database files initialized
mysql_db    | 2026-06-08 11:32:17+00:00 [Note] [Entrypoint]: Starting temporary server
mysql_db    | 2026-06-08T11:32:18.375781Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db    | 2026-06-08T11:32:18.385578Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 124
mysql_db    | 2026-06-08T11:32:18.418082Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db    | 2026-06-08T11:32:18.825359Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db    | 2026-06-08T11:32:19.137841Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db    | 2026-06-08T11:32:19.137930Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db    | 2026-06-08T11:32:19.141953Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db    | 2026-06-08T11:32:19.169477Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
mysql_db    | 2026-06-08T11:32:19.169552Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
mysql_db    | 2026-06-08 11:32:19+00:00 [Note] [Entrypoint]: Temporary server started.
mysql_db    | '/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/leapseconds' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/tzdata.zi' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
mysql_db    | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Creating database mydb
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Creating user user
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Giving user user access to schema mydb
mysql_db    | 
mysql_db    | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Stopping temporary server
mysql_db    | 2026-06-08T11:32:22.867442Z 14 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.46).
mysql_db    | 2026-06-08T11:32:24.187671Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.46)  MySQL Community Server - GPL.
mysql_db    | 2026-06-08 11:32:24+00:00 [Note] [Entrypoint]: Temporary server stopped
mysql_db    | 
mysql_db    | 2026-06-08 11:32:24+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
mysql_db    | 
mysql_db    | 2026-06-08T11:32:25.209852Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db    | 2026-06-08T11:32:25.213219Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 1
mysql_db    | 2026-06-08T11:32:25.222357Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db    | 2026-06-08T11:32:25.439228Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db    | 2026-06-08T11:32:25.602583Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db    | 2026-06-08T11:32:25.602659Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db    | 2026-06-08T11:32:25.606307Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db    | 2026-06-08T11:32:25.635585Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
mysql_db    | 2026-06-08T11:32:25.635648Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
WARN[0000] /home/ubumba64/projects/lab_docker/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db  | 2026-06-08 11:32:11+00:00 [Note] [Entrypoint]: Initializing database files
mysql_db  | 2026-06-08T11:32:11.366476Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T11:32:11.366549Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.46) initializing of server in progress as process 80
mysql_db  | 2026-06-08T11:32:11.389924Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T11:32:12.387942Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T11:32:13.952008Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
mysql_db  | 2026-06-08 11:32:17+00:00 [Note] [Entrypoint]: Database files initialized
mysql_db  | 2026-06-08 11:32:17+00:00 [Note] [Entrypoint]: Starting temporary server
mysql_db  | 2026-06-08T11:32:18.375781Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T11:32:18.385578Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 124
mysql_db  | 2026-06-08T11:32:18.418082Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T11:32:18.825359Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T11:32:19.137841Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db  | 2026-06-08T11:32:19.137930Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db  | 2026-06-08T11:32:19.141953Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db  | 2026-06-08T11:32:19.169477Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
mysql_db  | 2026-06-08T11:32:19.169552Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
mysql_db  | 2026-06-08 11:32:19+00:00 [Note] [Entrypoint]: Temporary server started.
mysql_db  | '/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/leapseconds' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/tzdata.zi' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
mysql_db  | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Creating database mydb
mysql_db  | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Creating user user
mysql_db  | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Giving user user access to schema mydb
mysql_db  | 
mysql_db  | 2026-06-08 11:32:22+00:00 [Note] [Entrypoint]: Stopping temporary server
mysql_db  | 2026-06-08T11:32:22.867442Z 14 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.46).
mysql_db  | 2026-06-08T11:32:24.187671Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.46)  MySQL Community Server - GPL.
mysql_db  | 2026-06-08 11:32:24+00:00 [Note] [Entrypoint]: Temporary server stopped
mysql_db  | 
mysql_db  | 2026-06-08 11:32:24+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
mysql_db  | 
mysql_db  | 2026-06-08T11:32:25.209852Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T11:32:25.213219Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 1
mysql_db  | 2026-06-08T11:32:25.222357Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T11:32:25.439228Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T11:32:25.602583Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db  | 2026-06-08T11:32:25.602659Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db  | 2026-06-08T11:32:25.606307Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db  | 2026-06-08T11:32:25.635585Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
mysql_db  | 2026-06-08T11:32:25.635648Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
lab_docker  | Hello, Docker!
WARN[0000] /home/ubumba64/projects/lab_docker/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] down 3/3
 ✔ Container lab_docker       Removed                                                 0.0s
 ✔ Container mysql_db         Removed                                                 1.8s
 ✔ Network lab_docker_default Removed                                                 0.1s
WARN[0000] /home/ubumba64/projects/lab_docker/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] down 1/1
 ✔ Volume lab_docker_db_data Removed                                                  0.0s
```

отправляем на гитхаб
```sh
git add .
git commit -m "Лабораторная работа по Docker"
git push origin main
```
```sh
Username for 'https://github.com': denismalyi2204-glitch
Password for 'https://denismalyi2204-glitch@github.com': 
Enumerating objects: 202, done.
Counting objects: 100% (202/202), done.
Delta compression using up to 4 threads
Compressing objects: 100% (96/96), done.
Writing objects: 100% (202/202), 361.43 KiB | 72.29 MiB/s, done.
Total 202 (delta 68), reused 195 (delta 67), pack-reused 0
remote: Resolving deltas: 100% (68/68), done.
To https://github.com/denismalyi2204-glitch/lab_docker
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.

```

# Homework

## Часть 1
Подготавливаем пространство
```sh
cd ~
git clone https://github.com/tp-lessons/lab_docker.git lab_docker_source
cp -r lab_docker_source/app ~/projects/lab_docker/
cp -r lab_docker_source/db ~/projects/lab_docker/
cd ~/projects/lab_docker
ls -la
```

```sh
Cloning into 'lab_docker_source'...
remote: Enumerating objects: 16, done.
remote: Counting objects: 100% (16/16), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 16 (delta 1), reused 13 (delta 1), pack-reused 0 (from 0)
Receiving objects: 100% (16/16), 5.01 KiB | 1.67 MiB/s, done.
Resolving deltas: 100% (1/1), done.
total 136
drwxrwxr-x 15 ubumba64 ubumba64  4096 Jun  8 11:52 .
drwxrwxr-x  3 ubumba64 ubumba64  4096 Jun  8 10:53 ..
drwxrwxr-x  3 ubumba64 ubumba64  4096 Jun  8 11:52 app
-rw-rw-r--  1 ubumba64 ubumba64   161 Jun  8 10:53 ChangeLog.md
-rwxrwxr-x  1 ubumba64 ubumba64  1094 Jun  8 10:53 check_lab06.sh
-rw-rw-r--  1 ubumba64 ubumba64   601 Jun  8 10:53 CMakeLists.txt
-rw-rw-r--  1 ubumba64 ubumba64  1677 Jun  8 10:53 CPackConfig.cmake
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 11:52 db
-rw-rw-r--  1 ubumba64 ubumba64    66 Jun  8 10:53 DESCRIPTION
-rw-rw-r--  1 ubumba64 ubumba64   724 Jun  8 11:06 docker-compose.yml
-rw-rw-r--  1 ubumba64 ubumba64   211 Jun  8 10:54 Dockerfile
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 examples
-rw-rw-r--  1 ubumba64 ubumba64     6 Jun  8 10:53 file.txt
drwxrwxr-x  3 ubumba64 ubumba64  4096 Jun  8 10:53 formatter_ex_lib
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 formatter_lib
drwxrwxr-x  8 ubumba64 ubumba64  4096 Jun  8 11:44 .git
drwxrwxr-x  3 ubumba64 ubumba64  4096 Jun  8 10:53 .github
-rw-rw-r--  1 ubumba64 ubumba64   194 Jun  8 10:53 .gitignore
-rw-rw-r--  1 ubumba64 ubumba64   102 Jun  8 10:53 .gitmodules
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 hello_world_application
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 include
-rw-rw-r--  1 ubumba64 ubumba64  1062 Jun  8 10:53 LICENSE
-rw-rw-r--  1 ubumba64 ubumba64  1144 Jun  8 10:53 license.rtf
-rw-rw-r--  1 ubumba64 ubumba64    24 Jun  8 10:54 main.py
-rw-rw-r--  1 ubumba64 ubumba64  1044 Jun  8 10:53 main_solver.cpp
-rw-rw-r--  1 ubumba64 ubumba64 14843 Jun  8 10:53 README.md
-rw-rw-r--  1 ubumba64 ubumba64    15 Jun  8 10:54 requirements.txt
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 solver_application
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 solver_lib
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 sources
drwxrwxr-x  2 ubumba64 ubumba64  4096 Jun  8 10:53 tests

```

Создаём новый докер для веб
```sh
cat > Dockerfile << 'EOF'
FROM python:3.9-slim
WORKDIR /app
# Копируем только requirements.txt из папки app/
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Копируем весь код приложения
COPY app/ .
# Открываем порт, который использует приложение (Flask по умолчанию 5000)
EXPOSE 5000
CMD ["python", "app.py"]
EOF
```

```sh
# Сборка образа с новым Dockerfile
docker build -t lab-web-app .

# Запуск контейнера в фоновом режиме с пробросом порта 5000
docker run -d --name web_app_container -p 5000:5000 lab-web-app

# Проверяем что контейнер запустился
docker ps
```

```sh
[+] Building 16.4s (10/10) FINISHED                                               docker:default
 => [internal] load build definition from Dockerfile                                        0.0s
 => => transferring dockerfile: 458B                                                        0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim                          0.0s
 => [internal] load .dockerignore                                                           0.0s
 => => transferring context: 2B                                                             0.0s
 => [1/5] FROM docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338d3060f261f53f1449  0.1s
 => => resolve docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338d3060f261f53f1449  0.1s
 => [internal] load build context                                                           0.0s
 => => transferring context: 1.76kB                                                         0.0s
 => CACHED [2/5] WORKDIR /app                                                               0.0s
 => [3/5] COPY app/requirements.txt .                                                       0.1s
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt                               11.5s
 => [5/5] COPY app/ .                                                                       0.1s 
 => exporting to image                                                                      4.3s 
 => => exporting layers                                                                     3.2s 
 => => exporting manifest sha256:429a16f2d1d5a5b5ffcbd085b5005845c52f8dac806963d98f4140444  0.0s 
 => => exporting config sha256:656b695ae4d92298a8d51945ce662ef1c98eed7c10a25777743baaebd92  0.0s 
 => => exporting attestation manifest sha256:556181075a723c8a9be3d17547d489b6edb16a98e8e0a  0.0s 
 => => exporting manifest list sha256:c9c091b3b62f053b0d917950e6e4de72ad69a43452c28718a5b4  0.0s
 => => naming to docker.io/library/lab-web-app:latest                                       0.0s
 => => unpacking to docker.io/library/lab-web-app:latest                                    1.0s
197ae4653232fb1da47195162a27c3627d18254b0e796147fb45c6556aac8c18
CONTAINER ID   IMAGE         COMMAND           CREATED        STATUS                  PORTS                                         NAMES
197ae4653232   lab-web-app   "python app.py"   1 second ago   Up Less than a second   0.0.0.0:5000->5000/tcp, [::]:5000->5000/tcp   web_app_container

```

Выполняем оставшиеся пункты домашнего задания
```sh
# 3. Копируем файл README.md в каталог /home/ контейнера
docker cp README.md web_app_container:/home/

# 4. Подключаемся к терминалу контейнера в интерактивном режиме
docker exec -it web_app_container /bin/bash

# Внутри контейнера проверяем, что файл скопирован:
ls -la /home/
```

```sh
root@197ae4653232:/app# ls -la /home/
total 24
drwxr-xr-x 1 root root  4096 Jun  8 11:56 .
drwxr-xr-x 1 root root  4096 Jun  8 11:56 ..
-rw-rw-r-- 1 1000 1000 14843 Jun  8 10:53 README.md
```

```sh
# 6. Останавливаем контейнер
docker stop web_app_container

# Удаляем контейнер
docker rm web_app_container
```
```sh
web_app_container
web_app_container
```

## Часть 2
Удаляем и создаём новый докер для веб и sql
```sh
rm -f docker-compose.yml

cat > docker-compose.yml << 'EOF'
services:
  web:
    build: .
    container_name: web_app
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy
    environment:
      MYSQL_HOST: db
      MYSQL_USER: user
      MYSQL_PASSWORD: pass
      MYSQL_DATABASE: mydb

  db:
    image: mysql:8.0
    container_name: mysql_db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: pass
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./db:/docker-entrypoint-initdb.d   # Монтируем папку с init.sql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-prootpass"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db_data:
EOF
```

```sh
# Запуск (сборка образов и запуск контейнеров)
docker compose up --build
```

```sh
[+] Building 0.6s (12/12) FINISHED                                              
 => [internal] load local bake definitions                                 0.0s
 => => reading from stdin 514B                                             0.0s
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 458B                                       0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim         0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [1/5] FROM docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338  0.0s
 => => resolve docker.io/library/python:3.9-slim@sha256:2d97f6910b16bd338  0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 204B                                          0.0s
 => CACHED [2/5] WORKDIR /app                                              0.0s
 => CACHED [3/5] COPY app/requirements.txt .                               0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt        0.0s
 => CACHED [5/5] COPY app/ .                                               0.0s
 => exporting to image                                                     0.2s
 => => exporting layers                                                    0.0s
 => => exporting manifest sha256:e7b8323f0e8d814445c37def3e8ee64fb9a9a828  0.0s
 => => exporting config sha256:7ed7e7f1923eba268dd308b232145af4a4facd7b99  0.0s
 => => exporting attestation manifest sha256:8173e59023fb7c7b0a482eecc474  0.0s
 => => exporting manifest list sha256:fafa7468b6906a184db927697125c8730ff  0.0s
 => => naming to docker.io/library/lab_docker-web:latest                   0.0s
 => => unpacking to docker.io/library/lab_docker-web:latest                0.0s
 => resolving provenance for metadata file                                 0.0s
[+] up 5/5
 ✔ Image lab_docker-web       Built                                         0.7s
 ✔ Network lab_docker_default Created                                       0.1s
 ✔ Volume lab_docker_db_data  Created                                       0.0s
 ✔ Container mysql_db         Created                                       0.2s
 ✔ Container web_app          Created                                       0.1s
Attaching to mysql_db, web_app
Container mysql_db Waiting 
mysql_db  | 2026-06-08 12:01:54+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db  | 2026-06-08 12:01:54+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
mysql_db  | 2026-06-08 12:01:54+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
mysql_db  | 2026-06-08 12:01:55+00:00 [Note] [Entrypoint]: Initializing database files
mysql_db  | 2026-06-08T12:01:55.077960Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T12:01:55.078059Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.46) initializing of server in progress as process 81
mysql_db  | 2026-06-08T12:01:55.086710Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T12:01:55.786065Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T12:01:56.990100Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
mysql_db  | 2026-06-08 12:02:01+00:00 [Note] [Entrypoint]: Database files initialized
mysql_db  | 2026-06-08 12:02:01+00:00 [Note] [Entrypoint]: Starting temporary server
mysql_db  | 2026-06-08T12:02:01.470470Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T12:02:01.472569Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 125
mysql_db  | 2026-06-08T12:02:01.491604Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T12:02:05.841009Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T12:02:06.054482Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db  | 2026-06-08T12:02:06.054690Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db  | 2026-06-08T12:02:06.060228Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db  | 2026-06-08T12:02:06.088509Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
mysql_db  | 2026-06-08T12:02:06.089183Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
mysql_db  | 2026-06-08 12:02:06+00:00 [Note] [Entrypoint]: Temporary server started.
mysql_db  | '/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/leapseconds' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/tzdata.zi' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
mysql_db  | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
mysql_db  | 2026-06-08 12:02:08+00:00 [Note] [Entrypoint]: Creating database mydb
mysql_db  | 2026-06-08 12:02:08+00:00 [Note] [Entrypoint]: Creating user user
mysql_db  | 2026-06-08 12:02:08+00:00 [Note] [Entrypoint]: Giving user user access to schema mydb
mysql_db  | 
mysql_db  | 2026-06-08 12:02:09+00:00 [Note] [Entrypoint]: /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/init.sql
mysql_db  | 
mysql_db  | 
mysql_db  | 2026-06-08 12:02:09+00:00 [Note] [Entrypoint]: Stopping temporary server
mysql_db  | 2026-06-08T12:02:09.097759Z 14 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.46).
mysql_db  | 2026-06-08T12:02:11.049830Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.46)  MySQL Community Server - GPL.
mysql_db  | 2026-06-08 12:02:11+00:00 [Note] [Entrypoint]: Temporary server stopped
mysql_db  | 
mysql_db  | 2026-06-08 12:02:11+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
mysql_db  | 
mysql_db  | 2026-06-08T12:02:11.317634Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
mysql_db  | 2026-06-08T12:02:11.318785Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 1
mysql_db  | 2026-06-08T12:02:11.338177Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
mysql_db  | 2026-06-08T12:02:13.709438Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
mysql_db  | 2026-06-08T12:02:13.856760Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql_db  | 2026-06-08T12:02:13.856789Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
mysql_db  | 2026-06-08T12:02:13.861841Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql_db  | 2026-06-08T12:02:13.887082Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
mysql_db  | 2026-06-08T12:02:13.887090Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
Container mysql_db Healthy 
web_app   |  * Serving Flask app 'app'
web_app   |  * Debug mode: off
web_app   | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
web_app   |  * Running on all addresses (0.0.0.0)
web_app   |  * Running on http://127.0.0.1:5000
web_app   |  * Running on http://172.18.0.3:5000
web_app   | Press CTRL+C to quit
Gracefully Stopping... press Ctrl+C again to force
Container web_app Stopping 
Container web_app Stopped 
Container mysql_db Stopping 
web_app exited with code 137
mysql_db  | 2026-06-08T12:03:34.999340Z 0 [System] [MY-013172] [Server] Received SHUTDOWN from user <via user signal>. Shutting down mysqld (Version: 8.0.46).
mysql_db  | 2026-06-08T12:03:37.258051Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.46)  MySQL Community Server - GPL.
Container mysql_db Stopped 
mysql_db exited with code 0
```
Всё работает исправно и завершилось без ошибок
![[Pasted image 20260608151435.png]]

Отправляем на гитхаб
```sh
cd ~/projects/lab_docker && \
git add app/ db/ Dockerfile docker-compose.yml && \
git commit -m "Домашнее задание: веб-приложение с Flask и MySQL в Docker" && \
git push origin main
```

```sh
[main f126393] Домашнее задание: веб-приложение с Flask и MySQL в Docker
 7 files changed, 84 insertions(+), 18 deletions(-)
 create mode 100644 app/app.py
 create mode 100644 app/models.py
 create mode 100644 app/requirements.txt
 create mode 100644 app/templates/index.html
 create mode 100644 db/init.sql
Username for 'https://github.com': denismalyi2204-glitch
Password for 'https://denismalyi2204-glitch@github.com': 
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 4 threads
Compressing objects: 100% (9/9), done.
Writing objects: 100% (12/12), 2.18 KiB | 2.18 MiB/s, done.
Total 12 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://github.com/denismalyi2204-glitch/lab_docker
   cc0cbfd..f126393  main -> main
```
