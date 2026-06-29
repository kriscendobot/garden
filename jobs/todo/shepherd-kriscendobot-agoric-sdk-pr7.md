# Shepherd kriscendobot/agoric-sdk PR #7 — drive CI to green

Map: **shepherd** on **kriscendobot/agoric-sdk** PR #7 (OPEN, DRAFT, MERGEABLE; head
`fix/internal-hex-bufferish-validation` — "fix(internal): XS-safe hex decoding table (bounded
loop) + Bufferish codec validation"). BOT FORK — in scope (kriscendobot/agoric-sdk experimentation
is authorized; the hard line is upstream agoric/agoric-sdk only — no upstream interaction, keep
base+head on the fork). COMMUNICATE ON THE PR (comms directive): inline + a top-level summary
comment on #7; not the maintainer inbox.

## Goal
Drive the PR's CI to green. As of the latest run (28314216464) these checks FAIL (re-fetch fresh —
they may have moved): `lint-primary`, `lint-rest`, `test-codegen`, `test-quick (node-old)`,
`test-boot (node-new, 2, 4)`. Many others (build, gotest, golang lint, most test-boot shards incl.
the xs shards, flake-check, check-lockfiles) PASS.

## Procedure
Diagnose each failing job from its logs, classify (pre-existing/flaky/infra vs. introduced by this
PR's diff to `packages/internal/src/hex.js`), and fix what this PR should own. Re-run flakes;
green is the bar. Per the shepherd norm, if a failure is genuinely out of scope but fixer-fixable,
escalate as "needs fixer" — that verdict authorizes an auto-dispatched fixer that then resumes
shepherding to green (do not stop at the impasse). Keep all work base+head on the fork; never touch
upstream agoric/agoric-sdk.

## Deliverable
PR #7 CI green (or every remaining red explained as pre-existing/infra unrelated to the hex/Bufferish
diff, with evidence), pushed to the fork branch, and a top-level summary comment on #7 listing each
failure and how it was resolved.

<!-- garden-reaped: 1 -->
