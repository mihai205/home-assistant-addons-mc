ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG PAPERMC_VERSION="1.21.5"
ARG PAPERMC_BUILD="26"
ARG JAVA_VERSION="zulu21-jre-headless"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set non-interactive mode to avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# Update package list and install necessary utilities
RUN apt-get update && apt-get install -y \
    gnupg \
    wget \
    software-properties-common \
    ca-certificates \
    apt-utils \
    yq \
    unzip \
    && rm -rf /var/lib/apt/lists/*


# Add the repository or perform other setup steps (for example, adding a PPA)
# Example: Adding Azul Zulu repository for OpenJDK
RUN curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list
# RUN echo "deb https://repos.azul.com/zulu/openjdk21/deb stable main" | tee /etc/apt/sources.list.d/zulu.list

# Update package list again after adding the new repository
RUN apt-get update

# Install OpenJDK 21 (headless)
RUN apt-get install -y $JAVA_VERSION

# Verify the installation
RUN java -version

# Copy root filesystem
COPY rootfs /

# Copy defualt Configs
RUN mkdir /default_config
COPY default_config/* /default_config/

# Corrects permissions for s6 v3
RUN if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi && \
    if [ -d /etc/services.d/ha-spawn-point-legendary ]; then chmod -R 755 /etc/services.d/ha-spawn-point-legendary; fi

# Get needed binaries
RUN mkdir -p minecraft/plugins
# PaperMC
RUN curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o /minecraft/papermc.jar "https://api.papermc.io/v2/projects/paper/versions/$PAPERMC_VERSION/builds/$PAPERMC_BUILD/downloads/paper-$PAPERMC_VERSION-$PAPERMC_BUILD.jar"
# Floodgate
RUN curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o /minecraft/plugins/Floodgate-Spigot.jar "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot"
# Geyser
RUN curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o /minecraft/plugins/Geyser-Spigot.jar "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"

############
# 5 Labels #
############

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="aph-le (https://github.com/aph-le)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="aph-le (https://github.com/aph-le)" \
    org.opencontainers.image.licenses="Apache" \
    org.opencontainers.image.url="https://github.com/aph-le" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}