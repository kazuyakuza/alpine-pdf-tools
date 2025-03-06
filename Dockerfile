ARG NODE_VERSION=latest
ARG QPDF_VERSION=latest
ARG GHOSTSCRIPT_VERSION=latest

FROM alpine:latest

RUN apk add --no-cache \
    nodejs${NODE_VERSION:+=$NODE_VERSION} \
    qpdf${QPDF_VERSION:+=$QPDF_VERSION} \
    ghostscript${GHOSTSCRIPT_VERSION:+=$GHOSTSCRIPT_VERSION}

CMD ["sh", "-c", "(echo \"----node-version\" && node --version && echo \"----qpdf-version\" && qpdf --version && echo \"----ghostscript-version\" && gs --version)"]
