ARG NODE_VERSION=latest
ARG QPDF_VERSION=latest
ARG GHOSTSCRIPT_VERSION=latest

# ----
# qpdf-builder stage for qpdf
# ----
FROM alpine:latest AS qpdf-builder
ARG QPDF_VERSION=latest
ENV QPDF_VERSION=$QPDF_VERSION
RUN echo "QPDF_VERSION=$QPDF_VERSION" >> /etc/environment;

RUN apk add --no-cache \
    build-base \
    cmake \
    gcc \
    g++ \
    make \
    openssl-dev \
    zlib-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    jq

WORKDIR /tmp/qpdf
RUN if [ "${QPDF_VERSION}" = "latest" ]; then \
      export QPDF_VERSION=$(wget -qO- https://api.github.com/repos/qpdf/qpdf/releases/latest | jq -r '.tag_name'); \
      export QPDF_VERSION=${QPDF_VERSION#v}; \
      echo "QPDF_VERSION=$QPDF_VERSION" >> /etc/environment; \
    fi
RUN source /etc/environment && wget https://github.com/qpdf/qpdf/releases/download/v${QPDF_VERSION}/qpdf-${QPDF_VERSION}.tar.gz
RUN source /etc/environment && tar -xf qpdf-${QPDF_VERSION}.tar.gz
RUN source /etc/environment && \
    cd qpdf-${QPDF_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug && \
    make -j$(nproc) && \
    make install

# Copy the necessary qpdf libraries
RUN mkdir /tmp/libs && \
    ldd $(which qpdf) | awk '{print $3}' | xargs -I '{}' cp -v '{}' /tmp/libs/

# ----
# ghostscript-builder stage for Ghostscript
# ----
FROM alpine:latest AS ghostscript-builder
ARG GHOSTSCRIPT_VERSION=latest
ENV GHOSTSCRIPT_VERSION=$GHOSTSCRIPT_VERSION

RUN if [ "$GHOSTSCRIPT_VERSION" = "latest" ]; then \
      apk add --no-cache ghostscript; \
    else \
      apk add --no-cache ghostscript=${GHOSTSCRIPT_VERSION}; \
    fi

# Copy the necessary qpdf libraries
RUN mkdir /tmp/libs && \
    ldd $(which gs) | awk '{print $3}' | xargs -I '{}' cp -v '{}' /tmp/libs/

# ----
# Use Node.js latest image
# ----
FROM node:alpine AS node-latest
ARG NODE_VERSION=latest
ENV NODE_VERSION=$NODE_VERSION

# Exiting when not latest version
RUN [ "$NODE_VERSION" = "latest" ] || exit 0

# Copying libs dependencies
COPY --from=qpdf-builder /usr/bin/qpdf /usr/bin/qpdf
COPY --from=qpdf-builder /tmp/libs /usr/lib/
COPY --from=ghostscript-builder /usr/bin/gs /usr/bin/gs
COPY --from=ghostscript-builder /usr/share/ghostscript /usr/share/ghostscript
COPY --from=ghostscript-builder /tmp/libs /usr/lib/

CMD ["sh", "-c", "echo \"----node-version\" && node --version && echo \"----qpdf-version\" && qpdf --version && echo \"----ghostscript-version\" && gs --version"]

# ----
# Use Node.js specific version
# ----
FROM node:${NODE_VERSION}-alpine AS node-version

# Copying libs dependencies
COPY --from=qpdf-builder /usr/bin/qpdf /usr/bin/qpdf
COPY --from=qpdf-builder /tmp/libs /usr/lib/
COPY --from=ghostscript-builder /usr/bin/gs /usr/bin/gs
COPY --from=ghostscript-builder /usr/share/ghostscript /usr/share/ghostscript
COPY --from=ghostscript-builder /tmp/libs /usr/lib/

CMD ["sh", "-c", "(echo \"----node-version\" && node --version && echo \"----qpdf-version\" && qpdf --version && echo \"----ghostscript-version\" && gs --version)"]
