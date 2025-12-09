import pyodbc
from utils import get_sql_config, read_sql_file


def get_db_connection():
    config = get_sql_config()
    conn_str = (
        f"DRIVER={config['driver']};"
        f"SERVER={config['server']};"
        f"DATABASE={config['database']};"
        f"Trusted_Connection={config['trusted_connection']};"
    )
    return pyodbc.connect(conn_str)


def execute_sql_task(script_name, params, logger):
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        query_path = f"pipeline_dimensional_data/queries/{script_name}"

        logger.info(f"Reading query from {query_path}...")
        sql_script = read_sql_file(query_path, params)

        logger.info(f"Executing query for {params.get('table_name', 'Unknown Table')}...")
        cursor.execute(sql_script)
        conn.commit()

        logger.info("Task completed successfully.")
        return {'success': True}

    except Exception as e:
        logger.error(f"Error executing task {script_name}: {str(e)}")
        if conn:
            conn.rollback()
        return {'success': False, 'error': str(e)}
    finally:
        if conn:
            conn.close()


def update_dimension_tables(start_date, end_date, logger):
    from pipeline_dimensional_data.config import DIMENSION_TABLES

    overall_success = True
    config = get_sql_config()

    for table in DIMENSION_TABLES:
        script_name = f"update_{table.lower()}.sql"
        staging_table = table.replace('Dim', '')
        if table == "DimOrderDetails": staging_table = "Order Details"

        params = {
            'db_name': config['database'],
            'schema_name': config['schema'],
            'table_name': table,
            'staging_table': staging_table,
            'start_date': start_date,
            'end_date': end_date
        }

        result = execute_sql_task(script_name, params, logger)
        if not result['success']:
            overall_success = False
            break

    return {'success': overall_success}


def update_fact_orders(start_date, end_date, logger):
    config = get_sql_config()
    params = {
        'db_name': config['database'],
        'schema_name': config['schema'],
        'table_name': 'FactOrders',
        'start_date': start_date,
        'end_date': end_date
    }
    return execute_sql_task('update_fact.sql', params, logger)


def update_fact_error(start_date, end_date, logger):
    config = get_sql_config()
    params = {
        'db_name': config['database'],
        'schema_name': config['schema'],
        'table_name': 'Fact_Error',
        'start_date': start_date,
        'end_date': end_date
    }
    return execute_sql_task('update_fact_error.sql', params, logger)