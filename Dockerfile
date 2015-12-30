FROM ubuntu

MAINTAINER Byron Ruth <b@devel.io>

# Install deps to build ODBC.
RUN apt-get -y -qq update \
    && apt-get -y -qq install make gcc

# Install UnixODBC
COPY ./unixODBC-2.3.1.tar.gz /opt/
WORKDIR /opt
RUN tar xf unixODBC-2.3.1.tar.gz
WORKDIR /opt/unixODBC-2.3.1
RUN ./configure --disable-gui
RUN make
RUN make install
RUN echo '/usr/local/lib' >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
RUN ldconfig
RUN rm -rf /opt/unixODBC-2.3.1*

# Install Netezza ODBC driver
COPY ./netezza /opt/netezza/
RUN /opt/netezza/unpack -f /usr/local/nz
RUN odbcinst -i -d -f /opt/netezza/odbc.driver
RUN echo '/usr/local/nz/lib' >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
RUN echo '/usr/local/nz/lib64' >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
RUN ldconfig
RUN rm -rf /opt/netezza
RUN ln -s /usr/local/nz/bin64/nzodbcsql /usr/local/bin/nzodbcsql

WORKDIR /

# Default command will run a query to confirm the connection is working.
COPY ./test.sh /opt/test.sh
CMD ["/opt/test.sh"]
