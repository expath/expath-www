FOP_HOME=../../../../../../tmp/fop/trunk/
HTML=../../../../../../Documents/xml/balisage/balisage-html.xsl
FO=/Applications/oxygen-11.2/frameworks/docbook/xsl/fo/docbook.xsl

Bal2010geor0901.html: Bal2010geor0901.xml
	saxon -s:$< -o:$@ \
	    -xsl:$(HTML)

Bal2010geor0901.fo: Bal2010geor0901.xml
	saxon -s:$< -o:$@ \
	    -xsl:$(FO) \
	    shade.verbatim=yes

Bal2010geor0901.pdf: Bal2010geor0901.fo
	export FOP_HOME=$(FOP_HOME)
	$$FOP_HOME/fop $< $@
