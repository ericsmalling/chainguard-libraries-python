#!/usr/bin/env bash
# Create a throwaway pip project, configure direct access to Chainguard
# Libraries, and install packages to prove resolution works. See ./README.md.
# Requires the pull-token env vars — see ../tools/README.md.
set -euo pipefail

: "${CHAINGUARD_PYTHON_IDENTITY_ID:?Run: eval \"\$(chainctl auth pull-token --output env --repository=python)\" — see ../tools/README.md}"
: "${CHAINGUARD_PYTHON_TOKEN:?Run: eval \"\$(chainctl auth pull-token --output env --repository=python)\" — see ../tools/README.md}"

cd "$(dirname "$0")"

# Write a project-local .netrc from the pull token. pip resolves credentials
# through requests, which honors the NETRC environment variable.
cat > .netrc <<EOF
machine libraries.cgr.dev
  login ${CHAINGUARD_PYTHON_IDENTITY_ID}
  password ${CHAINGUARD_PYTHON_TOKEN}
EOF
chmod 600 .netrc
export NETRC="$PWD/.netrc"

rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip >/dev/null

# Swap in any dependency you want to test by editing requirements.txt, then
# re-run this script.
pip install -r requirements.txt
pip list
