FROM python:3.11-slim AS deps-resolver

# Set environment variables for cleaner installation
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /build

# Install only necessary system utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Pre-install dependencies to use Docker layer caching
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --user --no-cache-dir -r requirements.txt


# Stage 2: Final Production Image
FROM python:3.11-slim

# Create a non-privileged user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /home/appuser/app

# Import installed packages from the previous stage
COPY --from=deps-resolver /root/.local /home/appuser/.local

# Add the local bin to PATH so commands work
ENV PATH=/home/appuser/.local/bin:$PATH

# Copy the application source
COPY --chown=appuser:appuser . .

# Switch to the non-root user
USER appuser

EXPOSE 8000

# Launch the application
ENTRYPOINT ["uvicorn"]
CMD ["app.main:app", "--host", "0.0.0.0", "--port", "8000"]
