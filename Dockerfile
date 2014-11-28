FROM debian:wheezy
MAINTAINER Aditya Mukerjee <dev@chimeracoder.net>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -o Acquire::ForceIPv4=true -qq update --fix-missing
RUN apt-get install -y -o Acquire::ForceIPv4=true bash wget openssh-server qt-sdk build-essential qt4-dev-tools qtmobility-dev libprotobuf-dev protobuf-compiler libqtmultimediakit1 cmake git && \
        apt-get -y -o Acquire::ForceIPv4=true upgrade && \
        apt-get -y -o Acquire::ForceIPv4=true remove && \
        apt-get -y -o Acquire::ForceIPv4=true autoremove

RUN git clone https://github.com/Cockatrice/Cockatrice.git 
WORKDIR Cockatrice
RUN git checkout 9e1f8a0892d1ae1ff207c80008b4d3dece72c2a7
RUN	cmake . 
RUN	make
RUN	make install


# X11Forwarding is enabled by default
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd

RUN useradd -m planeswalker
RUN yes "asdf" | passwd planeswalker  # Set password to "asfd" for ssh login

ADD run.sh /home/planeswalker/run.sh
RUN chmod 755 /home/planeswalker/run.sh
RUN mkdir -p /home/planeswalker/.local/share/data/Cockatrice
RUN chown -R planeswalker:planeswalker /home/planeswalker/


CMD /home/planeswalker/run.sh
