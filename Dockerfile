# ****************************************************************************************************
# Stage 1: Java Stage
#
# Pre-Built java binary and associated libraries are copied from this container image.
# ****************************************************************************************************
# https://hub.docker.com/layers/library/eclipse-temurin/21-jre-alpine/images/sha256-008d50b2730a72e475bfdfe651149d68180dc2689b808afb8b0bc669b3262a59
FROM eclipse-temurin:21-jre-alpine as java-stage

# ****************************************************************************************************
# Stage 1: Python Stage
#
# Pre-Built python binary and associated libraries are copied from this container image.
# The /app folder is setup.
# ****************************************************************************************************
# https://hub.docker.com/layers/library/python/3.12.8-alpine3.21/images/sha256-f92e36f6569658ba9501e2e1e3ca780d61faea8e84edd990a0ed70d0ca8add4a
FROM python:3.12.8-alpine3.21 as python-stage

RUN apk update && apk add --no-cache curl unzip

# We will put everything in the /app directory
WORKDIR /app

# Download and unzip client portal gateway
RUN mkdir gateway && cd gateway && \
    curl -O https://download2.interactivebrokers.com/portal/clientportal.gw.zip && \
    unzip clientportal.gw.zip && rm clientportal.gw.zip

# Copy our config so that the gateway will use it
COPY ib_gateway/conf.yaml /app/gateway/root/conf.yaml
COPY start.sh /app
COPY ib_rest_api/ /app/ib_rest_api
COPY requirements.txt /app/requirements.txt

# Install the dependencies
RUN python3 -m venv .venv \
    && . .venv/bin/activate \
    && pip install -r requirements.txt \
    && rm /app/requirements.txt

RUN ls -Al
RUN pwd

# ****************************************************************************************************
# Stage 3: Final Stage
#
# The Final Stage does not contain any unnecessary applications reducing its security footprint.
# ****************************************************************************************************
# https://hub.docker.com/layers/library/alpine/3.21.0/images/sha256-2c43f33bd1502ec7818bce9eea60e062d04eeadc4aa31cad9dabecb1e48b647b
FROM alpine:3.21.0

# Set environment variables for Python and Java
ENV LANG=C.UTF-8 \
    JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

# Copy only Python and Java binaries/libraries
COPY --from=java-stage /opt/java/ /opt/java/
COPY --from=python-stage /usr/local/ /usr/local/
COPY --from=python-stage /usr/lib/ /usr/lib/
COPY --from=python-stage /app /app

# Set a working directory
WORKDIR /app

# Expose the port so we can connect
EXPOSE 5055 5056

# Run the gateway
CMD sh ./start.sh
