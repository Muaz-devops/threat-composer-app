FROM node:24

WORKDIR /app/ 

RUN apt update && apt install rsync -y 

RUN npm install -g serve@14

COPY /app/ /app/ 

RUN corepack enable && pnpm install --ignore-scripts --frozen-lockfile   

RUN pnpm nx run @aws/threat-composer:compile --excludeTaskDependencies

RUN pnpm nx run @aws/threat-composer:copy-assets --excludeTaskDependencies

RUN pnpm nx run @aws/threat-composer-app:compile:website --excludeTaskDependencies

CMD ["serve", "-s", "/app/packages/threat-composer-app/build/website", "-l", "3000"]