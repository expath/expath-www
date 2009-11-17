#! /bin/sh

## calabash [--add-cp=...]* [--cp=...]* [--repo=...]? [--java=...]? \
##          [--mem=...]? [--proxy=[user:password@]?host:port]?      \
##          <original Calabash options>
##
## Order of options is not significant, but the options to be
## forwarded to Calabash must be at the end.  The special option "--"
## can be used to say "no more option to be used by the script, just
## forward any remaining one".  See below for an explanation of the
## options.
##
## Depends on the following environment variables:
##
##   - CALABASH_CP
##   - EXPATH_REPO (if used)
##   - CALABASH_SCRIPT_HOME (if different from $HOME, for tilde "~"
##     substitution)
##
## The java command is taken from JAVA_HOME (or just 'java' if not
## set.)


# ==================== useful values ====================

if test -z "$JAVA_HOME"; then
    JAVA=java
else
    JAVA=${JAVA_HOME}/bin/java
fi

if test -z "$CALABASH_SCRIPT_HOME"; then
    MY_HOME=$HOME
else
    MY_HOME=$CALABASH_SCRIPT_HOME
fi
if uname | grep -i cygwin >/dev/null 2>&1; then
    CP_DELIM=";"
else
    CP_DELIM=":"
fi
MEMORY=512m
PROXY=$FG_PROXY

CP=
JAVA_OPT=
# defaults to the environment variable, but can be changed by --repo=...
REPO=$EXPATH_REPO

# ==================== utility functions ====================

resolve () {
    if echo "$1" | grep -- '^~' >/dev/null 2>&1; then
        echo "$MY_HOME"`echo $1 | sed s/^~//`;
    else
        echo "$1"
    fi
}

opt_value () {
    echo $1 | sed 's/^--[-a-z]*=//'
}

opt_resolve_value () {
    tmp=`opt_value $1`
    echo `resolve $tmp`;
}

usage () {
    echo
    echo "Usage: calabash <script options> <processor options>"
    echo
    echo "<processor options> are any option accepted by the original command-line"
    echo "Calabash frontend.  Script options are (all are optional, those marked with"
    echo "an * are repeatable):"
    echo
    echo "  --repo=...                set the EXPath Packaging repository dir"
    echo "  --proxy=[user:password@]host:port"
    echo "                            HTTP and HTTPS proxy information"
    echo "  --add-cp=classpath *      add an entry to the classpath"
    echo "  --cp=classpath *          set the classpath (override the default classpath)"
    echo "  --java=...                add an option to the Java Virtual Machine"
    echo "  --mem=...                 set the memory (shortcut for --java=-Xmx...)"
    echo
}

# ==================== the options ====================

while echo "$1" | grep -- ^-- >/dev/null 2>&1 && test "$1" != --; do
    case "$1" in
        # The EXPath Packaging repository
        --repo=*)
            REPO=`opt_resolve_value $1`;;
        # Add some path to the class path.  May be repeated.
        --add-cp=*)
            ADD_CP="${ADD_CP}${CP_DELIM}`opt_resolve_value $1`";;
        # Set the class path.  May be repeated.
        --cp=*)
            CP="${CP}${CP_DELIM}`opt_resolve_value $1`";;
        # The memory space to give to the JVM
        --mem=*)
            MEMORY=$1;;
        # Add support for --proxy=user:password@host:port
        --proxy=*)
            PROXY=`opt_value $1"`;;
        # Additional option for the JVM        
        --java=*)
            JAVA_OPT="$JAVA_OPT `opt_value $1`";;
        --help)
            usage
            exit 0;;
        # Unknown option!
        --*)
            echo "Unknown option: $1" 1>&2
            exit 1;;
    esac
    shift;
done

# ==================== EXPath repo ====================

if test -n "$REPO"; then

    # the repo itself
    JAVA_OPT="$JAVA_OPT -Dorg.expath.pkg.calabash.repo=$REPO"

    # ** Saxon extension JAR files must be added to the classpath **
    # add each line of {repo}/.expath-pkg/*/saxon/classpath.txt to the
    # classpath
    oldIFS=$IFS
    IFS=$'\n'
    for cp in `resolve "${REPO}"`/.expath-pkg/*/saxon/classpath.txt
    do
        for jar in `cat "$cp"`
        #while read jar
        do
            ADD_CP="${ADD_CP}${CP_DELIM}${jar}";
        done
    done
    IFS=$oldIFS

fi

# ==================== classpath ====================

# Original classpath + the additional classpath
CP="${CALABASH_CP}${ADD_CP}"

# ==================== proxy ====================

# TODO: Check the format of the PROXY value
if test -n "$PROXY"; then
    PROXY_HOST=`echo $PROXY | sed "s/^\(\(.*\):\(.*\)@\)\?\(.*\):\([0-9]*\)$/\4/"`
    PROXY_PORT=`echo $PROXY | sed "s/^\(\(.*\):\(.*\)@\)\?\(.*\):\([0-9]*\)$/\5/"`
    JAVA_OPT="$JAVA_OPT -Dhttp.proxyHost=$PROXY_HOST"
    JAVA_OPT="$JAVA_OPT -Dhttp.proxyPort=$PROXY_PORT"
    JAVA_OPT="$JAVA_OPT -Dhttps.proxyHost=$PROXY_HOST"
    JAVA_OPT="$JAVA_OPT -Dhttps.proxyPort=$PROXY_PORT"

    PROXY_USER=`echo $PROXY | sed "s/^\(\(.*\):\(.*\)@\)\?\(.*\):\([0-9]*\)$/\2/"`
    PROXY_PWD=`echo $PROXY | sed "s/^\(\(.*\):\(.*\)@\)\?\(.*\):\([0-9]*\)$/\3/"`
    if test -n "$PROXY_USER"; then
        # TODO: Try to solve this problem.
        echo "Impossible to use --proxy with a user for now (not supported yet)" 1>&2
        exit 1
        JAVA_OPT="$JAVA_OPT -Dfgeorges.httpProxyUser=$PROXY_USER"
        JAVA_OPT="$JAVA_OPT -Dfgeorges.httpProxyPwd=$PROXY_PWD"
        # ...
        # SAXON_OPT="$SAXON_OPT -r${OPT_DELIM}org.fgeorges.saxon.HttpProxyUriResolver"
    fi
fi

# ==================== launch Saxon ====================

# TODO: Add logging configuration facility

"$JAVA" "-Xmx$MEMORY" \
    $JAVA_OPT \
    -ea -esa \
    -cp "$CP" \
    org.expath.pkg.calabash.Main \
    "$@"

    # com.xmlcalabash.drivers.Main
