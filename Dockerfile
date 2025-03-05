FROM alpine:latest

RUN apk add --no-cache qpdf ghostscript

CMD ["gs", "--version"]
CMD ["qpdf", "--version"]
