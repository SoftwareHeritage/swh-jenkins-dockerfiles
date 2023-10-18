REGISTRY?=swh-jenkins
DOCKERFILES=$(shell find * -type f -name Dockerfile)
NAMES=$(subst /,\:,$(subst /Dockerfile,,$(DOCKERFILES)))
IMAGES=$(addprefix $(REGISTRY)/,$(NAMES))
DEPENDS=.depends.mk
MAKEFLAGS += -rR

export DOCKER_BUILDKIT := 1

JENKINS_UID ?= 115
JENKINS_GID ?= 120
DOCKER_GID ?= 999

DOCKER_BUILD := docker build --build-arg REGISTRY=$(REGISTRY) --build-arg uid=$(JENKINS_UID) --build-arg gid=$(JENKINS_GID) --build-arg docker_gid=$(DOCKER_GID)

.PHONY: all run exec check checkrebuild $(NAMES) $(IMAGES)

all: $(NAMES)

help:
	@echo "A smart Makefile for your dockerfiles"
	@echo ""
	@echo "Read all Dockerfile within the current directory and generate dependendies automatically."
	@echo ""
	@echo "make all              ; build all images"
	@echo "make checkrebuild all ; build and check if image has update availables (using apk or apt-get)"
	@echo "                        and rebuild with --no-cache is image has updates"
	@echo ""
	@echo "You can chain actions, typically in CI environment you want make checkrebuild push all"
	@echo "which rebuild and push only images having updates availables."

.PHONY: $(DEPENDS)
$(DEPENDS): $(DOCKERFILES)
	grep '^FROM \$$REGISTRY/' $(DOCKERFILES) | \
		awk -F '/Dockerfile:FROM \\$$REGISTRY/' '{ print $$1 " " $$2 }' | \
		sed 's@[:/]@\\:@g' | awk '{ print "$(REGISTRY)/" $$1 ": " "$(REGISTRY)/" $$2 }' > $@
sinclude $(DEPENDS)

$(NAMES): %: $(REGISTRY)/%
ifeq (run,$(filter run,$(MAKECMDGOALS)))
	docker run --rm -it $<
endif
ifeq (exec,$(filter exec,$(MAKECMDGOALS)))
	docker run --entrypoint sh --rm -it $<
endif
ifeq (check,$(filter check,$(MAKECMDGOALS)))
	./check_update.sh $<
endif

$(IMAGES): %:
	$(DOCKER_BUILD) -t $@ $(subst :,/,$(subst $(REGISTRY)/,,$@))
ifeq (checkrebuild,$(filter checkrebuild,$(MAKECMDGOALS)))
	./check_update.sh $@ || ($(DOCKER_BUILD) --no-cache -t $@ $(subst :,/,$(subst $(REGISTRY)/,,$@)) && ./check_update.sh $@)
endif
