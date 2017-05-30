'use strict';

const express = require('express');
const opn = require('opn');
const serveIndex = require('serve-index');

const backend = express();
backend.use(serveIndex('src/pub', {icons: false, filter: (file) => /\.xml$/.test(file)}));
backend.use(express.static('src/pub'));

const port = 8080;
const server = backend.listen(port);
const app = ['chrome', '--new-window'];

// opn('http://localhost:8080/invoice-example.xml', {app});

console.log(`Open http://localhost:${port}`);
