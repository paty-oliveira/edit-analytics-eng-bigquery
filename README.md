## How to start
1. Fork this repository and clone it locally. If you're unsure how to fork a repository, check this tutorial.
2. Set up your local enviroment with [Docker](#setup-the-enviroment-with-docker) or [Python virtual environment](#setup-the-enviroment-with-python-virtual-environment).
3. Solve the exercises provided during the classroom sessions by committing your changes.
4. Once all exercises are completed, create a Pull request to this repository. If you're unsure how to create a pull request from a fork, refer to this tutorial.
5. Ensure your code passes the automated tests.

## Setup the enviroment with Docker
Firstly, ensure you have Docker installed and running.

### Pre-commit hooks
Ensure you have Python 3.12 installed in your machine.


1. Install pre-commit hooks by running the following command:

```
pre-commit install
```

2. Run pre-commit hooks against all the files

```
pre-commit run --all-files
```


### Add environment variables
1. Rename the `.env_edit` file to `.env` and fill up with the required information:
- `KEYFILE_PATH`: pointing to the path of Google Cloud Keyfile in your machine
- `GCP_PROJECT_ID`: BigQuery project identifier

2. Create a new environment variable called `SCHEMA_PREFIX` and set it to your first name. This variable will be used to add a prefix to BigQuery dataset. Make sure you store this environment variable in `~/.bashrc` or `~/.zshrc` (for MacOs users).

```
export SCHEMA_PREFIX='your_first_name'
```

### Build and start Docker container
Navigate to `starbucks_dw` folder and follow the instructions.

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

4. Now you are in an interactive terminal where you can run dbt commands. Run the following command to check if dbt is running properply:

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

### Add environment variables
Make sure you store all the environment variables in `~/.bashrc` or `~/.zshrc` (for MacOs users).


1. Make sure the `gcloud` command is installed on your computed. If not, use [this guide](https://cloud.google.com/sdk/docs/install) for it.

2. Activate `gcloud` authentication via terminal by running the following command:

```
gcloud auth application-default login
```

2. Create a new environment variabled called `PROJECT_ID` and set it to the BigQuery project identifier:

```
export PROJECT_ID="data-eng-dev-xxxx"
```


3. Create a new environment variable called `SCHEMA_PREFIX` and set it to your first name. This variable will be used to add a prefix to BigQuery dataset.

```
export SCHEMA_PREFIX='your_first_name'
```

### Create Python virtual environment

1. Create a Python virtual environment:

```
python3 -m venv venv
pip instal -U pip
```

2. Install Python dependencies:

```
pip install -r requirements.txt
```

3. Activate the virtual environment. Make sure you always have the virtual environment activated when running dbt.

```
source ./venv/bin/activate
```

4. Navigate to `starbucks_dw` folder and run the following command to check if dbt is running properply. All
the dbt commands must be executed under `starbucks_dw` folder.

```
dbt debug --profiles-dir .
```

5. Install pre-commit hooks by running the following command:

```
pre-commit install
```

6. Run pre-commit hooks against all the files

```
pre-commit run --all-files
```
