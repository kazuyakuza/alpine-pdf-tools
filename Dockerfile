ARG QPDF_VERSION
ARG GHOSTSCRIPT_VERSION
ARG NODE_VERSION

FROM alpine:latest

RUN apk add --no-cache \
    qpdf${QPDF_VERSION:+=$QPDF_VERSION} \
    ghostscript${GHOSTSCRIPT_VERSION:+=$GHOSTSCRIPT_VERSION} \
    nodejs${NODE_VERSION:+=$NODE_VERSION}

CMD ["sh", "-c", "node --version && qpdf --version && gs --version"]
