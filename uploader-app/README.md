Uploader Example App
====================

A [NodeJS](https://nodejs.org/en/)  example application built with :

* [express 4](http://expressjs.com/)
* [mongoose](http://mongoosejs.com/)
* [webpack](https://webpack.js.org/)
* [boostrap 4](http://getbootstrap.com/)

This application is just a web form to upload files on server.
The uploaded files are stored on server filesystem and some metadata  are stored in a MongoDB database.

see the [TODO.md](https://gitlab.com/pierr/uploader-app/blob/master/TODO.md) for exercises

Requirements
------------

* [NodeJS](https://nodejs.org/en/) >= 8.0
* [MongoDB](https://docs.mongodb.com/manual/) >= 3.4 , < 3.6 


Install
-------

### Configuration

This application use [node config](https://github.com/lorenwest/node-config). 

So you need :

* to set Environment Variables defined in `config/custom-environment-variables.yml` which override `config/default.yml`

```sh
# mongoDB connection parameters
MONGO_HOST=
MONGO_PORT=
MONGO_USER=
MONGO_PASSWORD= 
# database name
MONGO_DB=
# optional authentication database 
MONGO_AUTHDB=

# temporary directory for uploaded file
UPLOADER_TMP_PATH=
# final storage directory for saved file
UPLOADER_STORAGE_PATH=

# cookie session secret : must be changed
UPLOADER_SESSION_SECRET= 
```

* **OR** to create a `config/local.yml` to override `config/default.yml` 

```yml
# mongoDB connection parameters
mongo:
    host: localhost
    port: 27017
    user:
    pass:
    # database name
    db: uploader
    # optional authentication database 
    authdb:

# uploaded files storage path
# can be absolute or relative to node process working directory
upload:
    # temporary uploads directory
    tmp_path: /tmp/uploader
    # final storage directory
    storage_path: uploaded

# cookie session configuration
session:
    # secret : must be changed
    secret: '<session-secret>'

```

### installing vendors

```sh
npm install
```

### Building application

* `development` mode

    ```sh
    npm run build-dev
    ```

* `production` mode

    ```sh
    npm run build
    ```

### Running the application

It will listen on port `3000`.

http://localhost:3000/

* `development` mode

    ```sh
    npm run start-dev
    ```

* `production` mode

    ```sh
    npm start
    ```
