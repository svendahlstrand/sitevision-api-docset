SITEVISION_API_BASE_URL=http://help.sitevision.se/webdav/files/apidocs/
SITEVISION_API_URL=$(SITEVISION_API_BASE_URL)overview-summary.html
JAVADOCSET_URL=http://kapeli.com/javadocset.zip

all: SiteVision.docset

javadocset: javadocset.zip
	unzip -oq $<

javadocset.zip:
	curl -sO $(JAVADOCSET_URL)

apidocs: apidocs.zip
	unzip -oq $<

apidocs.zip: javadocset
	curl -s $(SITEVISION_API_URL) | grep -Eoi '[^"]+\.zip' | awk '{ print "$(SITEVISION_API_BASE_URL)" $$1 }' | xargs curl -so apidocs.zip

SiteVision.docset: apidocs
	./javadocset SiteVision apidocs/

clean:
	rm -rf javadocset* apidocs* __MACOSX SiteVision.docset
