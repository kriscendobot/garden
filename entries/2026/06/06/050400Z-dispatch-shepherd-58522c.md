---
ts: 2026-06-06T05:04:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--58522c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - entries/2026/06/06/045700Z-result-steward-baa56b.md
  - entries/2026/06/06/045539Z-result-weaver-baa56b.md
  - https://github.com/endojs/endo-but-for-bots/pull/75
---

# dispatch: shepherd — drive #75 CI to green after the rebase regression

User directive (2026-06-06, this terminal session): *"Please shepherd
#75 through CI. It regressed with the rebase."* The rebase landed
this cycle via weaver dispatch `baa56b`
(`entries/2026/06/06/045539Z-result-weaver-baa56b.md`); the user's
note that CI regressed is the trigger for this shepherd dispatch.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#75`, branch
  `kriskowal-random-chacha12`, head `675c2d7`. Base `master` at
  `5865ff10`. 10 commits.
- **CI rollup at dispatch**: 17 named checks; 15 FAILURE, 2 SUCCESS.
  - SUCCESS: `build`, `zizmor`.
  - FAILURE (broad regression): `browser-tests`, `lint`,
    `test-ocapn-guile-interop`, `test (22.x ubuntu)`,
    `test (22.x macos-15)`, `test (24.x ubuntu)`,
    `test (24.x macos-15)`, `cover`, `test262 (22.x ubuntu)`,
    `test262 (24.x ubuntu)`, `test-hermes`, `check-action-pins`,
    `viable-release`, `test-xs`, `test-ocapn-python`.

The breadth (15 of 17) suggests a single root cause rather than 15
independent failures: likely a lint or build-time error that
cascades into every test job because they all start with the same
build step.

## Rebase context (for root-cause hypothesizing)

The weaver's three non-trivial conflict resolutions, all from this
cycle's earlier dispatch:

1. **`packages/hex/test/{decode,encode}.bench.js`** — upstream's
   chacha12 rewrite (delete `_xorshift.js`, swap to
   `makeChaCha12(bobsCoffee32).fillRandomBytes`) vs master's
   underscore-numeric-literal lint refactor. Resolution: upstream's
   substance + master's underscore style.
2. **`packages/ocapn/test/{codecs/passable-fuzz,syrup/fuzz}.test.js`**
   — same chacha12 vs underscore-style conflict shape.
3. **`packages/ses/src/compartment.js`** — master's recent
   `5065e7215 fix(ses): Consolidate Compartment jsdoc comments`
   (54 minutes old at rebase time) vs upstream's `91cda2581`
   independently fixing the same JSDoc typing. Resolution: master's
   single-block structure + upstream's typed `@param`.

Plausible hypotheses ranked by breadth-fit:

- **(a) Lint regression in a single shared file** (e.g., one of the
  three conflict-resolved files, or a missing-import after the
  `_xorshift.js` delete) causing `lint` to fail and every other
  job's `lint` precondition to skip into failure. **Most likely**.
- **(b) Missing `yarn.lock` update** for a transitive dependency
  pulled in by the new chacha12/random packages. Would affect
  install in every job. **Plausible**.
- **(c) Type-check failure in `compartment.js`** from the woven
  JSDoc resolution. Would affect lint and build downstream. The
  fact that `build` passed makes this less likely; `lint` and
  type-check often run separately.
- **(d) Upstream-PR-only failure** that was masked by upstream
  being CONFLICTING and now surfaces on a clean base. Possible if
  the upstream content itself has bugs the maintainer hadn't yet
  resolved.

## Task

Per `roles/shepherd/AGENT.md`:

1. Pull the failure logs for two or three representative red jobs
   (suggested: `lint`, `test (22.x ubuntu)`, `check-action-pins`).
   The breadth-fit hypothesis is that one root cause explains many
   of the failures; finding the same signature on multiple jobs
   confirms it.
2. Classify each failure: flake (re-enqueue), real-but-CI-fixable
   (your push), real-and-fixer-shaped (escalate via the
   shepherd→fixer auto-pickup chain), real-and-deeper (escalate
   to liaison with classification).
3. For the CI-fixable class (formatting, lockfile, missing import,
   workflow-pin sync), commit the fix on `kriskowal-random-chacha12`
   and force-with-lease push. Then watch CI converge.
4. For the fixer-shaped class (substantive code change beyond CI
   plumbing), name `next: fixer` in your `result` and stop. The
   steward picks up the auto-pickup chain (per
   `roles/steward/AGENT.md` § Shepherd → fixer) and dispatches a
   fixer with your failure inventory inlined.

## Authorizations (per-action, forwarded by steward)

- **Push to** `kriskowal-random-chacha12` for CI-fixable fixes
  (formatting, lockfile sync, lint cleanup, workflow-pin sync).
  Standard shepherd authority.
- **Top-level summary comment** on PR #75 if CI converges to green,
  citing the green run URLs. The `endo-but-for-bots` standing broad-
  comment authorization covers this. If you escalate instead, the
  summary lands as a comment naming the next-role classification.
- **Re-enqueue runs** via `gh run rerun <id> --failed` for any
  job whose failure signature you classify as a flake.

## Deliverable

A `result` entry under `journal/entries/2026/06/06/` carrying:

- The classification of each failed job (flake / CI-fixable /
  fixer-shaped / deeper).
- The root-cause hypothesis you confirmed (or rejected) by reading
  the logs.
- If you pushed a fix: the commit SHA(s) and the post-fix CI
  convergence state.
- If you escalated: the `next: <role>` classification per
  `roles/shepherd/AGENT.md` § Escalation classification, the
  failure inventory (job names, file paths, line numbers, root-
  cause hypothesis), and any guidance for the next role's brief.
- A `Self-improvement: ...` line.

End your turn with a concise summary to the orchestrator. The
orchestrator tears down your dispatch root on return.
