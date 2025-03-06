# Alpine PDF Tools Docker Image

This repository contains the files to build a Docker image with Alpine Linux, the PDF tools qpdf and Ghostscript, and Node.js. The image can be built with different versions of Node.js and specific versions of qpdf and Ghostscript using build arguments.

## Links

- **GitHub Repository:** <https://github.com/kazuyakuza/alpine-pdf-tools>
- **Docker Hub Image:** <https://hub.docker.com/r/kazuyakuza/alpine-pdf-tools>

## About

This Docker image provides a lightweight environment for working with PDF files. It includes:

- **Alpine Linux:** A minimal and secure Linux distribution. [Official Website](https://alpinelinux.org/)
- **qpdf:** A command-line tool for structural, content-preserving transformations on PDF files. [Official Website](https://qpdf.sourceforge.io/)
- **Ghostscript:** An interpreter for the PostScript language and for PDF. [Official Website](https://ghostscript.com/)
- **Node.js:** A JavaScript runtime environment. [Official Website](https://nodejs.org/)

## Building the Image Manually

You can build the Docker image manually using the following command:

```bash
docker build --target node-latest -t alpine-pdf-tools .
```

To specify the Node.js, qpdf, and Ghostscript versions, use build arguments:

```bash
docker build \
  --build-arg NODE_VERSION=18 \
  --build-arg QPDF_VERSION=11.6.2 \
  --build-arg GHOSTSCRIPT_VERSION=10.02.1 \
  -t alpine-pdf-tools .
```

To use the latest versions, 'latest' to the arguments.

```bash
docker build \
  --build-arg NODE_VERSION=18 \
  --build-arg QPDF_VERSION=latest \
  --build-arg GHOSTSCRIPT_VERSION=10.02.1 \
  -t alpine-pdf-tools .
```

When use `NODE_VERSION=latest` or not set the argument, add the `--target node-latest` argument.

```bash
docker build \
  --target node-latest \
  --build-arg NODE_VERSION=latest \
  --build-arg QPDF_VERSION=11.6.2 \
  --build-arg GHOSTSCRIPT_VERSION=10.02.1 \
  -t alpine-pdf-tools .
```

## Running the Container

After building the image, you can run a container using:

```bash
docker run -it alpine-pdf-tools
```

This will start a container, run the CMD, and show the versions of the installed tools.

To run & login to the container, while sharing a previously crated docker volume, use:

```base
docker run --rm -it -v alpine-pdf-tools-volume:/data alpine-pdf-tools sh
```

## GitHub Actions

This repository includes a GitHub Actions workflow (`.github/workflows/docker-image.yml`) that automatically builds and pushes the Docker image to Docker Hub on pushes to the `main` branch.  The workflow requires the `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` secrets to be configured in the repository settings.

## PDF Tools Example CMDs

### QPDF

```bash
qpdf --linearize --remove-info --remove-metadata --flatten-annotations=all --optimize-images --empty --pages input.pdf -- output-qpdf.pdf
```

### Ghostscript

```bash
gs -q -dNOPAUSE -dBATCH -dSAFER \
       -sDEVICE=pdfwrite \
       -dCompatibilityLevel=1.7 \
       -dColorImageDownsampleType=/Bicubic \
       -dColorImageResolution=72 \
       -dColorImageDownsampleThreshold=1.5 \
       -dGrayImageDownsampleType=/Bicubic \
       -dGrayImageResolution=72 \
       -dGrayImageDownsampleThreshold=1.5 \
       -dMonoImageDownsampleType=/Subsample \
       -sOutputFile="output-gs.pdf" \
       "input.pdf"
```

Note: read libs' official documentation for more info.

## Tags

pdf, alpine, qpdf, ghostscript, docker, docker image, node, nodejs
