'use strict';

var db = require('./databases');
var mongoose = require('mongoose');

var fileSchema = mongoose.Schema({
    uuid: {
        type: String,
        index: true,
        unique: true
    },
    originalname: String,
    path: String,
    mimetype: String,
    size: Number
});

module.exports = {
    UploadedFile: db.model('UploadedFile', fileSchema)
};
