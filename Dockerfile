FROM debian:bookworm-20250407 AS build

# Update ind install necessary tools 
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update &&\
    apt install -yqq curl build-essential git mc pigz vim wget

# Download, make and install amnesia tools
WORKDIR /tmp
RUN git clone https://github.com/amnezia-vpn/amneziawg-tools.git
WORKDIR /tmp/amneziawg-tools/src
RUN make -j $(nproc) && make install

# Download and install go
WORKDIR /tmp
RUN wget -O - "https://go.dev/dl/go1.24.4.linux-amd64.tar.gz" | tar -xvI pigz
RUN git clone https://github.com/amnezia-vpn/amneziawg-go
WORKDIR /tmp/amneziawg-go
RUN PATH=$PATH:/tmp/go/bin make -j $(nproc) install

FROM debian:bookworm-20250407

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update &&\
    apt install -yqq curl conntrack dnsutils lsof net-tools iftop iproute2 \
    iptables iputils-ping mc mtr-tiny openssh-server procps qrencode \
	screen telnet tshark wget

# Edit SSH config
RUN grep -q '^PermitRootLogin' /etc/ssh/sshd_config \
    && sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Create SSH priv sep dir
RUN mkdir /run/sshd && chmod 755 /run/sshd

# Add dev SSH key
COPY dev.pub /tmp/dev.pub
ARG AKF=/root/.ssh/authorized_keys
RUN mkdir -p "$(dirname "$AKF")" &&\
    chmod 700 "$(dirname "$AKF")" &&\
    cat /tmp/dev.pub > $AKF &&\
    rm /tmp/dev.pub &&\
    chmod 644 "$AKF"

# Root password
RUN echo 'root:123' | chpasswd

# mc
COPY mc.ini /root/.config/mc/ini
RUN chmod 700 /root/.config/mc

# AWG
COPY --from=build /usr/bin/awg /usr/bin/
COPY --from=build /usr/bin/awg-quick /usr/bin/
COPY --from=build /usr/bin/amneziawg-go /usr/bin/

# Entry point
COPY ep.sh /
COPY gen_key.sh /
COPY awg0.conf /
ENTRYPOINT ["/ep.sh"]
