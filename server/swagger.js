const swaggerAutogen = require('swagger-autogen')();

const outputFile = './swagger_output.json';
const endpointsFiles = ["./routes/listing.js", "./routes/offer.js", "./routes/pages.js", "./routes/user.js"];

swaggerAutogen(outputFile, endpointsFiles);
