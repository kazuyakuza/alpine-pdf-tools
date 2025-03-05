ARG NODE_VERSION=22
ARG QPDF_VERSION=11.10.1
ARG GHOSTSCRIPT_VERSION=10.04.0

FROM alpine:latest

RUN apk add --no-cache qpdf=${QPDF_VERSION} ghostscript=${GHOSTSCRIPT_VERSION} nodejs=${NODE_VERSION}

CMD ["gs", "--version"]
CMD ["qpdf", "--version"]
CMD ["node", "--version"]
