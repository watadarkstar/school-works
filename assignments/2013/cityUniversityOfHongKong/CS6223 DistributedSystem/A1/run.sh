#!/bin/bash

set CLASSPATH="~/rmi"
javac SampleServer.java

#javac SampleServerImpl.java
javac Server1.java
javac Server2.java

#rmic SampleServerImpl
rmic Server1
rmic Server2

#javac SampleClient.java
javac Dispatcher.java
rmiregistry
