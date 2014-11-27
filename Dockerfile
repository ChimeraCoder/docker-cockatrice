FROM debian:wheezy
MAINTAINER Aditya Mukerjee <dev@chimeracoder.net>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update --fix-missing
RUN apt-get install -y bash 
RUN apt-get install -y wget
RUN apt-get install -y -o Acquire::ForceIPv4=true procps
RUN echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf && /sbin/sysctl -p
RUN apt-get install -y -o Acquire::ForceIPv4=true qt-sdk build-essential qt4-dev-tools qtmobility-dev libprotobuf-dev protobuf-compiler libqtmultimediakit1 cmake git 

#RUN wget http://packages.bodhilinux.com/bodhi/pool/main/c/cockatrice/cockatrice_20140625-1_amd64.deb
#RUN gdebi -o APT::Install-Recommends=0 -o APT::Install-Suggests=0 cockatrice_20140625-1_amd64.deb
#RUN dpkg --install --ignore-depends=libprotobuf8 cockatrice_20140625-1_amd64.deb

RUN git clone https://github.com/Cockatrice/Cockatrice.git 
WORKDIR Cockatrice
RUN	cmake . #-DCMAKE_CXX_COMPILER=/usr/bin/c++
RUN	make
RUN	make install


# X11Forwarding is enabled by default
RUN apt-get install -y -o Acquire::ForceIPv4=true openssh-server
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd

RUN useradd -m planeswalker
RUN yes "asdf" | passwd planeswalker  # Set password to "asfd" for ssh login

CMD /usr/sbin/sshd -D
