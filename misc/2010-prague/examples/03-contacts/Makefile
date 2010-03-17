MAP_KEY=***

USER=***
OUT=contacts.odt

##
## TODO: Does rely on the variable 'pwd' to be set!
##
contacts:
	saxon -xsl:google-contacts.xsl -it:main \
	    pattern=contacts-template.odt output="$(OUT)" \
	    user="$(USER)" pwd=$$pwd map-key="$(MAP_KEY)"

.PHONY: contacts
