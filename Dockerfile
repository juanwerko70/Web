
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

COPY CART3R_JAILBREAK_HaloAI_V4_CodeLab.zip /tmp/cart3r.zip

RUN mkdir -p /app/src \
    && unzip -q /tmp/cart3r.zip -d /app/src \
    && rm /tmp/cart3r.zip \
    && APP_DIR="$(dirname "$(find /app/src -name app.py -print -quit)")" \
    && test -n "$APP_DIR" \
    && test -f "$APP_DIR/requirements.txt" \
    && pip install --no-cache-dir -r "$APP_DIR/requirements.txt" gunicorn psycopg2-binary

CMD ["sh", "-c", "APP_FILE=$(find /app/src -name app.py -print -quit); cd $(dirname \"$APP_FILE\"); exec gunicorn --workers 2 --threads 4 --timeout 60 --bind 0.0.0.0:${PORT:-8080} app:app"]
