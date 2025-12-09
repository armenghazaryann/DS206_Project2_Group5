import configparser
import uuid
import os


def get_sql_config(config_file='sql_server_config.cfg', section='ORDER_DDS'):
    parser = configparser.ConfigParser()
    parser.read(config_file)
    if parser.has_section(section):
        return dict(parser.items(section))
    else:
        raise Exception(f'Section {section} not found in the {config_file} file')


def generate_uuid():
    return str(uuid.uuid4())


def read_sql_file(file_path, params=None):
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"SQL file not found: {file_path}")

    with open(file_path, 'r') as f:
        sql_content = f.read()

    if params:
        try:
            sql_content = sql_content.format(**params)
        except KeyError as e:
            raise Exception(f"Missing parameter in SQL format: {e}")

    return sql_content