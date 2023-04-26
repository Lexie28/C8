# Circle 8 back-end
Här är en guide till hur man använder detta program.
## Automatisk skapande av databas med seed data
(Om du använder windows, observera att du behöver göra följande i WSL)
1. Kör ```cp .env_template .env```
2. Öppna filen .env i en textredigerare och fyll i all information

(Nu har du fixat alla environment variables. Det behövs endast göras en gång) 

3. Kör ```npm install``` för att installera alla dependencies

4. Skapa servern genom att köra ```./init_db.sh```. Om något går snett, läs 

i ```./init_db.sh``` där vanliga problem  bemöts.

#### Du är nu redo att starta servern!

## Automatisk dokumentation för API-gränssnitt
1. Kör ```npm run swagger-autogen```
2. Starta servern
3. Gå in på routen "doc" (exempel på URL: http://localhost:3000/doc/). Där finns dokumentationen.


