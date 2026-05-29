# Use slim Python image for smaller size
FROM python:3.11

# Prevent Python from writing .pyc files and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy requirements first (for better caching)
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . /app/

# Create non-root user for security
RUN adduser --disabled-password appuser
USER appuser

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port
EXPOSE 8000

# Run with Gunicorn (production server)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "yourproject.wsgi:application"]
