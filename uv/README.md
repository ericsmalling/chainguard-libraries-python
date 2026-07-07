# uv — direct access to Chainguard Libraries

[`demo.sh`](demo.sh) shows how to point uv at
[Chainguard Libraries for Python](https://edu.chainguard.dev/chainguard/libraries/python/)
and install packages directly from `libraries.cgr.dev`.

## What the script does

Running `demo.sh` writes a project-local `.netrc` from the pull token, creates a
fresh virtual environment, then locks and syncs the dependencies declared in
`pyproject.toml` so you can watch them resolve through Chainguard Libraries —
including the remediated `*+cgr.N` builds.

The project is a **hollow shell** — it has no application code and does nothing
on its own. Its only job is to prove that the configuration is correct and that
dependency resolution works. That said, the `pyproject.toml` index configuration
is exactly what you would apply to a real uv project, so treat it as a working
template rather than a throwaway.

## Configuration

| What | Value |
|---|---|
| Config file | `pyproject.toml` |
| Indexes | two `[[tool.uv.index]]` entries — remediated (`.../python-remediated/simple`) and rebuilds (`.../python/simple`, default) |
| Auth mechanism | project-local `.netrc` referenced by the `NETRC` environment variable |

`index-strategy = "unsafe-best-match"` lets uv pick the best match across both
indexes, so the remediated `*+cgr.N` builds are chosen.

## Run it

Export a pull token first (see [`../tools/README.md`](../tools/README.md)):

```bash
eval "$(chainctl auth pull-token --output env --repository=python)"
./demo.sh
```

## Iterate

To test a different package, edit the `dependencies` in `pyproject.toml` and run
the script again. Each run recreates the `.venv` and `uv.lock` from scratch, so
you always start clean — a fast loop for confirming that any given dependency
resolves through Chainguard Libraries.

## CVE remediation demo

The [`cve-remediation`](cve-remediation/README.md) subfolder builds on this same
uv setup to show vulnerability remediation: it pins deliberately vulnerable
dependency versions and scans the installed environment with Grype to confirm
the remediated `*+cgr.N` builds clear the High-severity CVEs.
