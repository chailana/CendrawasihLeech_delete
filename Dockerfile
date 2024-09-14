FROM breakdowns/mega-sdk-python:latest

# Create and set permissions for the directory
RUN mkdir -p /CendrawasihLeech && chmod 777 /CendrawasihLeech
WORKDIR /CendrawasihLeech

# Set timezone environment variable
ENV TZ=Asia/Jakarta

# Update and clean up APT cache
RUN apt -qq update --fix-missing && \
    apt -qq upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Install rclone
RUN wget https://rclone.org/install.sh && \
    bash install.sh

# Create necessary directories
RUN mkdir -p /CendrawasihLeech/Leech

# Download and extract gclone
RUN wget -O /CendrawasihLeech/Leech/gclone.gz https://git.io/JJMSG && \
    gzip -d /CendrawasihLeech/Leech/gclone.gz

# Attempt to download font (replace URL with valid one)
# If the URL is invalid or file is not necessary, consider removing this line
RUN wget -O /usr/share/fonts/Hack-Bold.ttf http://example.com/valid-font-url.ttf

# Set permissions for gclone
RUN chmod 0775 /CendrawasihLeech/Leech/gclone

# Install Python requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy other necessary files
COPY . .
COPY extract /usr/local/bin
COPY .netrc $HOME/.netrc

# Set correct permissions for .netrc
RUN touch $HOME/.netrc && chmod 600 $HOME/.netrc

# Define the default command
CMD ["bash", "start.sh"]
