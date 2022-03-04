'use strict';

var express = require('express');
var path = require('path');
var fs = require('fs');
var uuidv1 = require('uuid/v1');
var config = require('config');
var multer  = require('multer');
var upload  = multer({dest: "/tmp/upload"});
var router = express.Router();

var UploadedFile = require('../model').UploadedFile;

var saveFile = function (file, dest) {
    return new Promise(function(resolve, reject) {
        var uuid = uuidv1();
        var newpath = path.join(dest, uuid);
        fs.copyFile(file.path, newpath, function (err) {
            if (err) throw err;
            fs.stat(newpath, function (err, stats) {
                if (err) throw err;

                var newFile = UploadedFile({
                    uuid: uuid,
                    originalname: file.originalname,
                    path: newpath,
                    mimetype: file.mimetype,
                    size: file.size
                });

                newFile.save(function (err, newuploaded, numAffected) {
                  if (err) throw err;

                  resolve(numAffected);
                });

            });
        });
    });
};

router.get('/', function(req, res, next) {
    UploadedFile.find({}).exec(function(err, files) {
        if (err) {
          console.error(err);
          throw err;
        }
        
        res.render('upload', { 
            title: 'Le musée des horreurs' , 
            messages: req.flash(),
            files: files
        });        
    });
});

router.post('/upload', upload.array('files', 10), function(req, res, next) {
    var promises = [];
    for (var f of req.files) {
        promises.push(saveFile(f, "/usr/src/app/uploaded"));
    }
    
    Promise.all(promises)
    .then(function (savedFiles) {
        var total = 0;
        for(var i of savedFiles ) {
            total += parseInt(i);
        }
        req.flash('info', '%d files were saved', total);
        res.redirect('/');
    }).catch(function (err) {
        req.flash('error', err);
        res.redirect('/');
    });
});

router.get('/download/:uuid/:filename', function(req, res, next) {
    UploadedFile.findOne({ uuid: req.params.uuid, originalname: req.params.filename})
    .exec(function(err, file) {
        if (err) {
          console.error(err);
          throw err;
        }
        res.download(file.path, file.originalname);
    });
});

module.exports = router;
