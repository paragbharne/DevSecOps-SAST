
# ---------- Stage 1: Build ----------
FROM python:3.13-alpine as builder

WORKDIR /app

# Install build dependencies only temporarily
RUN apk add --no-cache build-base libffi-dev

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# ---------- Stage 2: Runtime ----------
FROM python:3.13-alpine

LABEL maintainer="paragbharne"
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1


# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appgroup app.py .

# Secure permissions
RUN chmod -R 755 /app

USER appuser
EXPOSE 5000

# Read-only filesystem (add in runtime flags)
VOLUME ["/tmp"]

CMD ["python", "app.py"]
