#ifndef CONNECT_H
#define CONNECT_H

extern VALUE c_connect;
void init_connect();

virConnectPtr conn(VALUE s);
VALUE connect_new(virConnectPtr p);
virConnectPtr connect_get(VALUE s);
VALUE conn_attr(VALUE s);

#endif
