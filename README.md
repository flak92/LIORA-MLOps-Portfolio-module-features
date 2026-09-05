# LIORA-MLOps-Portfolio-module-features

`module_features` — the canonical series in, the feature catalogue out: the bars of the timeframe register in the asset's database, one feature parquet per timeframe, and the contract `<TICKER>_catalogue.json` the ML layer reads.

Part of [LIORA-MLOps-Portfolio-Orchestration](https://github.com/flak92/LIORA-MLOps-Portfolio-Orchestration) — clone that repository recursively to run the
project; there this repository is the submodule `902-module_features/`, and
its stages run in one-off containers of its image. This repository also runs
standalone: `make setup`, then `make <stage> ASSET=<TICKER>` against the four
`STORE_*_DIR` it is given — the workspace's stores one level up by default, any
directory by setting the variables. `make help` lists the stages.

## Store contract

Every stage reads a store, writes a store and exits; it learns where the stores are from `STORE_RAW_1M_DIR`, `STORE_ASSETS_ARTIFACTS_DIR`, `STORE_RUN_RECORDS_DIR` and `STORE_STATUS_DIR`, and nothing else on the host.

| stage | reads | writes |
|---|---|---|
| `features-bars` | `ohlcv_1m_canonical` of the asset's database | the aggregation tables of the register, in the same database file |
| `features-catalogue` | the bars | `<TICKER>_features_<slot>.parquet`, one per timeframe, and `<TICKER>_catalogue.json` — the contract |
| `features-status` | the feature parquets | `STORE_STATUS_DIR/features_status.json` — the catalogue's facts and each asset's row counts |

## Image

`docker build -t liora-module-features .` — `python:3.12-slim`, the pins of `requirements.txt`, the package copied in; nothing of the state. Orchestration builds the same image as `docker compose build features` and runs every stage of this module in it.

## Documents

The module's front door is `module_features/README_module_features.md`; its own rules are
`module_features/skills/`. `AGENTS.md` and `module_skills/` here are read-only copies
of the canon in LIORA-MLOps-Portfolio-Orchestration, stamped by `module_skills/distributed_from.md`; a rule is
changed at the source and distributed, never edited here.

## Extending

| to add | change |
|---|---|
| an asset | `TICKERS` in the Orchestration Makefile and an `asset-<ticker>` block in its docker-compose.yml; nothing changes here |
| a timeframe, an indicator, a feature definition | one record in one register of `module_features/config.py` — `module_features/README_module_features.md` § Extending says what each costs and which bytes stay identical |

## Necessary duplicates

No module imports another. The objects below are owned here and, identically to
the byte, in the repositories named — registered in `module_skills/glossary.md`
§ Twice by extraction, marked `# twice by extraction` where they are defined,
and changed on every side at once.

| object | why here |
|---|---|
| `MILLISECONDS_PER_SECOND`, `MILLISECONDS_PER_MINUTE`, `MILLISECONDS_PER_DAY` (each module the ones it uses) | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-data`, `LIORA-MLOps-Portfolio-module-ml` |
| `DUCKDB_MEMORY_LIMIT` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-data`, `LIORA-MLOps-Portfolio-module-ml` |
| the store reads `STORE_ASSETS_ARTIFACTS_DIR`, `STORE_STATUS_DIR` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-data`, `LIORA-MLOps-Portfolio-module-ml`, `LIORA-MLOps-Portfolio-module-monitoring` |
| the descriptors `artifact_dir()`, `research_ohlcv_duckdb()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-data`, `LIORA-MLOps-Portfolio-module-ml` |
| `to_utc_ms()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-data`, `LIORA-MLOps-Portfolio-module-ml` |
| `build_ticker_parser()`, `parse_tickers()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-data`, `LIORA-MLOps-Portfolio-module-ml` |
| `RESEARCH_START_UTC`, `RESEARCH_END_UTC` (and their `_MS`) | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
| `catalogue_json()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
| `feature_id()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
| `TREND_GATE_FEATURE_DEFINITION` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
| `to_json_safe()`, `write_json()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
| `write_parquet()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
| `wilder_smoothing()`, `atr()`, `asof_index()` | twice by extraction — the other in `LIORA-MLOps-Portfolio-module-ml` |
