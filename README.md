# Docker Image with Bioinformatics Tools

This repository contains a Dockerfile for building a Docker image with the latest versions of `samtools`, `htslib`, `libdeflate`, `bcftools`, and `vcftools`.

## Building the Docker Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```sh
docker build -t bioinformatics-tools:latest .
