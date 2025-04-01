FROM python:3.12-slim

# Run update and install git
RUN apt-get update && apt-get install -y \
  git \
  && apt-get clean

# Install dbt
RUN pip install dbt-core dbt-bigquery

# Create folder to store GCP secrets
RUN mkdir -p /root/secrets

# Create dbt profiles directory
RUN mkdir -p /root/.dbt

# Copy profiles.yml to dbt profiles directory
COPY ./profiles.yml /root/.dbt/profiles.yml

ENV DBT_PROFILES_DIR=/root/.dbt

# Copy dbt project to /opt/dbt
COPY . /opt/dbt/

# Set working directory
WORKDIR /opt/dbt/

# Install dbt dependencies
RUN dbt deps

CMD ["tail", "-f", "/dev/null"]
