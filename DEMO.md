# Demo Script: Chunk Sidecars

A 4-minute live demo. Total commands you run on stage: **two shell commands and three messages to Claude**.

---

## Overview

### What's a Chunk Sidecar?

A **sidecar** is a remote sandbox that runs the same commands your CI runs — install, lint, test, build — *while you code*. It lives next to your editor, not at the end of a pull request.

Every time the agent (Claude Code) finishes a turn, the sidecar automatically runs those commands. If something fails, the failure appears inside the chat. The agent fixes it and continues. By the time you push, CI has nothing to find.

### What this demo proves

> Validation belongs **before** the commit, not after.

The audience sees an agent introduce two real bugs, the sidecar catch them in seconds, the agent fix them, and the push hit CI green — first try.

### Time budget: 4 minutes total

| Beat | Time |
|---|---|
| Frame the problem | 0:30 |
| Show the broken file | 0:30 |
| Send message 1 → lint fails → fix | 0:45 |
| Send message 2 → test fails → fix | 0:45 |
| Send message 3 → all green | 0:20 |
| Push → CI confirms green | 0:50 |

---

## What you need open

1. **Editor** with `miniapps/payments/src/App.js` visible (left half of screen)
2. **Claude Code terminal** launched from inside this repo (right half of screen)
3. **Browser tab** pre-navigated to your CircleCI pipeline page (ready in background)

Font on the terminal: **18pt minimum** so the back row can read error lines.

---

## Pre-flight (do this backstage, before the talk)

```bash
cd ~/projects/mobile/circleci-mobile-banking-app

# Confirm you're on a clean main
git status                              # clean
git pull --ff-only

# Show your sidecar is alive
chunk sidecar current                   # → circleci-mobile-banking-app  9748a2ea-...

# Optional, but a nice opener for the talk:
chunk validate --list                   # shows the 8 gates this sidecar will run

# Warm the sidecar so the live run is fast
chunk validate                          # green in ~13s

# Apply the broken state for the demo
./scripts/seed-broken.sh

# Launch Claude Code from inside the repo (so the Stop hook activates)
claude
```

You're now ready. **Do not run `chunk validate` again before stage** — the first failure needs to happen live.

---

## On-stage script

### Beat 1 — Frame the problem (0:00 → 0:30)

**Say to the audience:**

> AI agents push fast, and what they push is often broken. CI catches it eventually — but eventually costs money and time. What if validation happened *before* the agent's commit ever left the laptop?
>
> That's what Chunk Sidecars do. Let me show you.

*(Optional opener if you want to make the sidecar visible up front:)*

```bash
chunk sidecar current
chunk validate --list
```

> *"Here's my sidecar. It runs the same eight commands my CircleCI pipeline runs — install, lint, test, build, for each mini-app."*

### Beat 2 — Show the broken file (0:30 → 1:00)

**Open `miniapps/payments/src/App.js` in your editor.** Audience sees:

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

> I asked Claude to make the Payments screen feel more welcoming. It added a welcome line, updated the title, started importing `TouchableOpacity` for some interactivity it never finished. To a human skimming the diff, this looks shippable. Let's see what the sidecar thinks.

### Beat 3 — Message 1: the sanity check (1:00 → 1:45)

**Switch to Claude Code. Type:**

```
Quick sanity check on the Payments changes before I push?
```

**What happens:**

- Claude reads the file, replies casually, ends its turn.
- The Stop hook auto-fires `chunk validate`.
- In about 7 seconds, the sidecar reports:

```
✗ lint-payments
  'TouchableOpacity' is defined but never used  no-unused-vars
```

**Say:**

> Seven seconds. The sidecar caught the dead import. Same lint rule CI would have run — just minutes earlier.

### Beat 4 — Message 2: fix the lint (1:45 → 2:30)

Claude proposes removing the unused import.

**Type:**

```
go ahead
```

**What happens:**

- Claude removes `TouchableOpacity` from the import line.
- Stop hook fires again. About 9 seconds later:

```
✗ test-payments
  Unable to find an element with text: Payments
```

**Say:**

> Lint passes now. But the test still asserts the old title text. Same loop, second iteration.

### Beat 5 — Message 3: fix the test (2:30 → 2:50)

Claude proposes updating the test to assert `'Welcome to Payments'`.

**Type:**

```
go ahead
```

**What happens:**

- Claude updates the test.
- Stop hook fires. About 13 seconds later, all 8 gates green.

**Say:**

> Two fixes. Under a minute total. The agent never touched CI.

### Beat 6 — Push and watch CI agree (2:50 → 4:00)

**In your terminal, type:**

```bash
git add miniapps/payments/
git commit -m "feat(payments): add welcome message"
git push
```

**Switch to the CircleCI browser tab.** Pipeline runs Payments + Transfers in parallel. Goes green.

**Closing line:**

> When the sidecar agrees, CI agrees. First push, first pass. That's what validation in the inner loop buys you.

---

## What NOT to type in message 1

These will deflate the demo because Claude will find the bug on its own:

- ❌ "Check for lint errors"
- ❌ "Is there any dead code?"
- ❌ "Run the tests"
- ❌ "Commit this"

Use one of the safe openers:

- ✅ `"Quick sanity check on the Payments changes before I push?"`
- ✅ `"Looks good — anything obvious?"`
- ✅ `"Validate my recent changes."`

---

## If something goes sideways

| What happened | Do this |
|---|---|
| `chunk validate` hangs past 30s | Run `chunk sidecar current` in another pane. If sidecar is healthy, retry. Otherwise, fall back to local: `(cd miniapps/payments && npm run lint && npm test)` |
| Stop hook didn't fire | You launched Claude Code from outside the repo. Quit, `cd` into the repo, run `claude` again |
| Claude caught the unused import in its first reply | Pivot: "Even better — but what about the test?" Send message 2 to continue |
| CI takes longer than 2 minutes | Have a screenshot of a previous green run ready. Pivot: "And in a previous run, you can see…" |
| Seed didn't apply | Run `./scripts/seed-broken.sh` quietly while talking. Then re-send message 1 |

---

## Between runs

```bash
./scripts/reset-clean.sh        # restores App.js and App.test.js
git reset --hard origin/main    # drops the demo commit (if you pushed during practice)
```

Then re-run the pre-flight from the top.

---

## Audience Q&A (likely questions)

**"How does it know to run after every turn?"**
A single command — `chunk init` — wires it up. That command generates `.claude/settings.json` with a Stop hook pointing at `chunk validate`. You don't write that file by hand.

**"What if the sidecar and CI disagree?"**
They run the same commands. `.chunk/config.json` and `.circleci/config.yml` in this repo are the same gates. We treat the two configs as one contract.

**"Doesn't this slow every Claude turn down?"**
By about 10–15 seconds on turns that change code, on a warm sidecar. That's CI's job, done in seconds instead of minutes — once per turn, not once per PR.

---

## Reusing this demo

Swap the bug class:

1. Edit `scripts/seed-broken.sh` — apply a different deterministic breakage.
2. Edit `.chunk/config.json` — change which gates run.
3. Edit `.circleci/config.yml` to match — sidecar and CI must stay in lockstep.
4. Update the **3-message script** in this file.

Keep `main` green so anyone can clone, seed, and run.
