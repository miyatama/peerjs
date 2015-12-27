var https = require('https');
var fs = require('fs');
var express = require('express');
var app = express();
var corser = require('corser');
var ExpressPeerServer = require('peer').ExpressPeerServer;

var sslOptions = {
  key: fs.readFileSync('../sslkey/server.key'),
  cert: fs.readFileSync('../sslkey/server.crt'),
  ca: fs.readFileSync('../sslkey/ca.crt'),
  requestCert: true,
  rejectUnauthorized: false
};

app.get('/', function(req, res, next) { 
  res.send('welcome to peer server'); 
});

var server = https.createServer(sslOptions, app);

var options = {
    debug: true,
    key: "peerjs"
};

app.use(corser.create());
app.use('/api', ExpressPeerServer(server, options));

server.listen(9000);
