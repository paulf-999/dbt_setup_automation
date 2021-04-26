default: init_dbt_project setup_dbt_project_file validate_conn

export DBT_PROFILE_NAME=#e.g., eg_profile_name
export DBT_PROJECT_NAME=#e.g., dbt_demo_eg
export PROGRAM=#e.g., JBLOGGS_DEMO
export DBT_MODEL=#e.g., analytics_db

deps:
	$(info [+] Install dependencies (dbt))
	pip install --upgrade dbt
	brew install gettext
	brew link --force gettext
	brew install gnu-sed

init_dbt_project:
	$(info [+] Initialise dbt project)
	@echo
	###############################################################
	# call 'init_dbt_project'
	###############################################################
	@echo
	@[ "${DBT_PROJECT_NAME}" ] || ( echo "\nError: DBT_PROJECT_NAME variable is not set\n"; exit 1 )
	@[ "${DBT_PROFILE_NAME}" ] || ( echo "\nError: DBT_PROFILE_NAME variable is not set\n"; exit 1 )
	@#populate profiles/profiles.yml with ${DBT_PROFILE_NAME} var
	@envsubst < templates/profiles.yml > profiles/profiles.yml
	@dbt init ${DBT_PROJECT_NAME} --profiles-dir=profiles 2>/dev/null
	@#copy profiles and model dirs into project folder
	@cp -r profiles/ ${DBT_PROJECT_NAME}/profiles
	@cp -r models/ ${DBT_PROJECT_NAME}/models
	@cp -r tests/ ${DBT_PROJECT_NAME}/models
	@#copy schema.yml (data model tests) to project folder
	@cp schema.yml ${DBT_PROJECT_NAME}/models
	@rm -r ${DBT_PROJECT_NAME}/models/example
	###############################################################
	# call 'setup_dbt_project_file'
	###############################################################
	@echo

setup_dbt_project_file:
	$(info [+] generate profiles.yml inside project folder file)
	@echo
	@#change profile name in dbt_project.yml file
	@sed -i -e "s/profile: 'default'/profile: '${DBT_PROFILE_NAME}'/g" ${DBT_PROJECT_NAME}/dbt_project.yml
	@#change project name in dbt_project.yml file
	@sed -i -e 's/my_new_project/${DBT_PROJECT_NAME}/g' ${DBT_PROJECT_NAME}/dbt_project.yml
	@rm ${DBT_PROJECT_NAME}/dbt_project.yml-e

validate_conn:
	cd ${DBT_PROJECT_NAME} && dbt debug --profiles-dir=profiles

run_model:
	cd ${DBT_PROJECT_NAME} && dbt run --profiles-dir profiles --models ${DBT_MODEL}

test_model:
	#prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	cd ${DBT_PROJECT_NAME} && dbt test --profiles-dir profiles --models ${DBT_MODEL_NAME}

data_test_model:
	#prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	cd ${DBT_PROJECT_NAME} && dbt test --data --profiles-dir profiles --models ${DBT_MODEL_NAME}

document_model:
	cd ${DBT_PROJECT_NAME} && dbt docs generate --profiles-dir profiles --models ${DBT_MODEL_NAME}
	cd ${DBT_PROJECT_NAME} && dbt docs serve --profiles-dir profiles
