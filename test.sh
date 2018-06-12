#!/bin/bash

CLASSPATH=.:amqp-client-4.0.2.jar:slf4j-api-1.7.21.jar:slf4j-simple-1.7.22.jar

# Start receiver
kawa recv.scm & PID=$!

# Compile java program
javac Send.java

# Send message
java Send

kill $PID
