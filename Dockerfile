ARG NODE_VERSION=13
ARG NGINX_VERSION=alpine

FROM node:${NODE_VERSION} as build
WORKDIR /app

COPY package.json .
COPY yarn.lock .
RUN yarn install

COPY . . 
RUN yarn build --prod

FROM nginx:${NGINX_VERSION}
COPY --from=build /app/dist/ClientApp  /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY scripts/patch-config.sh /docker-entrypoint.d
RUN apk update --no-cache && \
    apk add jq
#EXPOSE 80
