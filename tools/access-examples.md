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

Write the export commands to a script to source later:

```shell
chainctl auth pull-token --output env --repository=python > python-access.sh
source python-access.sh
```

If you are a member of multiple organizations the preceding example commands
must use the `--parent` parameter with the name of your organization:

```shell
eval "$(chainctl auth pull-token --output env --parent=chainguard.edu --repository=python)"
```

```shell
chainctl auth pull-token --output env --repository=python --parent=chainguard.edu > python-access.sh
```

Create a policy for no cooldown and use it for Python:

```shell
chainctl libraries policy create --name=no-cooldown --cooldown-days=0
chainctl libraries policy describe no-cooldown
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
