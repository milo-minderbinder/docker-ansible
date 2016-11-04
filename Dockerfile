# mminderbinder/ansible
FROM mminderbinder/baseimage
MAINTAINER Milo Minderbinder <minderbinder.enterprises@gmail.com>


RUN apt-get update && apt-get install -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && apt-get install -y ansible

RUN echo "krb5-config krb5-config/default_realm string" | debconf-set-selections
RUN apt-get install -y \
        krb5-user \
        libkrb5-dev \
        python-dev \
        python-pip
RUN pip install kerberos requests_kerberos

ENV SRV_ANSIBLE /srv/ansible

RUN mkdir -p $SRV_ANSIBLE
RUN rm /etc/krb5.conf && \
	rm -rf /etc/ansible && \
	ln -s "${SRV_ANSIBLE}/etc/krb5.conf" /etc/krb5.conf && \
	ln -s "${SRV_ANSIBLE}/etc/ansible" /etc/ansible

VOLUME ["${SRV_ANSIBLE}"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
CMD ["/sbin/my_init"]
