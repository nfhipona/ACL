'use strict';

const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// handles unknown routes
app.all('*', (req, res, next) => {
    if (req.method !== 'OPTIONS') {
        // 204 No Content
        res
            .status(201)
            .send({
                success: true,
                message: "No content"
            })
            .end();
        return;
    }
    next();
});

const http = require('http');
const httpServer = http.createServer(app);
const httpPort = 1111;

httpServer.listen(httpPort, () => {
    console.log(
        `Listening on port: ${httpPort}\n`
    );
});