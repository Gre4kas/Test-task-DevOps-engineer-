# --- Stage 1: Builder Stage ---
ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION}-slim AS builder

# Set the working directory
WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY ./app/requirements.txt .

# Install dependencies - leveraging virtual environment
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY ./app .

# --- Stage 2: Production Stage ---
FROM python:${PYTHON_VERSION}-slim

# Set the working directory
WORKDIR /app

# Create a non-root user
RUN addgroup --system appuser && \
    adduser --system --ingroup appuser appuser

# Copy the virtual environment and app code from the builder stage
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /app /app

# Set ownership of app directory to appuser
RUN chown -R appuser:appuser /app

# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Make port 8080 available to the outside world
EXPOSE 80

# Set environment variables 
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_DEBUG=0 

# Switch to the non-root user
USER appuser

# The HEALTHCHECK instruction
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl --fail http://localhost:80/health || exit 1

# Command to start the application using gunicorn 
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]