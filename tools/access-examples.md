# Example commands for Chainguard Libraries access

These `chainctl` commands set up and manage access to Chainguard Libraries for
Python. They are the same across package managers.

List entitlements:

```sh
chainctl libraries entitlements list
```

Create entitlement for Python with fallback to upstream PyPI activated:

```shell
chainctl libraries entitlements create --ecosystems=PYTHON --policy=CHAINGUARD_AND_UPSTREAM
```

Create pull token for access to Python libraries and output environment
variable commands. Token valid for 30 days. The `--output env` form sets
`CHAINGUARD_PYTHON_IDENTITY_ID` and `CHAINGUARD_PYTHON_TOKEN`, the variables the
per-tool index configuration reads.

```shell
chainctl auth pull-token --output env --repository=python
```

Evaluate the output directly to export both variables into the current shell:

```shell
eval "$(chainctl auth pull-token --output env --repository=python)"
```

Create pull token for access to Python libraries for the chainguard.edu
organization, output environment variable commands, and pipe commands into a
shell script. Change the parent parameter to your organization name.

```shell
chainctl auth pull-token --output env --repository=python --parent=chainguard.edu > python-access.sh
```

Load the environment variables for use in a terminal.

```shell
source python-access.sh
```

Create new pull token for access to Python libraries and set environment
variables:

```shell
eval $(chainctl auth pull-token --output env --repository=python --parent=chainguard.edu)
```

Create a policy for no cooldown and use it for Python:

```shell
chainctl libraries policy create --name=no-cooldown --cooldown-days=0
chainctl libraries policy enable --policy=no-cooldown --ecosystem=PYTHON --mode=ENFORCE
```

List policies

```shell
chainctl libraries policy list
```

List policy bindings to ecosystems:

```shell
chainctl libraries policy bindings list
```
