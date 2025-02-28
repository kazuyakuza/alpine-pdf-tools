FROM alpine:latest

RUN apt-get -y update
RUN apk add --no-cache qpdf ghostscript

CMD ["ghostscript", "--version"]
CMD ["qpdf", "--version"]
