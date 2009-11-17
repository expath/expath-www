#! /bin/sh

## saxon [--b|--sa]? [--add-cp=...]* [--cp=...]*  \
##       [--repo=...]? [--java=...]? [--mem=...]? \
##       [--proxy=[user:password@]?host:port]?    \
##       <original Saxon options>
##
## Order of options is not significant, but the options to be
## forwarded to Saxon must be at the end.  The special option "--" can
## be used to say "no more option to be used by the script, just
## forward any remaining one".  See below for an explanation of the
## options.
##
## Depends on the following environment variables:
##
##   - SAXON_CP
##   - EXPATH_REPO (if used)
##   - SAXON_SCRIPT_HOME (if different from $HOME, for tilde "~"
##     substitution)
##
##   - APACHE_XML_RESOLVER_JAR
##   - SAXON_HOME
##   - EXPATH_REPO_JAR (if used)
##   - EXPATH_PKG_SAXON_JAR (if used)
##
## The java command is taken from JAVA_HOME (or just 'java' if not
## set.)


# ==================== useful values ====================

if test -z "$JAVA_HOME"; then
    JAVA=java
else
    JAVA=${JAVA_HOME}/bin/java
fi

# by default, XSLT, can also be 'xquery'
SAXON_KIND=xslt
# is it Saxon 9.2?
SAXON_92=false;
# is it Saxon 8?
SAXON_8=false;
# # set the default level (SA if detected, B else)
# if test -f "${SAXON_HOME}/saxon9ee.jar"; then
#     SAXON_LEVEL=sa;
# elif test -f "${SAXON_HOME}/saxon9pe.jar"; then
#     SAXON_LEVEL=sa;
# elif test -f "${SAXON_HOME}/saxon9he.jar"; then
#     SAXON_92=true;
#     SAXON_LEVEL=b;
# elif test -f "${SAXON_HOME}/saxon9sa.jar"; then
#     SAXON_LEVEL=sa;
# elif test -f "${SAXON_HOME}/saxon8sa.jar"; then
#     SAXON_8=true;
#     SAXON_LEVEL=sa;
# elif test -f "${SAXON_HOME}/saxon8.jar"; then
#     SAXON_8=true;
#     SAXON_LEVEL=b;
# else
#     SAXON_LEVEL=b;
# fi

if test "$SAXON_8" = true; then
    OPT_DELIM=" "
else
    OPT_DELIM=":"
fi

if test -z "$SAXON_SCRIPT_HOME"; then
    MY_HOME=$HOME
else
    MY_HOME=$SAXON_SCRIPT_HOME
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
SAXON_OPT=
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
    echo "Usage: saxon <script options> <processor options>"
    echo
    echo "<processor options> are any option accepted by the original command-line"
    echo "Saxon frontend.  Script options are (all are optional, those marked with"
    echo "an * are repeatable):"
    echo
    echo "  --b|--sa                  basic or schema aware version?"
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
        # # Basic version.
        # --b)
        #     SAXON_LEVEL=b;;
        # # Schema-Aware version.
        # --sa)
        #     SAXON_LEVEL=sa;;
        # XSLT engine.
        --xslt)
            SAXON_KIND=xslt;;
        # XQuery engine.
        --xq)
            SAXON_KIND=xquery;;
        --xquery)
            SAXON_KIND=xquery;;
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
    JAVA_OPT="$JAVA_OPT -Dorg.expath.pkg.saxon.repo=$REPO"

    # TODO: New version!
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

    # # FIXME: OLD VERSION (KEPT FOR NOW, BUT TO REMOVE!!!)
    # # add {repo}/saxon-lib/*.jar, {repo}/*/saxon/jar/*.jar and
    # # {repo}/*/saxon/lib/*.jar to the classpath
    # for mod in `resolve "${REPO}"`/*; do
    #     # repo-wide libraries...
    #     if test `basename "$mod"` = saxon-lib; then
    #         # the jars
    #         for jar in ${mod}/*.jar; do
    #             if test -f "$jar"; then
    #                 ADD_CP="${ADD_CP}${CP_DELIM}${jar}";
    #             fi
    #         done
    #     # one module in the repo
    #     elif test -d "${mod}"; then
    #         # the specific jar (if a Java extension)
    #         for jar in ${mod}/saxon/jar/*.jar; do
    #             if test -f "$jar"; then
    #                 ADD_CP="${ADD_CP}${CP_DELIM}${jar}";
    #             fi
    #         done
    #         # the jar dependencies
    #         for jar in ${mod}/saxon/lib/*.jar; do
    #             if test -f "$jar"; then
    #                 ADD_CP="${ADD_CP}${CP_DELIM}${jar}";
    #             fi
    #         done
    #     fi
    # done

fi

# ==================== classpath ====================

# add the Saxon JARs to the classpath
# if test -z "$CP"; then
#     if test -f "${SAXON_HOME}/saxon9ee.jar"; then
#         for jar in ${SAXON_HOME}/saxon9*.jar; do
#             CP="${CP}${CP_DELIM}${jar}";
#         done
#     elif test -f "${SAXON_HOME}/saxon9pe.jar"; then
#         CP="${SAXON_HOME}/saxon9pe.jar";
#     elif test -f "${SAXON_HOME}/saxon9he.jar"; then
#         CP="${SAXON_HOME}/saxon9he.jar";
#     elif test "$SAXON_LEVEL" = sa; then
#         if test -f "${SAXON_HOME}/saxon9sa.jar"; then
#             CP="${SAXON_HOME}/saxon9sa.jar";
#         else
#             CP="${SAXON_HOME}/saxon8sa.jar";
#         fi
#         for jar in ${SAXON_HOME}/saxon[89]*-*.jar; do
#             CP="${CP}${CP_DELIM}${jar}";
#         done
#     else
#         if test -f "${SAXON_HOME}/saxon9.jar"; then
#             CP="${SAXON_HOME}/saxon9.jar";
#         else
#             CP="${SAXON_HOME}/saxon8.jar";
#         fi
#         for jar in ${SAXON_HOME}/saxon[89]*-*.jar; do
#             CP="${CP}${CP_DELIM}${jar}";
#         done
#     fi;
# fi

# add SAXON_HOME if SA, for the licence (it must rely there)
# (TODO: I think that changed for EE & PE, it does not have to be in
# the classpath anymore...)
# if test "$SAXON_LEVEL" = sa; then
#     CP="${CP}${CP_DELIM}${SAXON_HOME}"
# fi

# # the Apache XML resolver
# CP="${CP}${CP_DELIM}${APACHE_XML_RESOLVER_JAR}"
# # the additional classpath
# CP="${CP}${ADD_CP}"

# Original classpath + the additional classpath
CP="${SAXON_CP}${ADD_CP}"

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
        echo "Impossible to use --proxy with a user for now (EXPath Pkg uses -r yet)" 1>&2
        exit 1
        JAVA_OPT="$JAVA_OPT -Dfgeorges.httpProxyUser=$PROXY_USER"
        JAVA_OPT="$JAVA_OPT -Dfgeorges.httpProxyPwd=$PROXY_PWD"
        SAXON_OPT="$SAXON_OPT -r${OPT_DELIM}org.fgeorges.saxon.HttpProxyUriResolver"
    fi
fi

# ==================== launch Saxon ====================

# CP="${CP}${CP_DELIM}${EXPATH_REPO_JAR}${CP_DELIM}${EXPATH_PKG_JAR}";

# TODO: Add logging configuration facility

if test "$SAXON_KIND" = xslt; then
    SAXON_CLASS=org.expath.pkg.saxon.java.EXPathTransform;
else
    SAXON_CLASS=org.expath.pkg.saxon.java.EXPathQuery;
fi

"$JAVA" "-Xmx$MEMORY" \
    $JAVA_OPT \
    -ea -esa \
    -cp "$CP" \
    $SAXON_CLASS \
    $SAXON_OPT \
    "$@"
