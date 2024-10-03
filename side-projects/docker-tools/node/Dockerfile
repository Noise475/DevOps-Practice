FROM node:16.14.2-alpine

RUN useradd -m appuser

WORKDIR /home/node

COPY --chown=appuser:appuser . .

USER appuser

RUN npm install

CMD ["npm", "start"]
