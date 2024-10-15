from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.operators.empty import EmptyOperator  # Updated import for EmptyOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

with DAG(dag_id='sql_jupyter_sql_workflow',
         default_args=default_args,
         schedule_interval=None) as dag:

    # Start with EmptyOperator
    start = EmptyOperator(task_id='start')

    # Step 1: Execute 0-flat_table.sql in SQL Server
    run_flat_table_sql = DockerOperator(
        task_id='run_flat_table_sql',
        image='mcr.microsoft.com/mssql/server:latest',
        command='/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -d "$MSSQL_DATABASE" -i /usr/src/sql/final_0-flat_table.sql',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        auto_remove=True
    )

    # Step 2: Run Jupyter notebook processing
    run_jupyter_notebook = DockerOperator(
        task_id='run_jupyter_notebook',
        image='jupyter/minimal-notebook:latest',
        command='start-notebook.sh',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        volumes=['./Notebook-image/notebooks:/usr/src/app/notebooks'],
        auto_remove=True
    )

    # Step 3: Execute remaining SQL scripts
    run_remaining_sql_files = DockerOperator(
        task_id='run_remaining_sql_files',
        image='mcr.microsoft.com/mssql/server:latest',
        command='/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -d "$MSSQL_DATABASE" -i /usr/src/sql/2-row_numbers.sql && \
                 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -d "$MSSQL_DATABASE" -i /usr/src/sql/3-NORMALIZED_NOTHING.sql && \
                 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -d "$MSSQL_DATABASE" -i /usr/src/sql/4-INSERT_INTO_NORMALIZED.sql',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        auto_remove=True
    )

    # Step 4: Run shell container for post-processing
    run_shell_export = DockerOperator(
        task_id='run_shell_export',
        image='shell-image:latest',
        command='/bin/bash /usr/local/bin/export_data.sh',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        volumes=['./exports:/export'],
        auto_remove=True
    )

    # Task execution order
    start >> run_flat_table_sql >> run_jupyter_notebook >> run_remaining_sql_files >> run_shell_export
