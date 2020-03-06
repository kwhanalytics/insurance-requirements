# reference: https://hub.docker.com/_/ubuntu/
FROM ubuntu:18.04

# To avoid user being prompted for region during tzone installation in next command. Session hangs otherwise.
ENV DEBIAN_FRONTEND=noninteractive

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
	strace \
	build-essential \
	lsof \
	vim \
	curl \
	git \
	mc \
	sysstat \
	iotop \
	dstat \
	iptraf \
	screen \
	tmux \
	zsh \
	xfsprogs \
	libffi-dev \
	python-dev \
	python-tk \ 
	python-pip

# Install GEOS packages needed for basemap
# JD: This layer costs 516MB
RUN apt-get update && apt-get install -y \
	libgeos-c1v5 \
	libgeos-dev

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory to 
WORKDIR /root/

# Make directories to store requirements
RUN mkdir -p buildreqs/requirements

# Copy requirement files
COPY requirements.txt buildreqs/
# JD: Change this because its named different
COPY marvin-requirements.txt buildreqs/marvin-requirements.txt

# Install requirements
# Will also run buildreqs/marvin/requirements.txt since
# the insurance requirements file will point to marvin file
# JD: This layer costs 1.28GB
RUN pip install -r buildreqs/requirements.txt

# Run bash on startup
CMD ["/bin/bash"]
