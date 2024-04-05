FROM node:20.12.1-bookworm AS builder

USER node

WORKDIR /app

COPY --chown=node:node package*.json ./

RUN npm install

COPY --chown=node:node tsconfig.json ./
COPY --chown=node:node src ./src

RUN npm run build

FROM node:20.12.1-bookworm

WORKDIR /app

USER node

COPY --chown=node:node --from=builder /app/node_modules ./node_modules
COPY --chown=node:node --from=builder /app/package.json ./package.json
COPY --chown=node:node --from=builder /app/package-lock.json ./package-lock.json

RUN ["npm", "prune", "--omit=dev"]

COPY --chown=node:node --from=builder /app/dist ./dist

EXPOSE 3000

CMD node dist/main.js
