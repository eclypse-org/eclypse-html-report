.DEFAULT_GOAL := check

check:
	pre-commit run -a

changelog:
	cz bump --changelog

patch:
	cz bump --increment patch

setup:
	python -m pip install --upgrade pip
	pip install poetry==1.8.4
	poetry config virtualenvs.create false
	poetry install --with=dev,deploy --no-root

format:
	docformatter --config pyproject.toml --in-place eclypse_html_report
	black --config=pyproject.toml eclypse_html_report
	pycln --config=pyproject.toml eclypse_html_report
	isort eclypse_html_report

build: format
	poetry build -v --no-cache --format wheel

try: build
	pip uninstall eclypse-html-report -y && pip install dist/eclypse_html_report-0.1.0-py3-none-any.whl
	eclypse-html-report -f ~/eclypse-sim/EchoApp

verify:
	twine check --strict dist/*

publish-test: build verify
	poetry publish -r test-pypi --skip-existing -v

publish: build verify
	poetry publish --skip-existing -v
