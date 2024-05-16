# Используем базовый образ Ubuntu 22.04
FROM ubuntu:22.04

# Устанавливаем переменную окружения для директорий установки
ENV SOFT=/soft
ENV PATH=$SOFT/samtools-br230515/bin:$SOFT/bcftools-br230515/bin:$SOFT/vcftools-br230515/bin:$PATH
ENV SAMTOOLS=$SOFT/samtools-br230515/bin/samtools
ENV BCFTOOLS=$SOFT/bcftools-br230515/bin/bcftools
ENV VCFTOOLS=$SOFT/vcftools-br230515/bin/vcftools

# Устанавливаем зависимости через apt
RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Создаем директорию для установки программ
RUN mkdir -p $SOFT

# Установка libdeflate
# Версия: v1.10 (10 мая 2023)
RUN cd /tmp && \
    wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.10.tar.gz && \
    tar -xzf v1.10.tar.gz && \
    cd libdeflate-1.10 && \
    make -j$(nproc) && \
    make install PREFIX=$SOFT/libdeflate-br230510 && \
    rm -rf /tmp/libdeflate-1.10 v1.10.tar.gz

# Установка htslib
# Версия: 1.17 (15 мая 2023)
RUN cd /tmp && \
    wget https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2 && \
    tar -xjf htslib-1.17.tar.bz2 && \
    cd htslib-1.17 && \
    ./configure --prefix=$SOFT/htslib-br230515 --enable-libcurl --enable-plugins && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/htslib-1.17 htslib-1.17.tar.bz2

# Установка samtools
# Версия: 1.17 (15 мая 2023)
RUN cd /tmp && \
    wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjf samtools-1.17.tar.bz2 && \
    cd samtools-1.17 && \
    ./configure --prefix=$SOFT/samtools-br230515 && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/samtools-1.17 samtools-1.17.tar.bz2

# Установка bcftools
# Версия: 1.17 (15 мая 2023)
RUN cd /tmp && \
    wget https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2 && \
    tar -xjf bcftools-1.17.tar.bz2 && \
    cd bcftools-1.17 && \
    ./configure --prefix=$SOFT/bcftools-br230515 && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/bcftools-1.17 bcftools-1.17.tar.bz2

# Установка vcftools
# Версия: 0.1.16 (15 мая 2023)
RUN cd /tmp && \
    wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz && \
    tar -xzf vcftools-0.1.16.tar.gz && \
    cd vcftools-0.1.16 && \
    ./autogen.sh && \
    ./configure --prefix=$SOFT/vcftools-br230515 && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/vcftools-0.1.16 vcftools-0.1.16.tar.gz

# Очистка кэша apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
