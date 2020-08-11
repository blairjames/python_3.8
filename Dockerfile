FROM alpine:latest
RUN apk update && apk upgrade
RUN apk add --no-cache \
    make git gdbm gdbm-dev util-linux libffi libffi-dbg libffi-dev ncurses5-widec-libs xz xz-libs xz-dev libbz2 ncurses5-libs tk tk-dev tcl tcl-dev gcc libc-dev \
    llvm readline-dev sqlite sqlite-dev sqlite-libs zlib-dev libuuid openssl-dev libc-utils 
RUN wget "https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tar.xz"
RUN \
    tar -Jxvf ./Python* && \
    rm -rf ./Python*.tar.xz && \
    mv ./Python* ./python && \
    chmod 755 -R /python
RUN cd /python && ./configure
RUN cd /python && make -j 8
RUN cd /python && make -j 8 install
ENTRYPOINT ["python3.8"]

# FROM scratch
# COPY --from=0 /usr/share/nmap/nmap /usr/bin/nmap
# COPY --from=0 /etc/hosts /etc/hosts
# COPY --from=0 /etc/passwd /etc/passwd
# COPY --from=0 /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
# COPY --from=0 /usr/local/share/nmap/ /usr/local/share/nmap/
# COPY --from=0 /usr/share/nmap /usr/share/nmap 
# COPY --from=0 /usr/lib/ /usr/lib/
# COPY --from=0 /lib/ /lib/
# ENTRYPOINT ["/usr/bin/nmap"]
