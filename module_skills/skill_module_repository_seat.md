# Skill: a module repository — its shape, and its seat in the workspace

Every module of the chain is one repository of one shape, and it is seated in the
Orchestration repository the same way. This skill is the recipe for both: what a
module repository holds, file by file, and what adding one — `<9NN>-module_<domain>/`,
the next free number, never renumbered (`AGENTS.md` § Architecture shape) — touches in
Orchestration. *The repository shows the destination, not the road*: there is no
generator; the four repositories that exist are the template, and this page says
which of their files is which.

## The shape of a module repository

| file | what it is | the rule |
|---|---|---|
| `module_<domain>/` | the package, in the grammar of `AGENTS.md` § Canonical vocabulary: `config.py` (every path and every constant of the module), one `<stage>.py` per stage with `main()`, `README_module_<domain>.md`, `skills/` | a stage takes `--tickers` and reads its stores from its `STORE_*_DIR`; no import of another module (D05) |
| `module_<domain>/README_module_<domain>.md` | the front door: where the responsibility stops, § Stages, what it reads and writes, § Extending, § Design rationale — one row per object with the mapping-table row it answers to — and § Its normative skills | `AGENTS.md` § Pre-AWS architectural direction, *Every placement is argued* |
| `module_<domain>/skills/` | every rule about this module and nothing else | `AGENTS.md` § The default choice; D06 |
| `Dockerfile` | `FROM python:3.12-slim`, `WORKDIR /app`, the pins installed from `requirements.txt` — no such line when there are none — and `COPY module_<domain> /app/module_<domain>`: the code inside, nothing of the state | `skill_asset_containers.md` § The topology; D02, D04 |
| `.dockerignore` | `.git/`, `.venv/`, `__pycache__/` | — |
| `.gitignore` | `.venv/`, `__pycache__/`; nothing a stage writes is ever committed in a module repository — the stores are the workspace's, and a standalone run points them outside the checkout | `glossary.md` § Stores; D15 |
| `requirements.txt` | the module's direct dependencies, pinned to the versions the other repositories pin; the one line `# standard library only` when there are none | `AGENTS.md` § Values, *Minimum requirements*; D03, D21 |
| `Makefile` | `help`; `setup` (a venv from the pins, or an echo when there is nothing to install); one `<module>-<stage>` target per stage running `.venv/bin/python -m module_<domain>.<stage> --tickers $(ASSET)` — `python3` for a module with no dependency, `ASSET` as environment for a server role; `ASSET ?= $(error …)`, so a stage without one stops here; it exports only the `STORE_*_DIR` the module reads, defaulting one level up; it names no docker, compose or tmux | `AGENTS.md` § Canonical vocabulary, the Makefile-targets row; D14 |
| `README.md` | one page in a fixed order: the module in one sentence; *Part of Orchestration* — the standalone run and how a change reaches the project; § Store contract; § Image; § Documents; § Extending, its first row the asset rule; § Necessary duplicates — the rows of `glossary.md` § Twice by extraction this module owns, each naming the other owners | D23 |
| `AGENTS.md`, `module_skills/` | read-only copies of the canon, stamped by `module_skills/distributed_from.md`; written by `make skills-distribute` and by nothing else | `AGENTS.md` § The default choice; D08–D10 |

## Seating a module in the workspace

The order is the one a pin needs: the module repository exists and is pushed before
Orchestration names it.

1. **The repository.** `LIORA-MLOps-Portfolio-module-<domain>` on GitHub, branch `main`, the shape above; the package imports no other module; `docker build` in it succeeds from its tree alone.
2. **`.gitmodules` and the checkout.** `git submodule add -b main <url> <9NN>-module_<domain>` — the next free number; the entry carries `path`, `url` and `branch = main`.
3. **`Makefile`.** The checkout in `SUBMODULES` — the list `make build`, `make skills-status` and `make skills-distribute` iterate; one `<module>-<stage>` target per stage (a `fanout` or a `basket` line), each on the `| $(STORES)` order-only line, in the module's `<module>-all:` chain and in `all:` in dataflow order, with a `##` purpose so `make help` lists it; the recorded ones in `RECORDED_STAGES`.
4. **`docker-compose.yml`.** A runner service `<domain>` with `build: ./<9NN>-module_<domain>` and `image: liora-module-<domain>` under the `x-service` anchor — a resident, if the module serves, under `x-server` — and the service in `make build`'s list.
5. **The canon.** `make skills-distribute` gives the new repository its copies; a section for the module in `module_skills/README.md`, its skills linked by absolute URL; every count that names the modules moves in the same commit — `AGENTS.md` § Architecture shape (the repository table), `skill_asset_containers.md` § The topology, `module_skills/README.md`, `skill_pre_aws_solution.md` § Infrastructure seats and § The mapping table, the Orchestration `README.md` § The repositories.
6. **The drawing.** A `story_map` entry for `<9NN>-module_<domain>/` in both views of `sub_module_dx/visualisation_config.json` — the deployment view's nine digits are taken, so a new module joins the island whose primitive runs it — then `make dx-update`, committed alone.
7. **The pin.** `git add <9NN>-module_<domain>` and one commit here that says why; the module's `main` is pushed first, or a fresh recursive clone cannot check the pin out.

A module that writes an asset artifact also adds the artifact's descriptor to its own
`config.py`, its row to `file_manifest()` in `module_ml/status.py` — the asset README is
the ML module's — and its row and the new count to `glossary.md` § Artifacts.
