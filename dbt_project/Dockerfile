FROM python:3

WORKDIR /usr/src/dbt_project

COPY ./ /usr/src/dbt_project

RUN pip install dbt \
  && pip install dbt-bigquery

RUN dbt deps

CMD ["bash"]