# Tools and access setup for Chainguard Libraries for Python

Shared setup for consuming
[Chainguard Libraries for Python](https://edu.chainguard.dev/chainguard/libraries/python/)
directly from `libraries.cgr.dev`.

Creating an entitlement and a pull token is the same regardless of which
package manager you use. That common part is documented here. The index
configuration that *does* differ — `requirements.txt` index URLs, `pyproject.toml`
sources, `.netrc`, and so on — lives with each package manager's own example.

## In this folder

| Resource | Purpose |
|---|---|
| [`access-examples.md`](access-examples.md) | `chainctl` command examples — entitlements, pull tokens, and policies. Start here to set up credentials. |

## Authentication

Direct access to the Chainguard Libraries for Python repositories uses a
Chainguard Libraries pull token, exported as environment variables:

```bash
eval "$(chainctl auth pull-token --output env --repository=python)"
```

This sets `CHAINGUARD_PYTHON_IDENTITY_ID` and `CHAINGUARD_PYTHON_TOKEN`, which
the per-tool index configuration reads. See
[`access-examples.md`](access-examples.md) for the full set of `chainctl`
commands, including entitlements, organization-scoped tokens, and policies.

## Indexes

Python resolution uses two Chainguard contexts. Configure both, with the
remediated context taking priority:

```
https://libraries.cgr.dev/python-remediated/simple   # remediated *+cgr.N artifacts
https://libraries.cgr.dev/python/simple              # Chainguard rebuilds
```

## Per-tool configuration

The indexes and pull-token credentials are consumed differently by each package
manager:

| Package manager | Configuration | Auth mechanism |
|---|---|---|
| [pip](../pip/README.md) | `requirements.txt` (`--index-url` / `--extra-index-url`) | `.netrc` |
| [uv](../uv/README.md) | `pyproject.toml` (`[[tool.uv.index]]`) | `.netrc` or credentials in the index URL |
| [Poetry](../poetry/README.md) | `pyproject.toml` (`[[tool.poetry.source]]`) | credentials in the source URL |

See each package manager's folder README for its exact configuration and a
runnable `demo.sh`.

> **Poetry note:** Poetry must include a `PyPI` source as a fallback in
> `pyproject.toml`. Without it, dependency resolution hangs indefinitely. This
> is the one documented exception to the direct-only access path.
