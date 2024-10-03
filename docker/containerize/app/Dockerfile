FROM python:3.8-slim-buster

# Create a non-root user
RUN useradd -m appuser

WORKDIR /home/app/src

ENV FLASK_APP /home/app/src/server.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_RUN_PORT 8000
ENV FLASK_ENV development  

# Set appropriate permissions
RUN chmod -R 750 /home/app

COPY --chown=appuser:appuser . .

RUN pip install --no-cache-dir -r ./src/requirements.txt

# Switch to the non-root user
USER appuser

EXPOSE 8000

CMD ["flask", "run", "--reload"]

# Health check to ensure the service is up
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD curl --fail http://localhost:8000/ || exit 1
