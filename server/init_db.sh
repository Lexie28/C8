# DATABASE INIT SCRIPT
# Detta script gör följande:
# 1. Skapar databasen (tar även bort den gamla om den existerar)
# 2. Kör första database migrationen, dvs skapar alla tables i databasen.
# 3. Kör seed data vilket gör att databasen får lite data vilket kan användas för testning
# Saker som användarnman, databasnamn, lösenord, etc, hämtas från .env-filen

#Exporterar environment variables så att de kan användas i detta skript
export $(cat ./.env | xargs)

#Skapa en tom databas vid namn DATABASE_NAME. Går att göra manuellt om detta misslyckas. Logga in och kör
#dom två queries som finns efter "-e"
mysql -u${USER_NAME} -p${USER_PASSWORD} -e "drop database if exists ${DATABASE_NAME}; create database ${DATABASE_NAME};"

#Om det står något i stil med "knex not found", kör "npm install -g knex"
#(detta installerar knex globalt vilket gör att följande del fungerar)
knex migrate:latest
knex seed:run
