# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY . .

# Install necessary system packages
RUN apt-get update && apt-get install -y curl gnupg2 unixodbc unixodbc-dev

# Add Microsoft GPG key securely
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc \
    -o /usr/share/keyrings/microsoft.asc.gpg

# Add Microsoft SQL Server ODBC repo
RUN echo "deb [signed-by=/usr/share/keyrings/microsoft.asc.gpg] https://packages.microsoft.com/config/debian/10/prod.list stable main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Install the SQL Server ODBC driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
