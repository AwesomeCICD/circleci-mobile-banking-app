#!/usr/bin/env bash
#
# seed-case-bug.sh — apply the "passes on macOS, fails on Linux" state.
#
# The fiction: an AI agent touched up the Payments fee logic and wrote the
# fees import as './Fees'. The file on disk is 'fees.js'.
#
# Result:
#   - macOS (case-insensitive APFS): jest, lint and bundle:ios all pass.
#     Metro never sees it — src/lib isn't reachable from index.js.
#   - Linux sidecar / CI: test-payments fails with
#       Cannot find module './Fees' from 'src/lib/payment.js'
#
# One gate fails in chunk validate. The agent fixes the case and the run goes green.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB="$REPO_ROOT/miniapps/payments/src/lib/payment.js"

git -C "$REPO_ROOT" checkout HEAD -- miniapps/payments/src/lib/payment.js
sed -i.bak "s#from './fees';#from './Fees';#" "$LIB" && rm -f "$LIB.bak"

echo "Seeded case-sensitivity bug in:"
echo "  $LIB"
echo ""
echo "Locally:     cd miniapps/payments && npx jest   # passes on macOS"
echo "On sidecar:  chunk validate test-payments       # fails on Linux"
