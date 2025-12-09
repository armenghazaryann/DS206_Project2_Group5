import argparse
import sys

sys.path.append('.')

from pipeline_dimensional_data.flow import DimensionalDataFlow


def main():
    parser = argparse.ArgumentParser(description="Run the Dimensional Data Pipeline")
    parser.add_argument('--start_date', required=True, help='Start date in YYYY-MM-DD format')
    parser.add_argument('--end_date', required=True, help='End date in YYYY-MM-DD format')

    args = parser.parse_args()

    try:
        pipeline = DimensionalDataFlow()
        pipeline.exec(args.start_date, args.end_date)
    except Exception as e:
        print(f"Critical Failure: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()