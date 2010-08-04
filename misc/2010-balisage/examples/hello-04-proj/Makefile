build:
	cd balisage-hello/; xproj build

deploy:
	xrepo install -f balisage-hello/build/balisage-hello-1.0.xar

undeploy:
	xrepo remove balisage-hello-1.0

run:
	saxon --xq test.xqm \!indent=yes

clean:
	rm -f balisage-hello/build/balisage-hello-1.0.xar
