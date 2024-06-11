# 使用openjdk作为基础镜像
FROM openjdk:11.0.11-jre-slim-buster

# 设置环境变量
ENV SPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/opt/spark
ENV  PYTHONHASHSEED=1


# 下载并安装相关依赖
RUN apt-get update && apt-get install -y wget procps python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy \
    && apt-get clean
RUN update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1

# 下载并安装Apache Spark
RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} $SPARK_HOME \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# 设置SPARK_HOME环境变量
ENV PATH=$PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=python3

# 复制启动脚本到容器中
COPY start-spark.sh /start-spark.sh
RUN chmod +x /start-spark.sh

# 设置工作目录
WORKDIR $SPARK_HOME

# 设置SPARK环境变量
ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 \
    SPARK_LOG_DIR=/opt/spark/logs \
    SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
    SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
    SPARK_WORKER_WEBUI_PORT=8080 \
    SPARK_WORKER_PORT=7000 \
    SPARK_MASTER="spark://spark-master:7077" \
    SPARK_WORKLOAD="master"

# 暴露Spark Master和Worker的端口
EXPOSE 8080 7077 7000

# 创建日志目录
RUN mkdir -p $SPARK_LOG_DIR && \
    touch $SPARK_MASTER_LOG && \
    touch $SPARK_WORKER_LOG && \
    ln -sf /dev/stdout $SPARK_MASTER_LOG && \
    ln -sf /dev/stdout $SPARK_WORKER_LOG

# 设置启动命令
CMD ["/bin/bash", "/start-spark.sh"]
