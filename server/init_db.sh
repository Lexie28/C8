#config (du kommer behöva ändra dessa värden)
#kanske går att plocka från .env men orkar inte lösa det just nu
USER_NAME="root"
PASSWORD="password123"
DATABASE_NAME="c8"

mysql -u${USER_NAME} -p${PASSWORD} -e "drop database ${DATABASE_NAME}; create database ${DATABASE_NAME};"
knex migrate:latest
knex seed:run
