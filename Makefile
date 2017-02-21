VERSION=$(shell git rev-parse --short HEAD)

MD_SOURCES=docs/src/index.md \
					 docs/src/introduction.md \
					 docs/src/design.md \
					 docs/src/basics.md \
					 docs/src/type-level-routing.md \
					 docs/src/servers.md \
					 docs/src/contributing.md

SHARED_THEME_FILES=$(shell find docs/theme -d 1)

.PHONY: docs
docs: docs/index.html docs/hyper.pdf

docs/index.html: $(MD_SOURCES) $(SHARED_THEME_FILES) $(shell find docs/theme/html)
	pandoc $(SHARED_PANDOC_OPTIONS) \
		-t html5 \
		--standalone \
		-S \
		--toc \
		--top-level-division=chapter \
		--filter pandoc-include-code \
		-o docs/index.html \
		--base-header-level=2 \
		-V version:$(VERSION) \
		-V url:https://owickstrom.github.io/hyper \
		-V logo1x:theme/hyper@1x.png \
		-V logo2x:theme/hyper@2x.png \
		-V source-code-url:https://github.com/owickstrom/hyper \
		-V author-url:https://wickstrom.tech \
		-V 'license:Mozilla Public License 2.0' \
		-V license-url:https://raw.githubusercontent.com/owickstrom/hyper/master/LICENSE \
		--template=docs/theme/html/template.html \
	$(MD_SOURCES)

docs/hyper.pdf: $(MD_SOURCES) $(SHARED_THEME_FILES) $(shell find docs/theme/latex)
	pandoc $(SHARED_PANDOC_OPTIONS) \
	-t latex \
	--listings \
	--filter pandoc-include-code \
	-H docs/theme/latex/purescript-language.tex \
	-H docs/theme/latex/listings.tex \
	-V links-as-notes=true \
	-V documentclass=article \
	--toc --toc-depth=2 \
	 --number-sections \
	--latex-engine=xelatex \
	"--metadata=date:$(VERSION)" \
	-o docs/hyper.pdf \
	$(MD_SOURCES)

.PHONY: examples
examples:
	pulp build -I docs/src/type-level-routing
	pulp build -I examples
