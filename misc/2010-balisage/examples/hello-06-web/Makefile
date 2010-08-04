build:
	xproj build

release:
	xproj release

deploy:
	xrepo --repo ~/tmp/servlex/repo install -f build/balisage-hello-web-1.0.xaw

.PHONE: build release deploy
