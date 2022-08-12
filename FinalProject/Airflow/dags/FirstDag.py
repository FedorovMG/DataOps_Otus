from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from clickhouse_driver import Client

client = Client('0.0.0.0')
rezult = client.execute("SHOW DATABASES")
print(rezult)