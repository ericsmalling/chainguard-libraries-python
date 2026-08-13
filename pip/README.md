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

## Keeping lockfile hashes current

`pylock.toml` is a [PEP 751](https://peps.python.org/pep-0751/) lockfile pinning
each artifact to a SHA-256 hash. `pylock.toml.upstream` is the unmodified
version resolved from PyPI, kept for comparison.

[`../.github/workflows/update-pylock-hashes.yml`](../.github/workflows/update-pylock-hashes.yml)
runs `chainctl libraries update-hashes pylock.toml` weekly (and on demand via
**Run workflow**) and opens a pull request when the hashes change. The
`remediated` input switches the lookup to the `python-remediated` catalog so the
lockfile pins the `*+cgr.N` builds.

Note that `pylock.toml` stores one hash per artifact, so Chainguard hashes always
*replace* the upstream ones rather than being appended. Once the workflow has
run, the lockfile only installs against a Chainguard index.

To run it in your own fork, configure:

| Setting | Value |
|---|---|
| Secret `CHAINGUARD_IDENTITY` | A Chainguard assumable identity ID, created with `chainctl iam identity create github` and granted `libraries.python.pull_token_creator` |
| Variable `CHAINGUARD_ORG` | The organization holding the Python entitlement, passed as `--parent` |
| Repository setting | **Settings → Actions → General → Allow GitHub Actions to create and approve pull requests** |

The workflow authenticates through GitHub OIDC, so no long-lived pull token is
stored. `update-hashes` mints a short-lived pull token itself, which is why the
identity needs the token-creator role rather than plain `libraries.python.pull`.

## Iterate

To test a different package, edit `requirements.txt` and run the script again.
Each run recreates the `.venv` from scratch, so you always start clean — a fast
loop for confirming that any given dependency resolves through Chainguard
Libraries.
