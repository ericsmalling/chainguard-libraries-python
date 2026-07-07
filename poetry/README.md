# Poetry — direct access to Chainguard Libraries

[`demo.sh`](demo.sh) shows how to point Poetry at
[Chainguard Libraries for Python](https://edu.chainguard.dev/chainguard/libraries/python/)
and install packages directly from `libraries.cgr.dev`.

## What the script does

Running `demo.sh` writes a project-local `.netrc` from the pull token, then locks
and installs the dependencies declared in `pyproject.toml` into an in-project
virtual environment so you can watch them resolve through Chainguard Libraries —
including the remediated `*+cgr.N` builds.

The project is a **hollow shell** — it has no application code and does nothing
on its own. Its only job is to prove that the configuration is correct and that
dependency resolution works. That said, the `pyproject.toml` source
configuration is exactly what you would apply to a real Poetry project, so treat
it as a working template rather than a throwaway.

## Configuration

| What | Value |
|---|---|
| Config file | `pyproject.toml` |
| Sources | two primary `[[tool.poetry.source]]` entries — remediated (`.../python-remediated/simple`) and rebuilds (`.../python/simple`) |
| Auth mechanism | project-local `.netrc` referenced by the `NETRC` environment variable |

## The PyPI fallback requirement

Poetry must include a `PyPI` source as a **supplemental** fallback in
`pyproject.toml`. Without it, dependency resolution hangs indefinitely. This is
the one documented exception to the direct-only access path — the PyPI source
sits behind the Chainguard sources, so the remediated `*+cgr.N` builds are still
preferred.

## Run it

Export a pull token first (see [`../tools/README.md`](../tools/README.md)):

```bash
eval "$(chainctl auth pull-token --output env --repository=python)"
./demo.sh
```

## Iterate

To test a different package, edit the `dependencies` in `pyproject.toml` and run
the script again. Each run recreates `poetry.lock` and the in-project `.venv`
from scratch, so you always start clean — a fast loop for confirming that any
given dependency resolves through Chainguard Libraries.
