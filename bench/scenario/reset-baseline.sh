#!/usr/bin/env bash
#
# reset-baseline.sh — restore an identical clean starting state before every
# trial, for BOTH arms. The two arms must begin from byte-identical code so the
# only variable is how they validate (sidecar vs real CI).
#
# It hard-resets the demo files to the committed baseline on the bench branch.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Restore only the files the task touches, leaving the bench/ harness intact.
git checkout HEAD -- \
  miniapps/payments/src/App.js \
  miniapps/payments/__tests__/App.test.js 2>/dev/null || true

echo "Baseline restored: miniapps/payments/{src/App.js,__tests__/App.test.js} @ HEAD"
