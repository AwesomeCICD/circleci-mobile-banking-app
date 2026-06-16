Complete the partially started **Payments** welcome feature, then add a matching
personalized subtitle to **Transfers**. Work in **two milestones** — do not skip
ahead.

The branch contains deliberate work-in-progress and test drift. CI is your only
validator.

## Milestone 1 — Payments only (`miniapps/payments/`)

Fix and finish Payments **before touching any Transfers files**.

1. Fix and complete `src/App.js`:
   - Keep the personalized welcome subtitle (e.g. "Welcome back, Alex").
   - Keep a tappable **"Send money"** button using `TouchableOpacity` with an
     `onPress` handler (`handleSend` defined in the component).
   - Code must pass ESLint (no undefined components, no unused variables).
2. Fix `__tests__/App.test.js`:
   - Render the screen and assert the **"Send money"** button is present
     (exact text: `Send money` — case-sensitive).

**Stop milestone 1:** commit with a conventional-commit message scoped to payments,
`git push`, and end your turn. Wait for CI feedback before starting Milestone 2.

## Milestone 2 — Transfers (`miniapps/transfers/`)

Only after Milestone 1 CI feedback (Payments job green or you have fixed all
Payments failures from CI):

3. In `src/App.js`, add a personalized welcome subtitle below the title
   (e.g. "Welcome back, Alex" — same pattern as Payments).
4. Ensure `__tests__/App.test.js` passes with the subtitle assertion.

## Gates (both mini-apps)

Everything must pass: ESLint, Jest, Trivy, and iOS bundle for **both** mini-apps.
Do not weaken lint rules or delete tests.

When **both** milestones are complete and CI is green, stop.
