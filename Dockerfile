FROM alpine:latest
RUN apk update && apk upgrade
RUN apk add py3-pip py3-beautifulsoup4
ENTRYPOINT ["python3.8"]

# Packages to install when compiling from source: 
#    make git gdbm gdbm-dev util-linux libffi libffi-dbg \
#    libffi-dev ncurses5-widec-libs xz xz-libs xz-dev libbz2 \
#    ncurses5-libs tk tk-dev tcl tcl-dev gcc libc-dev llvm \
#    readline-dev sqlite sqlite-dev sqlite-libs zlib-dev \
#    libuuid openssl-dev libc-utils 

# Compile Python from Source.
# RUN wget "https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tar.xz"
# RUN \
#    tar -Jxvf ./Python* && \
#    rm -rf ./Python*.tar.xz && \
#    mv ./Python* ./python && \
#    chmod 755 -R /python
# RUN cd /python && ./configure
# RUN cd /python && make -j 8
# RUN cd /python && make -j 8 install
