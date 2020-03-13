# reference: https://hub.docker.com/_/ubuntu/
FROM ubuntu:18.04

# To avoid user being prompted for region during tzone installation in next command. Session hangs otherwise.
ENV DEBIAN_FRONTEND=noninteractive

# Move to root
WORKDIR /root/

# Get Postgres 11
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Install Ubuntu packages
# Install GEOS packages needed for basemap
# This layer costs 487MB in total
# Combined apt-get update install lines and added one more cleaning function
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
	python-dev python-tk python-pip \
	libgeos-c1v5 libgeos-dev \
	postgresql-client-11 postgresql-common postgresql-11 postgresql-11-postgis-2.5 postgresql-11-pgrouting \
	netcat libpq-dev && \
    apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
    mkdir -p buildreqs/requirements

# Copy requirement files
COPY requirements.txt buildreqs/
COPY marvin-requirements.txt buildreqs/marvin-requirements.txt

# Install requirements
# Will also run buildreqs/marvin/requirements.txt since
# the insurance requirements file will point to marvin file
# This layer costs 1.28GB - not sure how to fix this issue.
RUN pip --no-cache-dir install -r buildreqs/requirements.txt

# Run bash on startup
CMD ["/bin/bash"]
