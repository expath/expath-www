SAXON=$$HOME/bin/saxon

MAP_KEY=****

USER=username
PWD=****
OUT=contacts-test.odt

contacts:
	echo contacts...
	"$(SAXON)" --b -xsl:google-contacts.xsl -it:main \
	    pattern=contacts-pattern.odt output="$(OUT)" \
	    user="$(USER)" pwd="$(PWD)" map-key="$(MAP_KEY)"

.PHONY: contacts
