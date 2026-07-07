# pip — direct access to Chainguard Libraries

[`demo.sh`](demo.sh) shows how to point pip at
[Chainguard Libraries for Python](https://edu.chainguard.dev/chainguard/libraries/python/)
and install packages directly from `libraries.cgr.dev`.

## What the script does

Running `demo.sh` writes a project-local `.netrc` from the pull token, creates a
fresh virtual environment, and installs the pinned packages from
`requirements.txt` so you can watch them resolve through Chainguard Libraries —
including the remediated `*+cgr.N` builds.

The project is a **hollow shell** — it has no application code and does nothing
on its own. Its only job is to prove that the configuration is correct and that
dependency resolution works. That said, the `requirements.txt` index
configuration is exactly what you would apply to a real pip project, so treat it
as a working template rather than a throwaway.

## Configuration

| What | Value |
|---|---|
| Config file | `requirements.txt` |
| Indexes | `--index-url` `libraries.cgr.dev/python/simple` and `--extra-index-url` `.../python-remediated/simple` |
| Auth mechanism | project-local `.netrc` referenced by the `NETRC` environment variable |

pip resolves credentials through its vendored `requests`, which honors the
`NETRC` environment variable. The remediated index provides the `*+cgr.N`
artifacts that satisfy the pinned specifiers and are preferred.

## Run it

Export a pull token first (see [`../tools/README.md`](../tools/README.md)):

```bash
eval "$(chainctl auth pull-token --output env --repository=python)"
./demo.sh
```

## Iterate

To test a different package, edit `requirements.txt` and run the script again.
Each run recreates the `.venv` from scratch, so you always start clean — a fast
loop for confirming that any given dependency resolves through Chainguard
Libraries.
