'''
Author       : wyx-hhhh
Date         : 2024-06-11
LastEditTime : 2024-06-11
Description  : 
'''
from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.clustering import KMeans

# 初始化Spark会话
spark = SparkSession.builder.appName("KMeansApp").getOrCreate()

# 读取外部数据集文件
data = spark.read.csv("file:/opt/data/iris.csv", header=True, inferSchema=True)

# 特征向量组装
feature_cols = data.columns
feature_cols.remove("label")  # 排除标签列
assembler = VectorAssembler(inputCols=feature_cols, outputCol="features")
data = assembler.transform(data)

# 使用KMeans聚类
kmeans = KMeans().setK(3).setSeed(1)
model = kmeans.fit(data)

# 打印聚类中心点
centers = model.clusterCenters()
for center in centers:
    print(center)

# 停止Spark会话
spark.stop()
