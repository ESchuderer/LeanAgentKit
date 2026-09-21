# AGENTS.md

## Stack
- Python 3.12+. uv for environments and locking, ruff for lint and format, pytest.

## Commands
- Install: `uv sync` (creates `.venv` from `uv.lock`)
- Add a dependency: `uv add <pkg>`; dev tools: `uv add --dev pytest ruff`
- Test: `uv run pytest -q`
- Lint and format: `uv run ruff check --fix .` then `uv run ruff format .`
- Types: `uv run pyright` (when it is a dev dependency)

## Conventions
- `pyproject.toml` holds metadata and dependencies; `uv.lock` is committed and never edited by hand.
- `src/<package>/` layout, tests in `tests/`.

## Docs
- https://docs.astral.sh/uv/guides/projects/, https://docs.astral.sh/ruff/, https://docs.pytest.org/

## Skills
- `npx skills add mindrally/skills@python-uv` (community)

## Pitfalls
- TODO

## Do not touch
- TODO
