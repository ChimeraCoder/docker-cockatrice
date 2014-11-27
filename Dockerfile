FROM debian:wheezy
MAINTAINER Aditya Mukerjee <dev@chimeracoder.net>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update --fix-missing
RUN apt-get install -y bash 
RUN apt-get install -y wget
RUN apt-get install -y -o Acquire::ForceIPv4=true procps
RUN echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf && /sbin/sysctl -p
#RUN echo "deb http://http.debian.net/debian jessie main" >> /etc/apt/sources.list
#RUN apt-get install -t jessie -y libc6 libprotobuf-dev libqt4-network libqtmultimediakit1 libstdc++6
#RUN apt-get install -t jessie -y git libqt4-svg 
#RUN apt-get install -t jessie -y -o Acquire::ForceIPv4=true libgcrypt-dev cmake binutils cdecl g++
RUN apt-get install -y -o Acquire::ForceIPv4=true qt-sdk build-essential qt4-dev-tools qtmobility-dev libprotobuf-dev protobuf-compiler libqtmultimediakit1 cmake git 

#RUN wget http://packages.bodhilinux.com/bodhi/pool/main/c/cockatrice/cockatrice_20140625-1_amd64.deb
#RUN gdebi -o APT::Install-Recommends=0 -o APT::Install-Suggests=0 cockatrice_20140625-1_amd64.deb
#RUN dpkg --install --ignore-depends=libprotobuf8 cockatrice_20140625-1_amd64.deb

RUN git clone https://github.com/Cockatrice/Cockatrice.git 
WORKDIR Cockatrice
RUN	cmake . #-DCMAKE_CXX_COMPILER=/usr/bin/c++
RUN	make
RUN	make install

RUN useradd planeswalker
RUN yes "asdf" | passwd planeswalker  # Set password to "asfd" for ssh login
USER planeswalker

# X11Forwarding is enabled by default
RUN apt-get install -y -o Acquire::ForceIPv4=true openssh-server
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN /etc/init.d/ssh restart




CMD /usr/local/bin/cockatrice
