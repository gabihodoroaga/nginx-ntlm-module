const util = require('util')
const express = require('express')
const PORT1 = process.env.NGX_TEST_UPS1_PORT || 19841
const PORT2 = process.env.NGX_TEST_UPS2_PORT || 19842
const KEEP_ALIVE = process.env.NGX_TEST_UPS_KEEP_ALIVE || 300_000

// This is a very simple request handler that will try to emulate the 
// connection based authentication (like NTLM or Kerberos).
// If the request contains the NTLM or Negotiate in the Authorization header
// the value is saved into the connection object and is added as custom header
// (X-NGX-NTLM-AUTH) for all subsequent request  
var requestHandler = (app, req, res) => {
    console.log(`[${app}] response received`);
    if (req.headers["authorization"]) {
        console.log(`[${app}] authorization header received`);
        var tokenValue = "";
        pattern = /(NTLM|Negotiate) (.*)$/;
        var match = pattern.exec(req.headers["authorization"]);
        if (match) {
            tokenValue = match[2];
            console.log(`[${app}] found token in header '${tokenValue}'`);
        }
        if (!req.connection.xauthData) {
            req.connection.xauthData = tokenValue;
            console.log(`[${app}] token saved to connection '${tokenValue}'`);
        }
    }
    if (req.connection.xauthData) {
        res.setHeader('X-NGX-NTLM-AUTH', req.connection.xauthData);
        console.log(`[${app}] found token on connection '${req.connection.xauthData}`);
    }
    res.send('OK');
    console.log(`[${app}] response sent`);
}

const app1 = express();
app1.get('/*', (req, res) => {
    requestHandler("app1", req,res);
});
var server1 = app1.listen(PORT1, () => {
    console.log(`[app1] upstream listening at http://localhost:${PORT1}`);
});
server1.keepAliveTimeout = KEEP_ALIVE;

const app2 = express();
app2.get('/*', (req, res) => {
     requestHandler("app2",req,res);
});
var server2 = app2.listen(PORT2, () => {
    console.log(`[app2] upstream listening at http://localhost:${PORT2}`);
});
server2.keepAliveTimeout = KEEP_ALIVE;

// Hack console log to print data
var log = console.log;
console.log = function () {
    var args = [].slice.call(arguments);
    log.apply(console, [(new Date()).toISOString()].concat(args));
};
