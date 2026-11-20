FROM node:24 AS builder

WORKDIR /app/ 

RUN apt update && apt install rsync -y 

COPY /app/ /app/ 

RUN corepack enable && pnpm install --ignore-scripts --frozen-lockfile   

RUN pnpm nx run @aws/threat-composer:compile --excludeTaskDependencies

RUN pnpm nx run @aws/threat-composer:copy-assets --excludeTaskDependencies

RUN pnpm nx run @aws/threat-composer-app:compile:website --excludeTaskDependencies

# CMD ["serve", "-s", "/app/packages/threat-composer-app/build/website", "-l", "3000"]

FROM nginx/nginx-unprivileged:alpine3.24-perl

COPY --from=builder /app/packages/threat-composer-app/build/website /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080