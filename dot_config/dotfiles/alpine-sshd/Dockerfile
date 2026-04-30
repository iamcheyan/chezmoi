FROM alpine:3.21

RUN sed -i 's/https:/http:/g' /etc/apk/repositories \
 && apk update

RUN apk add --no-cache \
    bash \
    openssh \
    shadow \
    sudo \
 && ssh-keygen -A

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
