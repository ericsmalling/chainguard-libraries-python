# chainguard-libraries-python

This repository contains tools and example configuration for
[Chainguard Libraries for Python](https://edu.chainguard.dev/chainguard/libraries/python/).

The focus is on showing how to configure the common Python package managers to
consume Chainguard Libraries directly from `libraries.cgr.dev`.

Each package manager has its own folder with a `demo.sh` script and a README.
The script writes a project-local `.netrc` from the pull token, sets up a fresh
virtual environment, and installs a couple of packages so you can confirm they
resolve through Chainguard Libraries, including the remediated `*+cgr.N` builds.
The projects are hollow shells with no application code — they exist only to
prove the configuration and dependency resolution work, but the config is a
faithful template for a real project.

| Folder | Package manager |
|---|---|
| [`tools`](tools/README.md) | Shared access setup — `chainctl` commands and authentication, the same for every package manager |
| [`pip`](pip/README.md) | pip — `requirements.txt` with direct-access indexes |
| [`uv`](uv/README.md) | uv — `pyproject.toml` with `[[tool.uv.index]]` entries, plus a [CVE remediation demo](uv/cve-remediation/README.md) that scans with Grype |
| [`poetry`](poetry/README.md) | Poetry — `pyproject.toml` sources, including the required PyPI fallback |

## Prerequisites

* A Chainguard account with a Python libraries entitlement
* [`chainctl`](https://edu.chainguard.dev/chainguard/chainctl/) installed and authenticated
* Python 3.11+ and the package manager you want to try

## Getting started

Set up access with the `chainctl` commands and authentication notes in
[`tools`](tools/README.md). Creating an entitlement and a pull token is
identical across package managers; only the per-tool index configuration
differs, and that lives with each package manager's folder.

Once a pull token is exported into your shell:

```bash
eval "$(chainctl auth pull-token --output env --repository=python)"
```

run any package manager's demo, for example:

```bash
./pip/demo.sh
```

See the folder READMEs for the per-tool configuration details and how to swap in
your own dependencies to test.

## Resources

* [Chainguard Libraries product page](https://www.chainguard.dev/libraries)
* [Chainguard Libraries documentation](https://edu.chainguard.dev/chainguard/libraries/)
* [Chainguard Libraries for Python documentation](https://edu.chainguard.dev/chainguard/libraries/python/)
* [Chainguard learning labs with more demos](https://edu.chainguard.dev/software-security/learning-labs/)
* [Chainguard Libraries for Java examples](https://github.com/mosabua/chainguard-libraries-java)
* [Chainguard Libraries for JavaScript examples](https://github.com/mosabua/chainguard-libraries-javascript)
