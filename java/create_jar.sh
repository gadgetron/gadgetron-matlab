#!/bin/bash

# Compile the socket wrapper. 
javac ./gadgetron/external/SocketWrapper.java

# Build a simple jar file containing the wrapper.
jar -cf ../gadgetron.external.SocketWrapper.jar ./gadgetron/external/SocketWrapper.class

