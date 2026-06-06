---
ts: 2026-06-06T05:43:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--092a08
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
refs:
  - entries/2026/06/06/051500Z-dispatch-builder-d94d05.md
  - entries/2026/06/06/052513Z-result-builder-101dc2.md
  - https://github.com/endojs/endo-but-for-bots/pull/426
---

# dispatch: shepherd — drive #426 (master-into-llm sync) CI to green

User directive (2026-06-06, this terminal session): *"Please dispatch
a subagent to merge actual/master into bots/llm for a PR to merge the
branches, then shepherd that PR through CI."* The builder dispatch
`d94d05`/`101dc2` opened PR #426 DRAFT this cycle
(`entries/2026/06/06/052513Z-result-builder-101dc2.md`); this is the
follow-on shepherd half of the directive.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#426` (`chore: merge actual/master
  into llm (2026-06-06)`), DRAFT, base `llm` at `2bd9e0c`, head
  `merge/actual-master-into-llm-20260606` at `6180467`.
- **Merge commit**: `61804678` consolidates the absorbed upstream
  master (`4a04d078`, `feat(compartment-mapper): Host module exits
  (#2422)`) into the bot fork's `llm` roadmap branch with 9 file-
  level conflict resolutions:
  - `.github/workflows/release.yml`: took upstream's newer
    `changesets/action@63a615b9c…` (v1.8.0) pin.
  - `package.json` (root): kept curated bot-side devDependencies
    (matches 2026-06-03 precedent).
  - `packages/eslint-plugin/lib/configs/internal.js`: folded both
    intents.
  - `packages/ocapn-noise/test/failures.test.js`,
    `packages/ocapn/test/codecs/{passable,subtypes}.test.js`,
    `packages/ocapn/test/python-test-suite/index.js`,
    `packages/zip/src/format-writer.js`: bot-side substance +
    numeric-separator propagation.
  - `yarn.lock`: regenerated via `corepack yarn install` (net 2 lines).
- CI rollup at dispatch: 25 named checks, all just started (in-
  progress or queued).

## Out-of-scope drift the builder surfaced

Carried forward from the builder's result, for your awareness (do
NOT address under this dispatch banner; they predate the merge):

- `makeClient`/`registerNetlayer` API drift: bot-side `client/index.js`
  does not export `registerNetlayer`; master's
  `packages/ocapn/test/netlayer-tcp-syrup.test.js` imports it. Standing
  gap from 2026-05-21.
- `eslint-plugin-unicorn` peerDep without root devDep: yarn warned
  `YN0002`. Benign at install.

Either of these may surface as a CI failure on PR #426 (the
netlayer-tcp-syrup test may fail at import time). Classify those as
"deeper" rather than "CI-fixable" if you see them, and escalate to
liaison via your `result`. They are not your job to fix in this
dispatch.

## Task

Per `roles/shepherd/AGENT.md`:

1. Watch CI converge across the 25 checks.
2. As each check completes, classify per the four-bucket scheme:
   flake (re-enqueue), CI-fixable (your push), fixer-shaped (escalate
   via `next: fixer` in your result, steward's shepherd→fixer auto-
   pickup chain handles it), deeper (escalate to liaison).
3. For CI-fixable, commit on
   `merge/actual-master-into-llm-20260606` and force-with-lease push.
   The standard merge-into-llm sync pattern has documented CI-fixables
   in past precedents (yarn.lock regenerations, workflow-pin syncs);
   read the prior weaver results cited in the builder's brief for
   pattern recognition.
4. For fixer-shaped or deeper, escalate with the classification
   inventory.

## Authorizations (per-action, forwarded by steward)

- **Push to** `merge/actual-master-into-llm-20260606` for CI-fixable
  fixes. Standard shepherd authority.
- **Top-level summary comment** on PR #426 after CI converges or you
  escalate. The `endo-but-for-bots` standing broad-comment
  authorization covers this.
- **Re-enqueue runs** via `gh run rerun <id> --failed` for any job
  whose failure signature you classify as a flake.

## Deliverable

A `result` entry under `journal/entries/2026/06/06/` carrying:

- The classification of each failed job (flake / CI-fixable /
  fixer-shaped / deeper).
- The root-cause hypothesis you confirmed by reading the logs.
- If you pushed a fix: the commit SHA(s) and the post-fix CI
  convergence state.
- If you escalated: the `next: <role>` classification per
  `roles/shepherd/AGENT.md` § Escalation classification, the failure
  inventory (job names, file paths, line numbers, root-cause
  hypothesis), and guidance for the next role's brief.
- A `Self-improvement: ...` line.

End your turn with a concise summary to the orchestrator. The
orchestrator tears down your dispatch root on return.
