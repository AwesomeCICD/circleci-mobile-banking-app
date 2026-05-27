# circleci-mobile-banking-app

[![CircleCI](https://circleci.com/gh/AwesomeCICD/circleci-mobile-banking-app/tree/main.svg?style=svg)](https://circleci.com/gh/AwesomeCICD/circleci-mobile-banking-app/tree/main)

A CircleCI demo of a brownfield mobile banking app — React Native mini-apps bundling on Linux, handing off to a native iOS shell building on macOS, through security scanning to TestFlight and App Store submission.

Built to showcase **Chunk Sidecars**: moving CI validation into the inner loop so feedback lands in seconds, before any commit hits CI.

---

## What this demo shows

**The problem:** AI agents flood CI with unvalidated commits. Test failures and lint errors burn through CI minutes and slow the whole team down.

**The fix:** Chunk Sidecars run the same checks CI runs — locally, automatically, in under a minute, before any push.

**The result:** When the sidecar says green, CI agrees. First time, every time.

The on-stage walkthrough lives in [`DEMO.md`](./DEMO.md).

---

## Architecture

```
[Build RN: Payments] ─┐
                       ├─ [upload-artifacts] ─ [validate] ─ [build-native-shell] ─ [security-scans] ─ [deploy-testflight] ─ [approve-release] ─ [submit-app-store]
[Build RN: Transfers] ─┘
```

### Stage 1 — React Native Mini-Apps (Linux, parallel)

Two minimal React Native projects under `miniapps/`:

```
miniapps/
├── payments/    — Payments mini-app
└── transfers/   — Transfers mini-app
```

Each runs `npm install`, ESLint, Jest, and `react-native bundle` to produce a real iOS `.jsbundle`.

### Stage 2 — Native iOS Shell (macOS)

The native shell is a UIKit app (`Game/GameViewController.swift`) that reads `bundle_manifest.json` from the main bundle at launch and displays which React Native mini-app modules were assembled into the build — build number, branch, module name, platform, bundle size.

### Stage 3 — Security & Distribution

Snyk dependency scan, simulated SonarQube analysis, Fastlane to TestFlight, QR code distribution to Slack, manual approval gate, then App Store submission.

---

## Chunk Sidecar configuration

The sidecar config lives in [`.chunk/config.json`](./.chunk/config.json). Gates run in order:

| Stage | Commands | Why |
|---|---|---|
| Install | `install-payments`, `install-transfers` | `npm ci` for each miniapp |
| Lint | `lint-payments`, `lint-transfers` | ESLint — catches `no-unused-vars` and friends |
| Test | `test-payments`, `test-transfers` | Jest — catches behaviour regressions |
| Bundle | `bundle-payments`, `bundle-transfers` | `react-native bundle` — catches Metro errors |

A failing gate blocks the validation run, so the agent sees feedback before its turn ends.

The `.claude/settings.json` `Stop` hook runs `chunk validate` automatically every time Claude Code finishes a turn. That's the inner-loop magic.

---

## Reusing this demo

```bash
# 1. Clone
git clone git@github.com:AwesomeCICD/circleci-mobile-banking-app.git
cd circleci-mobile-banking-app

# 2. Install miniapp dependencies
(cd miniapps/payments && npm ci)
(cd miniapps/transfers && npm ci)

# 3. Seed the "broken" demo state
./scripts/seed-broken.sh

# 4. Open Claude Code and run the demo
#    See DEMO.md for the on-stage walkthrough.

# 5. Reset to clean baseline when done
./scripts/reset-clean.sh
```

To run the demo with your own Chunk sidecar, see [`DEMO.md`](./DEMO.md) for the full setup.

---

## Orbs

| Orb | Version | Purpose |
|---|---|---|
| `circleci/aws-cli` | 5.4.0 | OIDC-based AWS authentication |
| `circleci/aws-s3` | 4.1.1 | S3 artifact upload/copy |
| `circleci/slack` | 4.14.0 | Slack notifications |
| `snyk/snyk` | 2.3.0 | Dependency vulnerability scanning |
| `tadashi0713/app-distribution` | 1.2.0 | QR code generation and Slack distribution |

---

## Environment Variables

| Variable | Purpose |
|---|---|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC assumption |
| `AWS_REGION` | AWS region |
| `S3_BUCKET_NAME` | Artifact storage bucket |
| `SNYK_TOKEN` | Snyk API token |
| `CIRCLE_TOKEN` | CircleCI API token (for QR code generation) |
| `SLACK_ACCESS_TOKEN` | Slack bot token |
| `SLACK_DEFAULT_CHANNEL` | Default Slack channel |

Apple and Fastlane credentials are stored in 1Password.
