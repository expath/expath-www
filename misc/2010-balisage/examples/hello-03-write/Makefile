pkg:
	mkdir balisage-hello
	cp hello.xql balisage-hello
	zip -r balisage-hello-1.0.xar expath-pkg.xml balisage-hello

deploy:
	xrepo install balisage-hello-1.0.xar

undeploy:
	xrepo remove balisage-hello-1.0

run:
	saxon --xq test.xqm \!indent=yes

clean:
	rm -f balisage-hello-1.0.xar
	rm -rf balisage-hello
