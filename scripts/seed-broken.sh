#!/usr/bin/env bash
#
# seed-broken.sh — apply the deterministic "broken" state for the demo.
#
# The fiction: an AI agent was asked to "make the Payments screen feel more
# welcoming". It changed the title and started a refactor by importing
# TouchableOpacity to make the welcome line tappable, but never finished.
#
# Result:
#   - ESLint fails: 'TouchableOpacity' is defined but never used
#   - Jest fails:   getByText('Payments') no longer matches "Welcome to Payments"
#
# Both gates fail in chunk validate. The agent then fixes both in the loop.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$REPO_ROOT/miniapps/payments/src/App.js"

cat > "$TARGET" <<'EOF'
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

const App = () => (
  <View style={styles.container}>
    <Text style={styles.welcome}>Welcome back</Text>
    <Text style={styles.title}>Welcome to Payments</Text>
  </View>
);

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  welcome: { fontSize: 14, color: '#666' },
  title: { fontSize: 24, fontWeight: 'bold' },
});

export default App;
EOF

echo "Seeded broken state in $TARGET"
echo ""
echo "Run 'chunk validate' (or just let the Stop hook fire) to see both gates fail."
