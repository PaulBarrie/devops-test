'use strict';

const path = require('path');
const fs = require('fs');

var checkPath = function(filepath, defaultPath = undefined) {
    filepath = resolvePath(filepath, defaultPath);

    try {
        fs.accessSync(filepath);
    } catch (e) {
        console.log(e);
        if (e.code === 'ENOENT') {
            fs.mkdirSync(filepath, 0o755);
        }
    }
    
    return filepath;
};

var resolvePath = function(filepath, defaultPath = undefined) {
    if (!filepath && defaultPath) {
        filepath = path.resolve(defaultPath);
    }

    if (!path.isAbsolute(filepath)) {
        filepath = path.resolve(path.join(process.cwd(), filepath));
    }
    
    return filepath;
};

module.exports = {
    checkPath,
    resolvePath
};
