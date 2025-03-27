from google.oauth2 import service_account
from google.cloud import bigquery
import os
import pandas as pd

SERVICE_ACCOUNT_FILE = os.getenv("EDIT_KEYFILE_GCP")


def load_data_into_tables(files, dataset_name):
    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE
    )
    client = bigquery.Client(credentials=credentials)

    for file in files:
        data = pd.read_csv(file, index_col=[0]).reset_index(drop=True)
        table_name = file.split(".")[0]
        full_table_name = f"{dataset_name}.{table_name}"

        if not data.empty:
            client.load_table_from_dataframe(data, destination=full_table_name)
            print(f"Table {table_name} loaded successfully with {data.shape[0]} rows")
        else:
            print(f"Table {table_name} not loaded. Empty table.")


def main():
    files = ["promos.csv", "customers.csv", "transactions.csv"]
    dataset_name = "starbucks_raw"
    load_data_into_tables(files, dataset_name)


if __name__ == "__main__":
    main()
