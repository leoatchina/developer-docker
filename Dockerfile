FROM ubuntu:18.04
MAINTAINER leoatchina,leoatchina@gmail.com
ADD sources.list /etc/apt/sources.list
RUN apt update -y && apt upgrade -y &&  \
    apt install -y wget curl net-tools iputils-ping apt-transport-https openssh-server \
    unzip bzip2 apt-utils gdebi-core tmux \
    git htop supervisor xclip cmake sudo \
    libapparmor1 libcurl4-openssl-dev libxml2 libxml2-dev libssl-dev libncurses5-dev libncursesw5-dev libjansson-dev \
    build-essential gfortran libcairo2-dev libxt-dev automake bash-completion \
    libapparmor1 libedit2 libc6 psmisc rrdtool libzmq3-dev libtool software-properties-common locales \
    python3-dev python3-pip -y && \
    locale-gen en_US.UTF-8 && \
    mkdir -p /var/run/sshd && \
    apt autoremove && apt clean && apt purge && rm -rf /tmp/* /var/tmp/*
RUN add-apt-repository ppa:jonathonf/vim -y && \
    apt update -y &&  \
    apt install -y vim && \
    apt autoremove && apt clean && apt purge && rm -rf /tmp/* /var/tmp/*
# ctags
RUN cd /tmp && \
    git clone --depth 1 https://github.com/universal-ctags/ctags.git && cd ctags && \
    ./autogen.sh && ./configure && make && make install && \
    cd /tmp && \
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb && \
    dpkg -i ripgrep_11.0.1_amd64.deb && \
    cd /tmp && \
    curl http://ftp.vim.org/ftp/gnu/global/global-6.6.3.tar.gz -o global.tar.gz && \
    tar xvzf global.tar.gz && cd global-6.6.3 && \
    ./configure --with-sqlite3 && make && make install && \
    apt autoremove && apt clean && apt purge && rm -rf /tmp/* /var/tmp/*
# node and yarn 
RUN apt update -y && \
    apt install -y nodejs nodejs-dev node-gyp libssl1.0-dev && \
    apt install -y npm && \
    npm config set registry https://registry.npm.taobao.org && \
    npm install -g n && n stable && \
    npm install -g yarn && \
    apt autoremove && apt clean && apt purge && rm -rf /tmp/* /var/tmp/*
# pip install something
ADD pip.conf /root/.pip/
RUN pip3 install --upgrade pip  && \
    rm -rf /root/.cache/pip/* /tmp/*
RUN pip3 install neovim mysql-connector-python python-language-server mock requests pygments flake8 && \
    rm -rf /root/.cache/pip/* /tmp/* && \
    apt autoremove && apt clean && apt purge && rm -rf /tmp/* /var/tmp/*
RUN pip3 install Flask  && \
    npm install -g vue-cli && \
    rm -rf /root/.cache/pip/* /tmp/* && \
    apt autoremove && apt clean && apt purge && rm -rf /tmp/* /var/tmp/*
ENV PASSWD=flaskvue
ADD supervisord.conf /etc/
ADD entrypoint.sh /etc/
ADD .bashrc /root/
ADD .inputrc /root/
RUN chmod 711 /var/run/sshd
ENTRYPOINT ["bash", "/etc/entrypoint.sh"]

