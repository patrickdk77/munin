FROM alpine:3.12

# Install packages
RUN apk --update --no-cache add \
  coreutils dumb-init findutils logrotate \
  munin nginx perl-cgi-fast procps \
  rrdtool-cached spawn-fcgi sudo \
  ttf-opensans tzdata ssmtp mailx \
 && sed '/^[^*].*$/d; s/ munin //g' /etc/munin/munin.cron.sample | crontab -u munin -  \
 && sed -i 's#^log_file.*#log_file /dev/stdout#' /etc/munin/munin-node.conf \
 && sed -i 's|^root|#root|' /etc/ssmtp/ssmtp.conf \
 && ln -s /usr/sbin/ssmtp /usr/lib/sendmail \
# && ln -s /usr/sbin/ssmtp /usr/sbin/sendmail \
 && mkdir /run/nginx

COPY rootfs/ /

# Expose volumes
#VOLUME /etc/munin/munin-conf.d /etc/munin/plugin-conf.d /var/lib/munin /var/log/munin

# Expose nginx
EXPOSE 80

# Use dumb-init since we run a lot of processes
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Run start script or what you choose
CMD /docker-cmd.sh
