SITEVISION_API_BASE_URL=http://help.sitevision.se/webdav/files/apidocs/
SITEVISION_API_URL=$(SITEVISION_API_BASE_URL)overview-summary.html
JAVADOCSET_URL=http://kapeli.com/javadocset.zip
BUILD_DIR=build

all: $(BUILD_DIR)/SiteVision.docset

$(BUILD_DIR)/javadocset: $(BUILD_DIR)/javadocset.zip
	unzip -oq $< -d $(BUILD_DIR)

$(BUILD_DIR)/javadocset.zip:
	curl -so $@ $(JAVADOCSET_URL)

$(BUILD_DIR)/apidocs: $(BUILD_DIR)/apidocs.zip
	unzip -oq $< -d $(BUILD_DIR)

$(BUILD_DIR)/apidocs.zip:
	curl -s $(SITEVISION_API_URL) | grep -Eoi '[^"]+\.zip' | awk '{ print "$(SITEVISION_API_BASE_URL)" $$1 }' | xargs curl -so $@

$(BUILD_DIR)/SiteVision.docset: $(BUILD_DIR)/javadocset $(BUILD_DIR)/apidocs
	$< SiteVision $(word 2,$^) && mv SiteVision.docset $@

clean:
	rm -rf build
