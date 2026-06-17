#!/usr/bin/env bash
# One-time / refresh Chunk sidecar for Phase 2 bench (Node + Trivy gates).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export CIRCLECI_ORG_ID="${CIRCLECI_ORG_ID:-34c234fa-acab-46bf-a2de-07e0008a2be1}"

echo "==> chunk auth"
chunk auth status >/dev/null

echo "==> fresh sidecar"
chunk sidecar forget 2>/dev/null || true
chunk sidecar create --org-id "$CIRCLECI_ORG_ID" --name "demo-react-miniapps-$(date +%m%d)"

echo "==> register SSH key (required before exec/validate)"
chunk sidecar add-ssh-key --public-key-file "${HOME}/.ssh/chunk_ai.pub"

echo "==> sync repo"
chunk sidecar sync

echo "==> install Trivy"
chunk sidecar exec --command "bash" --args "-lc" --args \
  "curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin && trivy --version"

echo "==> install Node 20 (binary tarball; apt-based install times out on sidecar exec)"
chunk sidecar exec --command "bash" --args "-lc" --args \
  "curl -fsSL https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz | sudo tar -xJ -C /usr/local --strip-components=1 && node --version && npm --version"

echo "==> warm validate (first run downloads Trivy DB)"
# chunk validate needs a TTY; piped stdout (CI, agents) deadlocks on 0.7.79.
bash "$ROOT/bench/chunk-validate-pty.sh"

SNAP="$(chunk sidecar snapshot create --name "demo-react-miniapps-$(date +%Y%m%d)" 2>&1 | tee /dev/stderr | rg 'Created snapshot' | rg -o '[0-9a-f-]{36}' | head -1)"
echo "==> snapshot: $SNAP"

chunk config set validation.sidecarImage "$SNAP"

echo "==> boot sidecar from snapshot"
chunk sidecar create --org-id "$CIRCLECI_ORG_ID" --image "$SNAP" --name "demo-react-miniapps"
chunk sidecar add-ssh-key --public-key-file "${HOME}/.ssh/chunk_ai.pub"
chunk sidecar sync
bash "$ROOT/bench/chunk-validate-pty.sh"

echo "==> sidecar ready. sidecarImage=$SNAP"
