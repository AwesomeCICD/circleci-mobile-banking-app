#!/usr/bin/env bash
#
# verify-phase2-seed.sh — confirm bench/base-phase2 fails the gates we expect
# before spending agent/CI dollars on a trial batch.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

git rev-parse --verify -q bench/base-phase2 >/dev/null || {
  echo "ERROR: bench/base-phase2 missing — run make-base-phase2.sh" >&2
  exit 1
}

START="$(git rev-parse --abbrev-ref HEAD)"
cleanup() { git checkout -q "$START" 2>/dev/null || true; }
trap cleanup EXIT

git checkout -q bench/base-phase2

fail() { echo "VERIFY FAIL: $*"; exit 1; }
pass() { echo "VERIFY OK:   $*"; }

echo "=== phase2 seed verification on bench/base-phase2 ==="

if (cd miniapps/payments && npm run lint >/dev/null 2>&1); then
  fail "payments lint should fail (unused vars in App.js and/or test file)"
else
  pass "payments lint fails as expected"
fi

pass "simulating lint-only fix (import + remove unused; test casing still wrong)..."
cat > miniapps/payments/src/App.js <<'JS'
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

const App = () => {
  const handleSend = () => {};

  return (
    <View style={styles.container}>
      <Text style={styles.welcome}>Welcome back, Alex</Text>
      <Text style={styles.title}>Welcome to Payments</Text>
      <TouchableOpacity onPress={handleSend} accessibilityRole="button">
        <Text style={styles.buttonLabel}>Send money</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  welcome: { fontSize: 14, color: '#666', marginBottom: 4 },
  title: { fontSize: 24, fontWeight: 'bold', marginBottom: 16 },
  buttonLabel: { fontSize: 16, color: '#007AFF' },
});

export default App;
JS
cat > miniapps/payments/__tests__/App.test.js <<'JS'
import React from 'react';
import { render } from '@testing-library/react-native';
import App from '../src/App';

test('renders Payments welcome and send button', () => {
  const { getByText } = render(<App />);
  expect(getByText('Welcome to Payments')).toBeTruthy();
  expect(getByText('Send Money')).toBeTruthy();
});
JS

if (cd miniapps/payments && npm run lint >/dev/null 2>&1); then
  pass "lint-only payments tree passes eslint"
else
  fail "lint-only payments tree should pass eslint"
fi

if (cd miniapps/payments && npm test -- --watchAll=false >/dev/null 2>&1); then
  fail "payments test should still fail after lint-only fix (wrong Send Money casing)"
else
  pass "payments test still fails after lint-only fix"
fi

git checkout -q -- miniapps/payments/src/App.js miniapps/payments/__tests__/App.test.js

if (cd miniapps/payments && npm test -- --watchAll=false >/dev/null 2>&1); then
  fail "payments test should fail (wrong Send Money casing)"
else
  pass "payments test fails as expected"
fi

if (cd miniapps/transfers && npm run lint >/dev/null 2>&1); then
  pass "transfers lint passes on seed"
else
  fail "transfers lint should pass on seed"
fi

if (cd miniapps/transfers && npm test -- --watchAll=false >/dev/null 2>&1); then
  fail "transfers test should fail (subtitle missing from App.js)"
else
  pass "transfers test fails as expected"
fi

pass "simulating milestone-1 payments-only fix..."
cat > miniapps/payments/src/App.js <<'JS'
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

const App = () => {
  const handleSend = () => {};

  return (
    <View style={styles.container}>
      <Text style={styles.welcome}>Welcome back, Alex</Text>
      <Text style={styles.title}>Welcome to Payments</Text>
      <TouchableOpacity onPress={handleSend} accessibilityRole="button">
        <Text style={styles.buttonLabel}>Send money</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  welcome: { fontSize: 14, color: '#666', marginBottom: 4 },
  title: { fontSize: 24, fontWeight: 'bold', marginBottom: 16 },
  buttonLabel: { fontSize: 16, color: '#007AFF' },
});

export default App;
JS
cat > miniapps/payments/__tests__/App.test.js <<'JS'
import React from 'react';
import { render } from '@testing-library/react-native';
import App from '../src/App';

test('renders Payments welcome and send button', () => {
  const { getByText } = render(<App />);
  expect(getByText('Welcome to Payments')).toBeTruthy();
  expect(getByText('Send money')).toBeTruthy();
});
JS

if (cd miniapps/payments && npm run lint >/dev/null 2>&1 && npm test -- --watchAll=false >/dev/null 2>&1); then
  pass "milestone-1 payments-only tree passes lint+test"
else
  fail "milestone-1 payments-only tree should pass lint+test"
fi

if (cd miniapps/transfers && npm test -- --watchAll=false >/dev/null 2>&1); then
  fail "transfers should still fail after milestone-1-only fix"
else
  pass "transfers still fails after milestone-1-only (expects 2nd CI round)"
fi

echo "=== all seed checks passed ==="
