FROM ubuntu-upstart:12.04

RUN dpkg-divert --local --rename --add /sbin/initctl && \
	ln -s /bin/true /sbin/initctl && \
	apt-get update && \
    apt-get install -y openssh-server sudo cron && \
    sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    useradd -m -s /bin/bash travis && \
    echo 'travis:travis' | chpasswd && \
    echo 'travis ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/travis && \
    chmod 0440 /etc/sudoers.d/travis && \
	ln -sf /sbin/initctl.distrib /sbin/initctl

ADD authorized_keys /home/travis/.ssh/
RUN chmod 0644 /home/travis/.ssh/authorized_keys && \
	chown travis:travis /home/travis/.ssh/authorized_keys
