# to install functx in eXist, just go to http://localhost:8080/exist/repo/repo.xml
# or http://localhost:8080/exist/repo/packages/fxsl-1.0.xar?install=true :-)

run:
	saxon --xq hello.xqm \!indent=yes

install:
	xrepo install ../../../../../../xlibs/functx/pkg/functx-1.0.xar

remove:
	xrepo remove functx-1.0
