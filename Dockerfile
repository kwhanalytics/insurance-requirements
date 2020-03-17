FROM ubuntu:18.04

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get -y update; apt-get -y install gnupg2 wget ca-certificates rpl pwgen

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update

RUN apt-get install -y postgresql-client-11 

RUN apt-get install -y postgresql-common 

RUN apt-get install -y postgresql-11
RUN apt-get install -y postgresql-11-postgis-2.5 
RUN apt-get install -y postgresql-11-pgrouting
RUN apt-get install -y netcat 
RUN apt-get install -y libpq-dev

# Move to root
WORKDIR /root/

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
	    python-dev \
        python-tk \
        python-pip \
        libgeos-c1v5 \
        libgeos-dev && \
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
