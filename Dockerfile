FROM node:14.18.1 AS builder
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git curl 
RUN mkdir /angular && \
    cd /angular && \
    git clone https://github.com/jomon1234/angular
WORKDIR /angular/angular
RUN npm install -g @angular/cli@13.2.1 && \
    npm ci && \
    npm install --save-dev @angular-devkit/build-angular@13.2.1 && \
    npm audit fix && \ 
    ng build --verbose
FROM nginx:1.21.4-alpine
EXPOSE 80
COPY --from=builder /angular/angular/src /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
