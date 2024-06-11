# 基于Spark集群和PySpark实现Kmeans算法

## 安装

### 前提

1. 要求安装有docker
2. 要求安装有docker-compose

### 创建docker-spark-demo镜像

```Bash
docker build -t docker-spark-demo .
```

### 基于docker-spark-demo镜像构建集群

```Bash
docker-compose up -d
```

## 运行

### 查看容器id

```Bash
docker container ls
```

### 进入对应id命令行

```Bash
docker exec -it e85bf2f9b601 /bin/bash
```

### 执行spark-submit运行脚本

```Bash
/opt/spark/bin/spark-submit --deploy-mode client --master spark://spark-master:7077 --total-executor-cores 1 /opt/apps/main.py
```

## 链接

带有图文详细版：https://www.wolai.com/wyx-hhhh/fgkF1wxXY2FC9gp3ehh4Pm
