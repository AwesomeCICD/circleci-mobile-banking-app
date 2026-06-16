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

# Restore files the phase2 task touches (payments + transfers).
git checkout HEAD -- \
  miniapps/payments/src/App.js \
  miniapps/payments/__tests__/App.test.js \
  miniapps/transfers/src/App.js \
  miniapps/transfers/__tests__/App.test.js 2>/dev/null || true

echo "Baseline restored: payments + transfers App.js and tests @ HEAD"
