import sys
import os

# This block ensures that when flow.py runs, it can find files in the root folder (like loggings.py)
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from loggings import setup_logger
from utils import generate_uuid
from pipeline_dimensional_data import tasks


class DimensionalDataFlow:
    def __init__(self):
        # Generate a unique ID for this execution run
        self.execution_id = generate_uuid()

        # Initialize the logger using your custom function from loggings.py
        self.logger = setup_logger(self.execution_id)

        self.logger.info(f"Pipeline initialized with Execution ID: {self.execution_id}")

    def exec(self, start_date, end_date):
        self.logger.info(f"Starting pipeline execution for period: {start_date} to {end_date}")

        # Step 1: Update Dimensions
        self.logger.info("Step 1: Updating Dimensions...")
        dim_result = tasks.update_dimension_tables(start_date, end_date, self.logger)

        if dim_result['success']:
            self.logger.info("Dimensions updated successfully.")

            # Step 2: Update Fact Table
            self.logger.info("Step 2: Updating Fact Table...")
            fact_result = tasks.update_fact_orders(start_date, end_date, self.logger)

            if fact_result['success']:
                self.logger.info("Fact Table updated successfully.")
            else:
                self.logger.error("Fact Table update failed. Skipping Error Table ingestion.")
                return  # Stop pipeline logic here if Fact fails

            # Step 3: Capture Errors
            self.logger.info("Step 3: Capturing Errors...")
            err_result = tasks.update_fact_error(start_date, end_date, self.logger)

            if err_result['success']:
                self.logger.info("Error Table updated successfully.")
                self.logger.info("Pipeline Execution Completed Successfully.")
            else:
                self.logger.error("Error Table update failed.")
        else:
            self.logger.error("Dimension update failed. Aborting pipeline.")