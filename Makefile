# The module alone, in a venv, against the stores it reads: the workspace's by default (one level up), any other by
# setting the variables. The chain, the images and the residents are the Orchestration repository's; this file runs the
# module's own stages and nothing else.
PY := .venv/bin/python
# every stage takes its assets by --tickers; a stage without ASSET= stops here, not in the module
ASSET ?= $(error ASSET=<TICKER> is required)
# the stores this module reads, and only those — one variable per store, the workspace's by default
export STORE_ASSETS_ARTIFACTS_DIR ?= $(CURDIR)/../store_assets_artifacts
export STORE_STATUS_DIR ?= $(CURDIR)/../store_status
export OMP_NUM_THREADS := 1

.DEFAULT_GOAL := help

help:            ## list targets
	@grep -E '^[a-zA-Z][a-zA-Z0-9_-]*:[^#]*##' $(MAKEFILE_LIST) | sed -E 's/:[^#]*## / — /'
setup:           ## the module's venv from its pins
	python3 -m venv .venv && $(PY) -m pip install --quiet -r requirements.txt

features-bars:   ## canonical 1m -> every timeframe of the register, in ASSET's database
	$(PY) -m module_features.bars --tickers $(ASSET)
features-catalogue: ## every catalogued column on the decision grid, one parquet per timeframe, and <TICKER>_catalogue.json
	$(PY) -m module_features.catalogue --tickers $(ASSET)
features-status: ## features_status.json -> STORE_STATUS_DIR, for the assets named
	$(PY) -m module_features.status --tickers $(ASSET)
