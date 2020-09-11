
FROM node:latest

RUN mkdir -p /usr/src/app && mkdir -p /tmp/uploader && mkdir -p /usr/src/app/uploaded
COPY . /usr/src/app
WORKDIR /usr/src/app

RUN npm install

COPY package*.json /usr/src/app

# #Prepare folder and add depedencies
# RUN mkdir -p /tmp/uploader
# COPY uploader-app/package*.json ./
# #Add specify install for webpack
# RUN npm install webpack -g
# WORKDIR /tmp
# COPY uploader-app/package.json /tmp/
# RUN npm config set registry http://registry.npmjs.org/ && npm install

# #Install rest of depedencies
# WORKDIR /usr/src/app
# COPY uploader-app/ /usr/src/app/

# RUN mkdir -p /usr/src/app/uploaded
# RUN cp -a /tmp/node_modules /usr/src/app/

# #Build the app
# RUN npm run build

#Run + expose 3000 port
EXPOSE 3000

#Start
CMD [ "npm", "run", "start" ]