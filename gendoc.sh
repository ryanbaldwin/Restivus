#! /bin/bash
cp ../src/README.md .
jazzy \
	--source-directory ../src/ \
	--readme README.md \
	-a 'Ryan Baldwin' \
	-u 'https://www.github.com/ryanbaldwin' \
	-m 'Restivus' \
	-g 'https://github.com/ryanbaldwin/Restivus' \
	--min-acl public
