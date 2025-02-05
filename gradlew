#!/usr/bin/env sh

##############################################################################
# Gradle start-up script for UNIX-based systems
##############################################################################

APP_NAME="Gradle"
APP_BASE_NAME=$(basename "$0")

# Resolve the location of the script, resolving any symlinks
while [ -h "$0" ]; do
  ls=$(ls -ld "$0")
  link=$(expr "$ls" : '.*-> \(.*\)$')
  if expr "$link" : '/.*' > /dev/null; then
    0="$link"
  else
    0="$(dirname "$0")/$link"
  fi
done

# Find the Java runtime
if [ -n "$JAVA_HOME" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA=java
fi

# Run Gradle
exec "$JAVA" -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain "$@"
