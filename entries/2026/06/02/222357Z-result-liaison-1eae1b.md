---
ts: 2026-06-02T22:23:57Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/221403Z-dispatch-liaison-1eae1b.md
  - entries/2026/06/02/222230Z-result-fixer-1eae1b.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
---

# result: #394 git-CLI integration test added per kriskowal review

User asked for a subagent to respond to kriskowal review `4413543939`
on PR #394. Fixer `1eae1b` closed cleanly.

## Outcome

- **New head**: `b22e0db66` on `design/gateway-package-phase-6`
  (atop prior `b15126d72`, single regular-append commit).
- **Test added**: `packages/gateway/test/git-http-integration.test.js`
  (new file, 1 `test.serial`, skip-gated on absence of `git` /
  `git http-backend`).
- **Test exercises Bearer scheme** (`git -c http.extraHeader=Authorization: bearer <token>`):
  chosen because it's the most direct knob from the git CLI (no
  credential helper or askpass plumbing). The Basic-with-empty-user
  scheme has unit coverage in `git-http.test.js` plus the
  parser-pin invariant test ("does not confuse Bearer hex with
  Basic hex"); the integration test relies on that and exercises
  the Bearer path end-to-end.
- **Test shape**: ephemeral `http.createServer` on `127.0.0.1:0`;
  `resolveRepo` returns a capability backed by `git http-backend`
  CGI serving an on-disk bare repo. Three assertions: wrong bearer
  → 401, right bearer → push success, then `git clone` retrieves
  the pushed ref.
- **Gates clean**: `yarn format`, `yarn lint:eslint`, `yarn
  lint:types`, `yarn ava` all pass. 38 git-http tests (37 existing
  + 1 new); 275 full gateway-package tests.
- **No yarn.lock churn** (so no separate lockfile commit).
- **Top-level PR comment**: `4607470548`.
- **Out-of-scope items honored**: no `src/git-http.js` edits, no
  stack-wide Uint8Array/types.d.ts directive (that's a separate
  decision for the #393 stack), no base-branch edits, no un-draft,
  no re-request review.

## Teardown

`dispatches/fixer--1eae1b` torn down.

## Steward queue post-engagement

- **#387** all CI green at `e22369065`; awaits maintainer
  reassessment.
- **#401** kriskowal asks carried at `46ba16528`; awaits
  reassessment.
- **#394** integration test added at `b22e0db66`; awaits
  reassessment.
- **#403** CHANGES_REQUESTED on architectural pivot; awaits
  scoping.
- **#393** stack-wide directive; awaits scoping.
- **#244** retconned; awaits kmkmbp2021 boatman.
