export $(cat ./.env | xargs)


mysql -u${USER_NAME} -p${USER_PASSWORD} -e "drop database if exists ${DATABASE_NAME}; create database ${DATABASE_NAME};"
knex migrate:latest
knex seed:run
