# DOCKER-VERSION 1.0.0
# 
# Ceph OSD
#
#  USAGE NOTES:
#    * OSD_ID (numeric identifier for this OSD; obtain from `ceph osd create`)
#
# VERSION 0.0.2

FROM ceph/base
MAINTAINER Seán C McCord "ulexus@gmail.com"

# Expose the ceph OSD port (6800+, by default)
EXPOSE 6800

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update && apt-get -y install runit && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/container_environment

RUN mkdir /etc/service/bootstrap
ADD entrypoint.sh /etc/service/bootstrap/run
RUN chmod +x /etc/service/bootstrap/run

ENTRYPOINT ["/etc/service/bootstrap/run"]
