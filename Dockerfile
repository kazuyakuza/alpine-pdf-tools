ARG NODE_VERSION=latest
ARG QPDF_VERSION=latest
ARG GHOSTSCRIPT_VERSION=latest

# Builder stage for qpdf
FROM alpine:latest AS builder

ARG QPDF_VERSION=latest

RUN apk add --no-cache \
    build-base \
    cmake \
    gcc \
    g++ \
    make \
    openssl-dev \
    zlib-dev \
    jpeg-dev \
    libjpeg-turbo-dev

WORKDIR /tmp/qpdf

RUN if [ "$QPDF_VERSION" = "latest" ]; then \
      QPDF_VERSION=$(wget -qO- https://api.github.com/repos/qpdf/qpdf/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//'); \
    fi && \
    wget https://github.com/qpdf/qpdf/releases/download/v${QPDF_VERSION}/qpdf-${QPDF_VERSION}.tar.gz && \
    tar -xf qpdf-${QPDF_VERSION}.tar.gz && \
    cd qpdf-${QPDF_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Debug && \
    make -j$(nproc) && \
    make install

# Helper stage to determine Node.js image
FROM alpine:latest AS helper
ARG NODE_VERSION=latest
RUN if [ "$NODE_VERSION" = "latest" ]; then \
      echo "NODE_IMAGE=node:alpine" > /tmp/node_image.env; \
    else \
      echo "NODE_IMAGE=node:${NODE_VERSION}-alpine" > /tmp/node_image.env; \
    fi

# Node.js base image
FROM --platform=linux/amd64 $(cat /tmp/node_image.env | cut -d '=' -f 2) as node-base

# Final stage
FROM alpine:latest

ARG GHOSTSCRIPT_VERSION=latest

COPY --from=builder /usr/local/bin/qpdf /usr/local/bin/qpdf
COPY --from=builder /usr/local/lib/libqpdf* /usr/local/lib/
COPY --from=node-base /usr/local/bin/node /usr/local/bin/
COPY --from=node-base /usr/local/lib/node_modules /usr/local/lib/node_modules


# Install Ghostscript
RUN if [ "$GHOSTSCRIPT_VERSION" = "latest" ]; then \
      apk add --no-cache ghostscript; \
    else \
      apk add --no-cache ghostscript=${GHOSTSCRIPT_VERSION}; \
    fi

CMD ["sh", "-c", "(echo \"----node-version\" && node --version && echo \"----qpdf-version\" && qpdf --version && echo \"----ghostscript-version\" && gs --version)"]
