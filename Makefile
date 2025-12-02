.PHONY: deps seed run test docs lint fix all

deps:
	@dbt deps

seed:
	@dbt seed

run:
	@dbt run

test:
	@dbt test

docs:
	@dbt docs generate

lint:
	@sqlfluff lint dbt

fix:
	@sqlfluff fix dbt

all: deps seed run test
