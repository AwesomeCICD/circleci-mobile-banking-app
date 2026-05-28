# Demo: Chunk Sidecars — Validation moves left

A 4-minute live stage demo. Built for LeadDev LDX3 London (June 2026), reusable for any inner-loop / shift-left story.

---

## Mental model

The audience watches two things on a split screen:

1. **You having a normal coding conversation with Claude** in Claude Code.
2. **The Chunk Sidecar's validation output landing in that conversation between turns.**

**You don't type `chunk validate`. You never tell Claude to run it.** The Stop hook does it automatically every time Claude finishes a turn. Your job on stage is just to chat with Claude like you would on any normal day.

So:

| Mode | When | What you do |
|---|---|---|
| Shell commands | **Pre-flight only**, never on stage | `seed-broken.sh`, `chunk sidecar current`, `chunk validate` warm-up |
| Typing to Claude | **The 4 minutes the audience sees** | Three short messages |
| Shell command | **The finale** | One `git push` |

The middle act — the actual show — is a three-message conversation. That's it.

---

## The story

**Setup the audience:**

> AI agents are now writing a meaningful chunk of every team's code. They're fast.
> They're also unvalidated. Every speculative test failure, every dead import, every
> half-finished refactor — gets pushed to CI, where the team's pipelines pay for it.
> CI minutes spike. PR queues lengthen. Engineers wait.

**The framing question:**

> What if we moved validation *left* — into the agent's own inner loop — so the
> same checks CI runs ran *before* anything got committed?

That's Chunk Sidecars.

---

## What you'll see (3 acts)

### Act 1 — The setup
The agent has just made what looks like a reasonable change to a Payments screen. It added a welcome line, tweaked the title copy, started a refactor by importing `TouchableOpacity`. To a reviewer skimming the diff, this looks shippable.

### Act 2 — The sidecar bites
The same gates CI runs — install, lint, test, bundle — run locally in the sidecar. **In about seven seconds**, the sidecar surfaces the first problem. The agent fixes it. Sidecar runs again. Surfaces the next problem. Agent fixes that. Sidecar runs again. Green.

Two iterations, end-to-end under a minute. The agent never touched the network. CI was never asked to do unpaid labour.

### Act 3 — The handshake
The agent pushes the change. The real CircleCI pipeline runs the same checks the sidecar just ran. Pipeline goes green. **First push, first pass.**

The point is simple: when validation lives where the agent works, CI stops being a debugger and goes back to being a release pipeline.

---

## On-stage runbook

### Pre-flight (shell only — do this before the talk, never live)

```bash
# 1. Working tree is clean and on main
cd ~/projects/mobile/circleci-mobile-banking-app
git status                                 # should be clean
git pull --ff-only origin main

# 2. Sidecar is active and healthy
chunk sidecar current                      # should show circleci-mobile-banking-app
chunk validate --list                      # should show all 8 gates

# 3. Warm the sidecar (cold first run is slower — do it now, not on stage)
chunk validate                             # expect green in ~13-15s

# 4. Apply the broken state
./scripts/seed-broken.sh                   # rewrites App.js AND App.test.js deterministically

# 5. Open in your editor with miniapps/payments/src/App.js visible
#    Open Claude Code in a terminal pane, INSIDE this repo:
#       cd ~/projects/mobile/circleci-mobile-banking-app && claude
#    (the Stop hook only activates when Claude Code is launched from this dir)
```

**Do not run `chunk validate` again** after seed-broken. You want the first failure to happen live, not as a cached scroll.

---

### The 3-message script (the heart of the demo)

This is everything you type to Claude during the 4 minutes:

```
Message 1:  Quick sanity check on the Payments changes before I push?
Message 2:  go ahead
Message 3:  go ahead
```

That's the whole demo. Three messages. Everything else — the validation output, the fix proposals, the second validation, the green run — happens around you.

#### What each message triggers

| Message | What Claude does | What the Stop hook does | What the audience sees |
|---|---|---|---|
| 1 — "Quick sanity check…" | Reads `App.js`, comments that it looks fine on a casual read | Runs `chunk validate` → fails at `lint-payments` in ~7s | Lint failure block appears in the Claude conversation |
| 2 — "go ahead" | Removes the unused `TouchableOpacity` import | Runs `chunk validate` again → fails at `test-payments` in ~9s | Test failure block appears |
| 3 — "go ahead" | Updates the test assertion to `'Welcome to Payments'` | Runs `chunk validate` again → all 8 gates green in ~13s | Green run, clean prompt returned |

After message 3, drop to your terminal and:

```bash
git add miniapps/payments/
git commit -m "feat(payments): add welcome message"
git push origin main
```

Switch to the CircleCI tab. The `mobile-banking-pipeline` workflow runs Payments + Transfers in parallel. Goes green. **First push, first pass.**

---

### Prompt selection — which opener to use

The first message matters more than the other two. The other two are just `"go ahead"`. Pick the opener that fits your delivery:

| Option | The opener | Why it works |
|---|---|---|
| **A — Confident shipper (recommended)** | `"Quick sanity check on the Payments changes before I push?"` | Casual. Claude does a surface skim, finishes its turn → sidecar bites. Maximum dramatic contrast (you sound ready; sidecar disagrees). |
| **B — Confident shipper, shorter** | `"Looks good — anything obvious before I push?"` | Even faster. Same arc as A. |
| **C — Enterprise-neutral** | `"Validate my recent changes."` | Sounds formal. Claude says "I'll run chunk validate" and finishes → hook runs validate anyway. Audience thinks Claude triggered it, which is fine. |

**Pick one and stick with it across rehearsals.** Don't improvise on stage.

#### Things NOT to say in message 1

These prompts will deflate the demo because they bias Claude into doing the sidecar's job before the sidecar gets to:

- ❌ `"Check for lint errors."` — Claude will find the unused import itself.
- ❌ `"Is there any dead code?"` — Same problem.
- ❌ `"Run the tests."` — Telegraphs the punchline.
- ❌ `"Commit this for me."` — Triggers the PreToolUse hook (~30s bundle), slow and confusing.

The whole point is that Claude doesn't catch the bugs in its initial review — the **sidecar** catches them. Keep Claude in "casual review" mode.

#### Things NOT to say in messages 2 and 3

After the sidecar surfaces a failure, **let Claude propose the fix in its own words.** Don't direct it. Just say `"go ahead"` or `"yes, fix it"`. Saying `"remove the unused import"` or `"update the test"` makes you look like the engineer driving the agent, which inverts the narrative.

---

### Stage beats with timing

| Beat | Time | What's happening | What you do |
|---|---|---|---|
| 1. Frame the problem | 0:00 → 0:30 | Narrative only | Speak to audience |
| 2. Show the broken change | 0:30 → 1:00 | Editor visible with `App.js` | Narrate the agent's "intent" |
| 3. Send message 1 | 1:00 → 1:30 | Claude reviews → Stop hook fires → lint fails | Type message 1 |
| 4. Send message 2 | 1:30 → 1:50 | Claude proposes fix; you accept; Stop hook fires → test fails | Type "go ahead" |
| 5. Send message 3 | 1:50 → 2:30 | Claude proposes test fix; you accept; Stop hook fires → green | Type "go ahead" |
| 6. Pause on green | 2:30 → 2:50 | All 8 gates green | Say closing line about sidecar/CI match |
| 7. Push | 2:50 → 3:10 | git add + commit + push | Type git commands |
| 8. Watch CI agree | 3:10 → 4:00 | Pipeline visible | Switch to CircleCI tab, narrate the green run |

### What to say at the key moments

- **After the first validate fails** (between Beat 3 and 4):
  > Seven seconds. The sidecar ran the exact same lint check CI would have run — and caught the dead import, before anything left this laptop.
- **After the second validate fails** (between Beat 4 and 5):
  > Lint passes now. But the title text changed, and the test still asserts the old copy. Same loop, second iteration.
- **When the sidecar goes green** (Beat 6):
  > Two iterations. Under a minute total. The agent never touched CI.
- **When CircleCI confirms** (Beat 8):
  > When the sidecar agrees, CI agrees. First push, first pass. That's what validating in the inner loop buys you.

---

### Recovery moves (if something goes sideways)

| Symptom | Most likely cause | What to do live |
|---|---|---|
| `chunk validate` hangs >30s | Sidecar lost its session | Run `chunk sidecar current` to confirm. Worst case: switch to the local fallback below. |
| Lint passes but you needed it to fail | `seed-broken.sh` wasn't run pre-flight | Quietly run `./scripts/seed-broken.sh` while talking, then re-run validate. |
| Stop hook doesn't fire | Claude Code launched from outside the repo dir | Quit Claude Code, `cd` into the repo, relaunch. The hook only loads when `.claude/settings.json` is on the path. |
| Claude finds the unused import in its first turn | Your prompt was too leading | Roll with it — pivot: "Even better. But what about the test?" then send message 2. The test failure beat still lands. |
| Claude fixes both bugs in one turn | Rare but possible | Lean into it: "Even faster than expected. Two issues, one pass." Skip to the push. |
| CI takes >2 minutes | Cold runner / cache miss | Have a screenshot of a previous green run ready; pivot to "and you can see in a previous run…" |

### Local-only fallback (no network / sidecar down)

If the sidecar is unreachable, the same gates run locally:

```bash
(cd miniapps/payments && npm run lint && npm test -- --watchAll=false)
```

Same output, same story. Lose the "sidecar matches CI environment" beat but keep the inner-loop demonstration.

---

## How the integration works (for audience Q&A)

If anyone asks **"How does it know to run after every turn?"** or **"Did you wire that up yourself?"** — here's the answer:

**`chunk init` did it.** The chunk CLI generates `.claude/settings.json` for you the first time you run it in a project. That file is the integration point.

Look at the file's top line:
```json
"_comment": "Generated by chunk init."
```

The relevant section is the `Stop` hook:

```json
"hooks": {
  "Stop": [
    {
      "hooks": [
        { "type": "command", "command": "chunk validate", "timeout": 600 }
      ]
    }
  ]
}
```

Claude Code fires the `Stop` hook every time the agent finishes a turn. The hook runs `chunk validate`. If validation fails (non-zero exit), Claude Code blocks the stop and feeds the validation output back into the conversation — so the agent's *next* turn starts with the failure context already loaded.

There's also a `PreToolUse` hook in the same file that runs `npm ci && npm run bundle:ios` before any `git commit` — defense in depth, same generator, same idea: "before you commit, prove the bundle still builds."

**One command — `chunk init` — wires all of it up. The agent integration is the product.**

---

## Anticipated audience questions

**Q: Doesn't this slow down every Claude Code turn by 7+ seconds?**
A: Yes, on turns where Claude actually changed code. But that's the trade. Sidecars run on warm cached environments — `npm ci` against a cache is sub-second. The total per-turn overhead is what CI does in seconds, not minutes. And it happens once per turn, not once per PR.

**Q: What if the sidecar disagrees with CI?**
A: It shouldn't, because it runs the same commands the CI config does. The `.chunk/config.json` and the `.circleci/config.yml` in this repo are the same six gates with the same arguments. When they drift, the demo's promise breaks — so we treat the two configs as a single contract.

**Q: Can I run this offline?**
A: The sidecar runs remotely (E2B by default), so no — *but* the local fallback (`npm run lint && npm test`) gives you the same gates locally, just without the matched-environment guarantee.

**Q: Does it work with other agents?**
A: The Stop hook is Claude Code's surface area, so this specific integration is Claude Code-shaped. The sidecar itself is agent-agnostic — `chunk validate` is just a command. Wire it into any agent's post-turn lifecycle and you get the same loop.

**Q: How does `chunk init` know what gates to set up?**
A: It detects the stack — sees `package.json`, picks up scripts like `lint`/`test`/`bundle`, picks up `jest` and `eslint` configs, and writes the gates accordingly. You can override or extend `.chunk/config.json` after.

**Q: What does the agent see when validation fails?**
A: The full `chunk validate` output is piped back into Claude's next turn as a system message. So the agent sees the same error lines you see — and proposes fixes against them directly, just like a developer reading their own CI logs.

---

## Reset between runs

```bash
./scripts/reset-clean.sh             # restores App.js AND App.test.js
chunk validate                       # confirm green baseline (~13s)
./scripts/seed-broken.sh             # re-seed for the next run
```

If you committed during the demo and want to undo that on your branch:

```bash
git reset --hard origin/main         # use with care — drops local commits
```

---

## Reusing this demo

This whole repo is a reusable demo artifact. To build your own variant:

1. Edit `scripts/seed-broken.sh` to change *what* the agent "did wrong" — different feature, different bug class.
2. Edit `.chunk/config.json` to change which gates run (add typecheck, swap lint rules, etc.).
3. Mirror those changes in `.circleci/config.yml` so the sidecar/CI contract holds.
4. Edit this `DEMO.md` to match — especially the **3-message script** and the **prompt selection** table.

Keep `main` green so any teammate can clone, seed, and run.
