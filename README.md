Introduction
------------

miyatama/peerjs is simple peerjs server and client.

Installing/Running 
----------

Clone the git repository,and run

```bash
$ git clone https://github.com/miyatama/peerjs.git
$ cd peerjs
./run.sh build full

```

configure sslkey and create container configuration directory.
```bash
$ ./run.sh configure
```

edit peerjs-frontend configureation.change 'loalhost' to docker host ip address in index.html.
```bash
$ vi ./conf/peerjsfrontend-config/html/index.html
```
running peerjs and peerjs frontend
```bash
$ ./run.sh
```

if call to console of container when
```bash
$ ./run.sh console peerjs
```

access to peerjs client
http://youipaddr:8080


