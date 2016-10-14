.PHONY: clean-pyc clean-build clean-test release dist install

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean-test - remove test and coverage artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "release - package and upload a release"
	@echo "dist - package"
	@echo "install - install the package to the active Python's site-packages"
	@echo "rst - convert README.md to README.rst"

clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -f .coverage
	rm -fr htmlcov/

lint:
	flake8 injectemoji tests

test:
	python setup.py test

coverage:
	coverage run --source inject_emoji setup.py test
	coverage report -m
	coverage html
	open htmlcov/index.html

release: clean
	python setup.py sdist
	python setup.py bdist_wheel
	twine upload -s dist/inject*

test-release: clean
	python setup.py sdist
	python setup.py bdist_wheel
	twine upload -r test -s dist/inject*

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

install: clean
	python setup.py install

rst:
	pandoc --from=markdown --to=rst README.md -o README.rst

update-bundled-emoji:
	cd emoji-cheat-sheet.com && git fetch --all && git pull --all && cd ..
	cp emoji-cheat-sheet.com/public/graphics/emojis/*.png emojis

bundled-list:
	@head -n 19 injectemoji.py > tmp.py
	@ls -m emojis | sed -E -e "s/.png, /', '/g" \
		-e "s/^(.*)', '/'\1',/" \
		-e "s#'(\+|\-)#r'\\\\\1#g" \
		-e "s/zzz.png/ 'zzz']/" \
		-e "s/^(r'\\\+)/BUNDLED_EMOJI = [\1/g" \
		-e '2,$$ s/^(.*)/					\1/' >> tmp.py
	@grep -B 2 -A 100 '^def main' injectemoji.py >> tmp.py
	@autopep8 --aggressive --experimental --in-place tmp.py
	@mv tmp.py injectemoji.py

