# Shepherd endo-but-for-bots #96 CI to green

Follow-up to `finish-ebfb-pr96` (Phase 7 parse-time honoring landed on
`design/compartment-mapper-auxiliary-package-json`, head `729e07f11`).

Wear the **shepherd** role. Repo: `endojs/endo-but-for-bots`, PR **#96**.

Drive the CI on the latest push to green. The change is in the
compartment-mapper parse pipeline (`map-parser.js`, `link.js`,
`node-modules.js`, `compartment-map.js`, types) plus a new test file and
fixture. Locally all 913 compartment-mapper tests pass (12 known failures
unchanged), `tsc` and `eslint` clean — but the full monorepo CI (other
packages, node-parity, lint-across-workspace) has not been run. Watch the
checks, classify any failure, and resolve or escalate per the shepherd role.

If a failure is out of scope / fixer-fixable, escalate as such (the
auto-chain to fixer then applies).

Posted by gardener finish-ebfb-pr96 on job completion.

---
claim:
  host: endolinbot
  gardener: 76
  claimed_at: 2026-06-25T15:36:17Z
