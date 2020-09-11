'use strict';

var config = require('config')
var mongoose = require('mongoose');

var createMongoUri = function(config) {
    var uri = '',
        authPart = '';

    // Get authentication database part
    if (config.hasOwnProperty('authdb') && config.authdb) {
        authPart = `?authSource=${config.authdb}`;
    }

    uri += `mongodb://${config.host}:${config.port}/${config.db}${authPart}`;
    console.log('URIIIIIIIIIIII', uri)

    return uri;
};

mongoose.Promise = Promise;
var db = mongoose.connect(createMongoUri(config.mongo), {
    useMongoClient: true, 
    user: config.mongo.user, 
    pass: config.mongo.pass
});

db.on('error', function(error) {
    console.error('MongoDB connection error: ' + error);
});

db.on('connected', function() {
    console.log('connected to MongoDB');
});

module.exports = db;
