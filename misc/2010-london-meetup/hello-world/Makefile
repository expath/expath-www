SAXON=$$HOME/bin/saxon
XSPEC_XSLT=$$HOME/projects/xslt/xspec/trunk/generate-xspec-tests.xsl
XSPEC_XQUERY=$$HOME/projects/xslt/xspec/trunk/generate-query-tests.xsl
XSPEC_REPORT=$$HOME/projects/xslt/xspec/trunk/format-xspec-report.xsl

test:
	"$(SAXON)" -xsl:"$(XSPEC_XSLT)" -s:test/hello.xspec -o:test/hello-xsl.xsl
	"$(SAXON)" -xsl:test/hello-xsl.xsl -it:"{http://www.jenitennison.com/xslt/xspec}main" \
	    -o:test/hello-xsl.xml
	"$(SAXON)" -xsl:"$(XSPEC_REPORT)" -s:test/hello-xsl.xml -o:test/hello-xsl.html
	open test/hello-xsl.html
	"$(SAXON)" -xsl:"$(XSPEC_XQUERY)" -s:test/hello.xspec -o:test/hello-xq.xq
	"$(SAXON)" --xq -o:test/hello-xq.xml test/hello-xq.xq
	"$(SAXON)" -xsl:"$(XSPEC_REPORT)" -s:test/hello-xq.xml -o:test/hello-xq.html
	open test/hello-xq.html

.PHONY: test
