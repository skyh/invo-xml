'use strict';

const express = require('express');
const opn = require('opn');

const backend = express();
backend.use(express.static('src/pub'));

const server = backend.listen(8080);
const app = ['chrome', '--new-window'];

opn('http://localhost:8080/invoice-example.xml', {app});
