from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from clickhouse_driver import Client

default_args={
    'owner':'FedorovMG'
}

def showDatabase():
    client = Client('clickhouse')
    rezult = client.execute('SHOW DATABASES')
    for r in rezult:
        print(r)


with DAG(
    default_args=default_args,
    dag_id='show_databases',
    description='show databases',
    start_date=datetime(2022,8,14),
    schedule_interval='@daily'
)as dag:
    task1 = PythonOperator(
        task_id='showDatabases',
        python_callable=showDatabase
    )

    task1
    