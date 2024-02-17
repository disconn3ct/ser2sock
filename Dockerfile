#
# Serial to socket interface server
#
# Copied largely from:
# http://github.com/tenstartups/ser2sock
#

FROM alpine:latest

# LABEL maintainer="Marc Lennox <marc.lennox@gmail.com>"

# Set environment variables.
ENV \
  PAGER=more \
  LISTENER_PORT=10000 \
  BAUD_RATE=9600 \
  TERM=xterm-color

# Install packages.
RUN \
  apk --update --no-cache add \
    build-base \
    git \
    libressl-dev

COPY . /src

WORKDIR /src

# Install the ser2sock application.
RUN \
  ./configure && \
  make

FROM alpine:latest

RUN apk --update --no-cache add libressl

# Add files to the container.

COPY --from=0 /src/ser2sock /usr/local/bin/
COPY --from=0 /src/etc/ser2sock /etc/

COPY entrypoint.sh /docker-entrypoint

# Set the entrypoint script.
ENTRYPOINT ["/docker-entrypoint"]

# Expose the listener port
EXPOSE ${LISTENER_PORT}

# Fix https://github.com/hertzg/rtl_433_docker/issues/101#issuecomment-1850605794
RUN apk --no-cache add libressl3.8-libssl
