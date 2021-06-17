'use strict';

var config = require('config')
var mongoose = require('mongoose');
const dotenv = require('dotenv');

const userMongo = process.env.MONGO_INITDB_ROOT_USERNAME;
const authMongo = process.env.AUTH_PART_MONGO;
const passMongo = process.env.MONGO_INITDB_ROOT_PASSWORD;
const dbMongo = process.env.MONGO_INITDB_DATABASE;
const host = (process.env.MONGO_HOST != null) ? process.env.MONGO_HOST : config.mongo.host;

var createMongoUri = function(config) {
    var uri = '',
        authPart = '';

    // Get authentication database part
    if (authMongo != "") {
        authPart = `?authSource=${authMongo}`;
    }

    uri += `mongodb://${host}:${config.port}/${dbMongo}${authPart}`;
    console.log('URIIIIIIIIIIII', uri)

    return uri;
};

mongoose.Promise = Promise;
mongoose.connect(createMongoUri(config.mongo), {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    user: userMongo,
    pass: passMongo
});

var db = mongoose.connection;
db
 .once('open', () => console.log('Good to go!'))
 .on('error', (error) => {
 console.error('Error : ', error);
 });

module.exports = db;
