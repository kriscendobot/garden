Pushed clean to `main2` on the first attempt. Job complete.

---

## Completion report — `encode-ci-parity-policy`

**Commit:** `3141b829ae` on `main2` (`docs(policy): a CI lint/test failure is a defect in our automation`), pushed to `origin/main2` first-try (no CAS contention).

**Policy encoded** (@kriskowal, 2026-07-20, via liaison): any lint/test failure in CI is a defect in our automation's failure to anticipate it; every lint/test CI runs must run locally before pushing; a local-pass/CI-fail discrepancy is itself an environment-parity defect to close, never worked around with a one-off green push.

**Three edits, canonical prose once, cross-linked (not duplicated):**

1. **`roles/COMMON.md` § Reporting** — a terse standing norm placed directly after the "verified requires real-execution evidence" norm (its sibling in spirit). Three points (a/b/c) as specified; points to `local-verify`, `pre-push-gates`, `ci-failure-classification-loop`. This is the index prose only; detail lives in the skills.

2. **`skills/local-verify/SKILL.md`** — reframed the opening from optimization to **invariant** (speed is now stated as a *consequence* of the invariant, not its purpose). Added a new **"Parity is the contract"** section: the local set must cover every check CI runs (enumerate against CI config, not guesswork); a local-pass/CI-fail failure is either a coverage gap or an environment divergence; the fix is always two-part (green the PR **and** close the gap). Referenced the endo `yarn`/`ava`/`eslint` bin-shim parity case. Bumped `updated: 2026-07-20`; added a dated field note.

3. **`skills/ci-failure-classification-loop/SKILL.md`** — added **"The parity question (atop every class): was this anticipable locally?"** as a fifth question over the A/B/C/D classes: when a red check is one `local-verify` should have caught, the loop must also emit the parity follow-up (close coverage gap / restore env parity), not merely green the PR; a not-locally-anticipable failure carries no follow-up. Cross-linked to `local-verify`. Bumped `updated: 2026-07-20`; added a dated field note. (Also incidentally fixed a pre-existing `gamut → gauntlet` arrow to `->` per typist-friendly style, since I touched that line.)

**Checks run:**
- Grepped my *added* lines for disallowed code points (em-dash, arrow, ellipsis, curly quotes, `≤`/`≥`) — **clean**. My initial drafts introduced em-dashes matching the legacy surrounding prose; I rewrote them to periods/colons/parens per `em-dash-style`, since new violations shouldn't be added even where legacy text has them.
- Verified all cross-link targets exist (`local-verify`, `pre-push-gates`, `ci-failure-classification-loop`) and that intra-doc anchors resolve (`#parity-is-the-contract`, `#the-steps-in-order`, `#the-parity-question-atop-every-class-was-this-anticipable-locally`).
- The `scripts/jobs/library-link-*` checkers only resolve the ingested `journal/library/` reference graph, not `roles/`/`skills/` source files, so they do not validate these edits; I validated the cross-links by hand instead (stated per the job's "otherwise state what you checked").
- Inbox drained at the pre-commit checkpoint — empty.

**Activation:** These are `main2` docs. They take effect fleet-wide only after the next deliberate, leader-supervised deploy of `main2` to each root checkout (`scripts/jobs/deploy-garden.sh`); the deployed root trees do not carry the policy until then.

**Follow-ups:** None required. There is an existing auto-memory (`ci-failure-is-automation-defect.md`) already recording this policy for the fleet; the library now carries the durable encoding.
