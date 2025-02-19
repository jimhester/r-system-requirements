IMAGE ?= rstudio/r-system-requirements
VARIANTS = trusty xenial bionic jessie stretch centos6 centos7 opensuse42 opensuse15

RULES ?= rules/*.json

all: build-all

define GEN_BUILD_IMAGES
build-$(variant):
	docker build -t $(IMAGE):$(variant) docker/$(variant)/.

test-$(variant):
	docker run -it --rm -v $(PWD):/work -e DIST=$(variant) -e RULES=/work/$(RULES) $(IMAGE):$(variant) /work/test/test-packages.sh

bash-$(variant):
	docker run -it --rm -v $(PWD):/work -e DIST=$(variant) -e RULES=/work/$(RULES) $(IMAGE):$(variant) /bin/bash

BUILD_IMAGES += build-$(variant)
TEST_IMAGES += test-$(variant)
endef

$(foreach variant,$(VARIANTS), \
	$(eval $(GEN_BUILD_IMAGES)) \
)

build-all: $(BUILD_IMAGES)

test-all: $(TEST_IMAGES)