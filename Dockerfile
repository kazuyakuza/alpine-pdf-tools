FROM alpine:latest

RUN apk add --no-cache qpdf ghostscript

CMD ["ghostscript", "--version"]
CMD ["qpdf", "--version"]
