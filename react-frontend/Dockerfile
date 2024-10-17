# react-frontend
FROM node:20.11.0

WORKDIR /react-frontend

COPY package*.json ./

# NPM縺ｮ繧｢繝・・繝・・繝医→繧ｿ繧､繝繧｢繧ｦ繝郁ｨｭ螳・
RUN npm install -g npm@latest \
    && npm config set fetch-retries 5 \
    && npm config set fetch-retry-factor 10 \
    && npm config set fetch-timeout 600000

RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]