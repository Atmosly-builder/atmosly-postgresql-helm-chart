# Use a base image that has the necessary tools for the backup process
FROM postgres:latest

# Install necessary tools, e.g., awscli, postgresql-client, etc.
RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    apt-get install -y unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Set environment variables for database connection and S3 bucket
ENV POSTGRES_HOST="" \
    POSTGRES_USER="" \
    POSTGRESQL_BUCKET_RESTORE_URI="" \
    RESTORE_FILE_NAME="" \
    PGPASSWORD=""

RUN apt-get install -y zip

# Create a directory for the backup script
WORKDIR /restore

# Copy the restore script to the container
COPY restore_script.sh /restore/restore_script.sh

# Make the script executable
RUN chmod +x /restore/restore_script.sh

# Run the restore script when the container starts
CMD ["/bin/bash", "/restore/restore_script.sh"]