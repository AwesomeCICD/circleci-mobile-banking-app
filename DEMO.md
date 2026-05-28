# Demo Script: Chunk Sidecars

A 4-minute live demo. Two shell command sequences and three messages to Claude.

---

## Pre-flight (backstage, before the talk)

```bash
cd ~/projects/mobile/circleci-mobile-banking-app    # the demo repo
git status                                          # confirm clean main
chunk sidecar current                               # confirm sidecar is up
chunk validate                                      # warm it (green in ~13s)
./scripts/seed-broken.sh                            # apply the broken-agent state
claude                                              # launch Claude Code from inside the repo (so the Stop hook activates)
```

**Have open:**
- Editor with `miniapps/payments/src/App.js` (left of the screen)
- Claude Code terminal (right of the screen)
- Browser tab pre-loaded to your CircleCI pipeline page

---

## Beat 1 — Frame the problem  *(0:00 → 0:30)*

**Say:**

> AI agents push fast, and what they push is often broken. CI catches it eventually — but eventually costs money and time. What if validation ran *before* the agent's commit ever left the laptop?
>
> That's what Chunk Sidecars do. A sidecar is a remote sandbox that runs the same commands your CI runs — install, lint, test, build — while you're still coding.

**Optional, to make the sidecar visible up front:**

```bash
chunk sidecar current        # name + id of the active sidecar
chunk validate --list        # the 8 gates the sidecar will run
```

---

## Beat 2 — Show the broken file  *(0:30 → 1:00)*

**Do:** open `miniapps/payments/src/App.js` in your editor. Audience sees:

```javascript
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

const App = () => (
  <View style={styles.container}>
    <Text style={styles.welcome}>Welcome back</Text>
    <Text style={styles.title}>Welcome to Payments</Text>
  </View>
);
```

**Say:**

> I asked Claude to make the Payments screen feel more welcoming. Here's what it produced — added a welcome line, updated the title, started importing `TouchableOpacity` for some interactivity it never finished. To a human skimming this, it looks shippable. Let's see what the sidecar thinks.

---

## Beat 3 — Message 1: the sanity check  *(1:00 → 1:45)*

**Type to Claude:**

```
Quick sanity check on the Payments changes before I push?
```

> *Avoid prompts like "check for lint errors" or "is there dead code?" — they bias Claude into finding the bug itself instead of letting the sidecar do it.*

**What happens:** Claude reads the file, replies casually, ends its turn. Claude Code then fires its **Stop hook** — a shell command that runs automatically every time the agent finishes a turn. In this repo, `chunk init` configured that hook to run `chunk validate`. About 7 seconds later, validation surfaces:

```
✗ lint-payments
  'TouchableOpacity' is defined but never used  no-unused-vars
```

**Say:**

> Seven seconds. The sidecar caught the dead import — same lint rule CI would have run, just minutes earlier.

---

## Beat 4 — Message 2: fix the lint  *(1:45 → 2:30)*

Claude proposes removing the unused import.

**Type:**

```
go ahead
```

**What happens:** Claude edits the import line. Stop hook fires again, runs `chunk validate`. About 9 seconds later:

```
✗ test-payments
  Unable to find an element with text: Payments
```

**Say:**

> Lint passes now. But the title text changed, and the test still asserts the old copy. Same loop, second iteration.

---

## Beat 5 — Message 3: fix the test  *(2:30 → 2:50)*

Claude proposes updating the test assertion to `'Welcome to Payments'`.

**Type:**

```
go ahead
```

**What happens:** Test updated. Stop hook fires. All 8 gates green in ~13 seconds.

**Say:**

> Two fixes. Under a minute total. The agent never touched CI.

---

## Beat 6 — Push and watch CI confirm  *(2:50 → 4:00)*

**Type in your terminal:**

```bash
git add miniapps/payments/
git commit -m "feat(payments): add welcome message"
git push
```

**Switch to the CircleCI browser tab.** The `mobile-banking-pipeline` workflow runs Payments + Transfers in parallel, same commands the sidecar just ran.

**Say (as it goes green):**

> When the sidecar agrees, CI agrees. First push, first pass. That's what validation in the inner loop buys you.

---

## Between runs

```bash
./scripts/reset-clean.sh                # restore App.js and App.test.js to baseline
git reset --hard origin/main            # drop any commits you made during practice
```

Then re-run pre-flight from the top.
