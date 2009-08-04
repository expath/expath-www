SAXON=$$HOME/bin/saxon

MAP_KEY=ABQIAAAApauHa22s3jjpFII3xsFOmBQqOhBDBnQJ8Ao-CIne506W8LCJ2BRLlYzn22KelrVOyoJ7EA7OLwsGgw

USER=fgeorges.test
PWD=testtest
OUT=contacts-test.odt

# USER=fgeorges
# PWD=****
# OUT=contacts-fg.odt

contacts:
	echo contacts...
	"$(SAXON)" --b -xsl:google-contacts.xsl -it:main \
	    pattern=contacts-pattern.odt output="$(OUT)" \
	    user="$(USER)" pwd="$(PWD)" map-key="$(MAP_KEY)"

.PHONY: contacts
