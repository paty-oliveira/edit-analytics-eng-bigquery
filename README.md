## How to start
WIP


## Setup the enviroment with Docker
Firstly, ensure you have Docker installed and running. Next, navigate to `starbucks_dw` folder and follow the following instructions.

### Setup environment variables
1. Rename the `.env_edit` file to `.env` and fill up with the required information:
- Google Cloud Keyfile path: `KEYFILE_PATH`
- BigQuery Project id: `GCP_PROJECT_ID`

2. Create a new environment variable called `SCHEMA_PREFIX` and set it to your first name. This variable will be used to add a prefix to BigQuery dataset. Make sure you store this environment variable in `~/.bashrc` or `~/.zshrc` (for MacOs users).

```
export SCHEMA_PREFIX='your_first_name'
```

### Build and start Docker container

1. Build and start the container:

```
docker compose up --build -d
```

2. Check if the container is running:

```
docker ps
```

3. Run container in interactive mode with a bash terminal:

```
docker compose exec dbt bash
```

4. Now you are in an interactive terminal where you can run dbt commands. Run the following to check if dbt is running properply:

```
dbt debug
```

5. To close the terminal, type:

```
exit
```

6. To stop the dbt container, run the following command:

```
docker compose stop dbt
```


## Setup the enviroment with Python virtual environment
Ensure you have Python 3.12 installed in your machine.


### Setup environment variables
Make sure you store all the environment variables in `~/.bashrc` or `~/.zshrc` (for MacOs users).


1. Create a new environment variable called `GOOGLE_APPLICATION_CREDENTIALS` and set it to the path you store the Keyfile of Google Cloud.

```
export GOOGLE_APPLICATION_CREDENTIALS="/Users/user1/gcp_keys/service_account.json"
```

2. Create a new environment variabled called `PROJECT_ID` and set it to the BigQuery project id:

```
export EDIT_PROJECT_ID="data-eng-dev-xxxx"
```


3. Create a new environment variable called `SCHEMA_PREFIX` and set it to your first name. This variable will be used to add a prefix to BigQuery dataset.

```
export SCHEMA_PREFIX='your_first_name'
```

### Setup Python virtual environment

WIP
