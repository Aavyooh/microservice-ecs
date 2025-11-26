const http = require('http');
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello from Microservice\n');
});
server.listen(80, () => console.log('Microservice running on port 80'));