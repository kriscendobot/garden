---
ts: 2026-06-15T06:34:47Z
kind: result
role: shepherd
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: liaison
dispatch_root: /home/kris/dispatches/shepherd--bd0354
short_id: bd0354
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 3
    role: target
    state: DRAFT
next: liaison
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/3
  - https://github.com/kriscendobot/agoric-sdk/pull/3#issuecomment-4705197221
  - entries/2026/06/13/171830Z-result-shepherd-04c6a8.md
  - entries/2026/06/12/035100Z-result-shepherd-076ec8.md
  - entries/2026/06/11/002445Z-result-shepherd-da85ac.md
---

# result: shepherd PR kriscendobot/agoric-sdk#3 (bd0354)

Resumed shepherd per kriskowal's `4493971710` ("Resume shepherd.") which sat
26 days because the prior shepherd attempts could not find a surgical path
within the project's stated design boundaries. Re-rsvp on 2026-06-15T05:55Z
triggered this dispatch.

## Pre / post head SHA

- Pre: `af25210c0fd921141908a193d268c935b4e0f3e3`
- Post: `af25210c0fd921141908a193d268c935b4e0f3e3` (no shepherd push; failures
  are design-decision-impasse per below).

## Verdict

`next: liaison`. PR #3's `node-old` matrix failures all share one root
cause: `node:sqlite` is a built-in only in Node 22.5+, and the matrix runs
`node-old = Node 20`. The PR body explicitly enumerates three resolution
options (drop Node 20 monorepo-wide; gate swing-store on `node-new` only;
accept the red as load-bearing signal) and defers the choice to the
maintainer. The shepherd cannot make that choice within safety guardrails;
even under the 2026-06-14 relaxed authority it remains *impasse: design
decision needed*.

## Re-run issued

`gh run rerun 26067725722 --failed -R kriscendobot/agoric-sdk` at 06:04Z
(this dispatch). Attempt 2 completed at 06:32Z with the same 12 FAILUREs
on the same head SHA. Reruns will not clear the failures; they are
deterministic on the engine mismatch and constraint conflict.

## Per-failure classification (head `af25210c0f`, run 26067725722 attempt 2)

12 FAILURE, 28 SUCCESS, 33 CANCELLED (matrix-fail-fast siblings of failing
node-old shards), 9 SKIPPED (workflow gates).

| Job | Diagnosis | Class |
| --- | --- | --- |
| `lint-primary` | `YN0028 The lockfile would have been modified by this install` under CI's hardened public-PR mode. Removes one `better-sqlite3: "npm:^10.1.0"` line in the resolved lockfile diff. Not reproducible locally with `YARN_ENABLE_HARDENED_MODE=true yarn install --immutable` on the same head (yarn 4.12.0, Node 22.22.2, fresh cache). CI-environment-only hardened-mode npm-metadata drift. Same shape as PR #5's prior shepherd Class 2 (entries/2026/06/10/043918Z). | env-acknowledge or fixer pass on the merge ref inside CI |
| `lint-rest` | `yarn constraints` reports `@agoric/swing-store invalid engines.node; expected "^20.9 || ^22.11", found "^22.16 || ^24.0"`. The PR deliberately raises the floor to `^22.16 || ^24.0` (`node:sqlite` requires Node 22.16+); the `yarn.config.cjs` constraint enforces the older range monorepo-wide. Resolving requires editing the global constraint or the PR's design choice; both are design-decision territory. | design decision |
| `test-boot (node-old, 0, 4)` | `Error [ERR_UNKNOWN_BUILTIN_MODULE]: No such built-in module: node:sqlite` at swing-store load on Node 20. AVA TAP reporter then crashes serializing the uncaught exception → downstream YAMLException. | design decision (Node 20 lacks `node:sqlite`) |
| `test-cosmic-swingset (node-old)` | Same `ERR_UNKNOWN_BUILTIN_MODULE` root via swing-store import. | design decision |
| `test-fast-usdc-deploy (node-old)` | Same root. | design decision |
| `test-governance (node-old)` | Same root. | design decision |
| `test-inter-protocol (node-old)` | Same root. | design decision |
| `test-quick2 (node-old)` | Same root. | design decision |
| `test-solo (node-old)` | Same root. | design decision |
| `test-swingset (node-old, 4, 5)` | Same root. | design decision |
| `test-zoe-swingset (node-old)` | Same root. (`test:xs` step itself is a no-op for this package; node-old shard is what runs.) | design decision |
| `test-quick (xs)` | Same root, downstream — the `xs` test step runs on a Node 20 host and transitively loads swing-store before any xsnap subprocess gets a chance to spawn. | design decision |

## Why this isn't shepherd-fixable

The 2026-06-14 maintainer directive (issue-comment `4701061078`) relaxed
shepherd authority to "pursue all tests passing in CI by whatever means
necessary until reaching an impasse or success." The escalation criteria
are *impasse* (need input the shepherd does not have) and *safety
guardrails* (actions the shepherd must not take). Both apply here:

- **PR body explicitly enumerates the design options.** The Node 20
  resolution is the architectural decision the PR defers to the maintainer
  by name. Three options listed verbatim in the PR description.
- **Safety guardrail: never bypass safety checks.** Silencing the
  `lint-rest` constraint by exempting swing-store in `yarn.config.cjs`
  would mask the constraint rather than address whether per-package
  `engines.node` deviation is the project's preferred shape.
- **Safety guardrail: structural decision needed.** Dropping Node 20 from
  the workflow matrix changes the project's published support surface;
  outside shepherd scope regardless of file count.

`lint-primary` is notionally a CI-environment-only drift the shepherd could
attempt to nudge with a speculative `yarn install` + lockfile recommit, but
the failure is not reproducible from the dispatch host (yarn 4.12.0, Node
22.22.2, fresh cache, hardened immutable install exits 0). A speculative
push would be guesswork, not a deterministic fix; the right move is to
include any lockfile reconciliation in whichever follow-up addresses the
node-old design choice.

## Prior shepherd entries cited

Searched May-June 2026 shepherd results on `kriscendobot/agoric-sdk`:

- `entries/2026/06/13/171830Z-result-shepherd-04c6a8.md` — PR #5 same
  project; documents the `runnerChain` cascade on `node-old` (different
  root cause, but same pattern of node-old failure on this fork).
- `entries/2026/06/12/035100Z-result-shepherd-076ec8.md` — PR #5 ses-ava
  range corroboration; documents the same hardened-mode lockfile drift
  pattern (Class 2).
- `entries/2026/06/11/002445Z-result-shepherd-da85ac.md` — PR #5 final
  shepherd; documents one-FAILURE terminal state (`test-dapp (node-new)`
  as MAINTAINERS env-acknowledge).
- `entries/2026/06/10/043918Z-result-shepherd-39f4a0.md` — PR #5 wider
  brief escalation, including the lint-rest YN0028 with yarn 4.12.0 vs 4.6
  resolution skew.
- `entries/2026/06/10/035700Z-result-shepherd-528eb6.md` — PR #5 trade-off
  framing (clear CI on existing substance vs complete deferred bump).

No prior shepherd entries specifically on PR #3 (`fix/node-sqlite-builtin`);
the steward's cycle-close at `entries/2026/05/19/001017Z-result-steward-7ccdf3.md`
records PR #3's first job-board engagement (cleaner pass; recommended
judge next). No subsequent shepherd dispatch was issued until this one.

## PR #3 comment posted

Per dispatch authorization ("Post top-level comment on PR #3 at-mentioning
@kriskowal with the verdict"):

- <https://github.com/kriscendobot/agoric-sdk/pull/3#issuecomment-4705197221>

Did not mark the PR ready/un-ready (per dispatch). Did not touch
upstream Agoric/agoric-sdk (per dispatch).

## Recommended next stage

`next: liaison`. Liaison should surface the verdict comment to kriskowal
and ask which of the PR body's three options to pursue:

- **Option (a)** drop Node 20 monorepo-wide → the upstream
  `mfig/nodejs-22-24` (`fa8f032461`) or `codex/drop-node-20-support`
  (`b201b08294`) branch lands first; this PR rebases. Next role:
  boatman (ferry the Node-20-drop upstream) or wait.
- **Option (b)** gate `swing-store` test step on `node-new` only.
  Requires `.github/workflows/test-all-packages.yml` edit. Next role:
  designer (decide the workflow shape) or fixer (apply mechanically).
- **Option (c)** accept the red `node-old` matrix entry as load-bearing.
  DRAFT state is already the right shape; next role: review-only.

Self-improvement: nothing new for skills or roles. The dispatch's structure
(prior-entry-search → per-job-log → classify → rerun → surface) worked as
expected. The 26-day stall on `4493971710` is the correct outcome when
no posture has authority to act — the host that holds the design decision
(kriskowal as maintainer) was the missing input, not a shepherd attempt.

Self-improvement: nothing this time.
