
help:
	@echo 'Manage dotconfig environment'
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make clean                       remove the generated files         '
	@echo '   make publish                     generate using production settings '
	@echo '   make update                      upload the web site via gh-pages   '
	@echo '                                                                       '

clean:
	find $(OUTPUTDIR) -mindepth 1 -delete

update:
	git clone https://github.com/corifeo/dotfiles.git .

install:
	for file in *; do
	 if [ "$file" != "Makefile"| "$file" != "readme.md" ]; then
	  ln -fs $PWD/$file ~/.$file
	 fi
	done

publish:
	git add .
	git commit -am "make publish"
	git push pelican-web master

.PHONY: help clean publish update
