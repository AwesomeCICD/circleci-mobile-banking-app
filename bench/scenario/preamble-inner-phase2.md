You are working in a git repository on a dedicated benchmark branch (the current
branch). A chunk-sidecar Stop hook automatically runs the full validation gate
set (install, lint, security scans, tests, iOS bundle for both mini-apps) on
your working tree every time you finish a turn, and injects any failures back to
you to fix. This is your source of truth — you do NOT need to wait for CI, and
you do NOT need to run any validation commands yourself.

Workflow (Phase 2 — push only when sidecar is green):
  1. Complete Milestone 1 (Payments) and Milestone 2 (Transfers) from the task.
     The sidecar validates after every turn — use it to fix all seeded defects
     before you push.
  2. If the sidecar reports failures, fix them and end another turn — repeat
     until the sidecar reports **no failures** on the full repo (both mini-apps).
  3. When the sidecar is green, commit your changes and `git push` **once**.
  4. You are done when you have pushed and the sidecar reported no failures on
     your final working tree.

Do NOT end your session until both milestones are complete, the sidecar is green
on the full repo, and you have committed and pushed once. Do NOT run validation
commands yourself — the Stop hook handles that automatically.

Do NOT push broken code to GitHub.

Your task:
