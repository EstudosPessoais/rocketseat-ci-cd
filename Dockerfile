FROM node:20-slim AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
COPY .yarn ./.yarn

COPY . .

RUN yarn install
RUN yarn build
RUN yarn cache clean 

FROM node:20-slim

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start:prod"]