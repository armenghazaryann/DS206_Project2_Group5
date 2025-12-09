import logging
import os


def setup_logger(execution_id):
    log_dir = "logs"
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    log_filename = os.path.join(log_dir, "logs_dimensional_data_pipeline.txt")

    formatter = logging.Formatter(
        f'%(asctime)s - {execution_id} - %(name)s - %(levelname)s - %(message)s'
    )

    logger = logging.getLogger("DimensionalDataFlow")
    logger.setLevel(logging.INFO)

    file_handler = logging.FileHandler(log_filename)
    file_handler.setFormatter(formatter)

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)

    if not logger.handlers:
        logger.addHandler(file_handler)
        logger.addHandler(console_handler)

    return logger