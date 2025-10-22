FROM python:3.9-bullseye

WORKDIR /app

COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y curl gnupg2 unixodbc unixodbc-dev

# Add Microsoft GPG key (correct way for signed-by)
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

# Add Microsoft SQL Server ODBC repo (for Debian 11)
RUN echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/11/prod bullseye main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Install the ODBC driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
