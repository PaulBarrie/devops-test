#!/usr/bin/env node
'use strict';

var nodemon = require('nodemon');
var path = require('path');

var PRODUCTION = process.env.NODE_ENV === 'production';

nodemon({
    execMap: {
        js: 'node'
    },
    script: path.join(__dirname, 'server'),
    ignore: [],
    watch: !PRODUCTION ? ['*.*']: false,
    ext: 'js json yml twig'
}).on('start', function () {
  console.log('App has started');
}).on('quit', function () {
  console.log('App has quit');
  process.exit();
}).on('restart', function (files) {
  console.log('App restarted due to: ', files);
});
