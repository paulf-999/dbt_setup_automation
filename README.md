## DBT (Project) Setup Automation

Script to automate the setup steps required when initially creating a DBT project.

### How-to run:

The steps involved in building and executing involve:

1) Populate the 4 variables at the top of the makefile, i.e.:
    * `DBT_PROFILE_NAME`
    * `DBT_PROJECT_NAME`
    * `PROGRAM`
    * and `DBT_MODEL`
2) and running `make`!

---

### High-level summary

A `makefile` has been used to orchestrate the steps required to create setup a DBT project. Where these steps consist of:

1) Installing DBT using brew (if required)
2) Initialising a DBT project (`dbt_project.yml`), including steps to:
    * populating parameterized args
    * copy predefined:
        - DBT profiles (`profiles.yml`)
        - models
        - tests
        - and sources (within `schema.yml` file)
3) Setup `dbt_project.yml` file:
    * the file created in step 2 needs to be configured
    * this step automates the configuration, using templates and parameterized args
4) Validate the database connection

### Note:

* The sql files within `models/analytics_db` are just examples, to indicate the typical contents of such files
