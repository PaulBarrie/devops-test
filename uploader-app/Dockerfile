#########################################
# Stage 1 : Initialize the env argument #
#########################################
FROM node:10-slim as init

ARG ENV_APP
ENV ENV_APP=$ENV_APP


################################################
# Stage 2 : Install dependencies and build app #
################################################
FROM init as builder

WORKDIR /yarn_installer/

COPY ["webpack.config.js", "server-dev.js", "package.json", "yarn.lock", "server.js", "./"]
COPY frontend ./frontend

RUN yarn install
RUN yarn "build-$ENV_APP"


#####################
# Stage 3 : Run App #
#####################

FROM init
WORKDIR /usr/src/app

RUN groupadd -g 1001 appgroup && \
    useradd -r -u 1001 -g 1001 appuser

RUN mkdir uploaded && \
    chown 1001:1001 uploaded

COPY --from=builder --chown=1001:1001 yarn_installer/ ./
COPY --chown=1001:1001 config ./config/
COPY --chown=1001:1001 backend ./backend/

USER appuser

RUN mkdir -p /tmp/uploader


EXPOSE 3000
ENTRYPOINT yarn start-$ENV_APP
