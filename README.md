# Alpine PDF Tools Docker Image

This repository contains the files to build a Docker image with Alpine Linux and the PDF tools qpdf and Ghostscript.

## Links

- **GitHub Repository:** <https://github.com/kazuyakuza/alpine-pdf-tools>
- **Docker Hub Image:** <https://hub.docker.com/r/kazuyakuza/alpine-pdf-tools>

## About

This Docker image provides a lightweight environment for working with PDF files. It includes:

- **Alpine Linux:** A minimal and secure Linux distribution. [Official Website](https://alpinelinux.org/)
- **qpdf:** A command-line tool for structural, content-preserving transformations on PDF files. [Official Website](https://qpdf.sourceforge.io/)
- **Ghostscript:** An interpreter for the PostScript language and for PDF. [Official Website](https://ghostscript.com/)

## Building the Image Manually

You can build the Docker image manually using the following command:

```bash
docker build -t alpine-pdf-tools .
```

## Running the Container

After building the image, you can run a container using:

```bash
docker run -it alpine-pdf-tools
```

This will start a container and drop you into a shell where you can use `qpdf` and `ghostscript`.

## Tags

pdf, alpine, qpdf, ghostscript, docker, docker image
