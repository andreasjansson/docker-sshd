FROM ubuntu:18.04

RUN apt-get update -q && apt-get install -qy --no-install-recommends openssh-server wget zip tar gzip bzip2 unrar p7zip
RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN wget -q --no-check-certificate -O /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz && \
        cd /tmp && \
        tar xzf docker.tgz && \
        mv docker/docker /bin/docker && \
        rm -r docker && \
        chmod +x /bin/docker

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
