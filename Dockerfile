# Etapa 1: Construcción
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

# Etapa 2: Producción
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app ./
RUN npm ci --omit=dev

ENV NODE_ENV=production
ENV NODE_OPTIONS=--openssl-legacy-provider

EXPOSE 5000

CMD ["npm", "start"]
