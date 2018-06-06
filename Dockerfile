FROM debian:stretch
# Based on https://forum.xda-developers.com/chef-central/android/how-to-build-lineageos-14-1-t3551484
#      and https://forum.xda-developers.com/chef-central/android/guide-android-rom-development-t2814763

# Set user/group inside container
ARG user=builder
ARG group=builder
ARG home=/home/${user}
ARG uid=1000
ARG gid=1000
ARG DEBIAN_FRONTEND=noninteractive

# Install packages
COPY sources.list /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev adb fastboot openjdk-8-jdk python ccache repo procps mc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /sshpass /core

# Create group and user
RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} --home ${home} -m -s /bin/bash ${user}

# Build environment variables
ENV gitemail=a.b@example.org
ENV gituser="Andrei Darashenka"
ENV USE_CCACHE ${USE_CCACHE:-1}
ENV CCACHE_COMPRESS ${CCACHE_COMPRESS:-1}
ENV CCACHE_DIR ${home}/ccache
ENV MAKEFLAGS ${MAKEFLAGS:--j1}

USER ${user}
WORKDIR ${home}
# Final
COPY entrypoint.sh ${home}/entrypoint.sh
#RUN chown ${user}:${group} ${home}/entrypoint.sh && \
#    chmod 755 ${home}/entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
