---
ts: 2026-06-07T04:42:00Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/shepherd--fe6783
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
next: fixer
refs:
  - entries/2026/06/07/043100Z-dispatch-shepherd-fe6783.md
  - entries/2026/06/07/035000Z-result-steward-426-unicorn.md
  - https://github.com/endojs/endo-but-for-bots/pull/426
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641430551
  - https://github.com/endojs/endo-but-for-bots/actions/runs/27081909650/job/79929282727
---

# result: shepherd — #426 two-line fix landed, BROADER lint cascade requires fixer

The dispatch brief targeted two `unicorn/numeric-separators-style` errors at `packages/9p-server/src/server.js:47:23` and `:49:18`. Those two errors are fixed and pushed as `7cf705e12` on `merge/actual-master-into-llm-20260606` (regular append push from `1d0f019a6`). CI will not converge green on the new tip because the actual lint failure is two orders of magnitude larger than the dispatch brief described.

## Fix landed

Commit `7cf705e12` `fix(9p-server): numeric-separators-style on MSIZE and U32 mask`:

```
const MIN_MSIZE = 4096;
-const DEFAULT_MSIZE = 131072;
+const DEFAULT_MSIZE = 131_072;

-const MASK_U32 = 0xffffffffn;
+const MASK_U32 = 0xffff_ffffn;
```

Underscore grouping matches the in-file convention at lines 621, 622, 903, 906 (`1_000_000_000n` thousands grouping) and the rule's 4-digit hex grouping default.

Pushed to `origin merge/actual-master-into-llm-20260606`: `1d0f019a6..7cf705e12`. Top-level summary comment on PR #426: <https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641430551>.

## Larger failure inventory uncovered

The dispatch brief's log read surfaced only the first two errors. The full `lint` job (<https://github.com/endojs/endo-but-for-bots/actions/runs/27081909650/job/79929282727>) reports **174 `unicorn/numeric-separators-style` ERRORs total across 54 files in 19 packages**, all with `Invalid group length in numeric value`. Top offenders:

| count | file |
| --- | --- |
| 73 | `packages/chat/node-crypto-shim.js` |
| 8 | `packages/daemon/test/channel.test.js` |
| 4 | `packages/ocapn-noise/test/_fabric-fragmenting.js` |
| 4 | `packages/daemon/src/bus-xs-core.js` |
| 4 | `packages/chat/heat-simulation.js` |
| 4 | `packages/9p-server/test/wire.test.js` |
| 4 | `packages/9p-server/src/types.js` |
| 3 each | `packages/ocapn/test/cbor/interop.test.js`, `packages/ocapn/src/cbor/encode.js`, `packages/endo-fs/src/shared/qid.js`, `packages/daemon/test/invite-retention.test.js`, `packages/daemon/test/git.test.js`, `packages/chat/command-executor.js`, `packages/chat/channel-header.js`, `packages/9p-server/src/server.js` (third remaining at 729:11) |
| 1–2 | the remaining 39 files |

Other affected packages (sample): `base64`, `bundle-source`, `cache-map`, `captp`, `check-bundle`, `cli`, `common`, `compartment-mapper`, `conversation-tree`, `daemon`, `demo`, `endo-fs`, `endo-fs-exec`, `errors`, `eslint-plugin`, `evasive-transform`, `eventual-send`, `eventual-send-test`, `exo`, `exo-git`, `exo-stream`, `fae`, `familiar`, `far`, `genie`, `git`, `goblin-chat`, `harden`, `hex`, `import-bundle`, `init`, `inventory-graph`, `jaine`, `lal`, `marshal`, `module-source`, `ocapn`, `ocapn-noise`, `pass-style`, `patterns`, `platform`, `promise-kit`, `sandbox`, `ses`, `ses-ava`, `ses-test`, `tar`, `trampoline`, `whylip`, `zip`.

## Root cause

The rule was enforced for the first time via the prior fixer chain (`f1fc5f`) that landed `5abcb01b7 chore: add eslint-plugin-unicorn to root devDeps`. The 2026-06-07T03:50Z steward result entry on this same PR (entries/2026/06/07/035000Z-result-steward-426-unicorn.md) attributed the original failure to a peerDep/devDep asymmetry from the master-into-llm merge and treated the fixer's devDep addition as completing the chain. It did, in the narrow sense of resolving the missing plugin; CI's lint check now exits with 174 ERRORs across the workspace rather than the prior "plugin not found" failure mode.

This is a class-of-error change, not a stale fix: rule enforcement turned on, the pre-existing literals were never massaged, and a workspace-wide pass is required.

## Verified autofix scope (informational, not committed)

Locally ran `corepack yarn lint:eslint --fix` from the project root. The autofix cleanly resolves **all 174 errors** (zero ERROR remaining; the pre-existing 2167 warnings persist unchanged) by modifying **74 files**. The diff is purely numeric-literal formatting; no semantic edits.

I reverted the autofix changes before the fixer-targeted commit because the brief's "out of scope: do NOT touch any other package" restriction is binding on me. Reverting was clean (`git checkout -- .`), then I hand-applied the two-line server.js fix only.

## Why this is not a shepherd job

- Touches 74 files across 19 packages, well past the shepherd's ~5-file ceiling per `roles/shepherd/AGENT.md` § Hard escalation points.
- Dispatch brief explicitly forbids touching other packages.
- The fix shape is mechanical (autofix-only, no logic decisions), but the volume and the workspace-wide scope match the fixer's surgical-multi-file mandate plus the `chore: yarn lint --fix` discipline rather than a shepherd's quick CI repair.

## Classification

**`next: fixer`**. Authorization shape needed in the fixer dispatch:

- Permission to run `corepack yarn lint:eslint --fix` workspace-wide and commit the 74-file result as a single `style: apply unicorn/numeric-separators-style autofix workspace-wide` (or similar `chore:` framing) on `merge/actual-master-into-llm-20260606`.
- Keep the lock file untouched (this is source-only; no yarn.lock chore needed).
- Append on top of `7cf705e12`; do not amend.

Failure inventory the fixer needs (job log URL pre-filtered to ERRORs only): <https://github.com/endojs/endo-but-for-bots/actions/runs/27081909650/job/79929282727>. The 174-line ERROR list is reproducible locally via `corepack yarn install && corepack yarn lint 2>&1 | grep 'unicorn/numeric-separators-style'`.

## Adjacent observation (informational)

PR #423 will inherit the same cascade once it rebases on top of an llm tip that includes the unicorn rule. The brief's "PR #423 will resolve via the #426 merge flow" framing is accurate only if the upstream merge fixes #426's lint first (which requires the workspace-wide autofix landing on #426). Otherwise #423 carries the same 174-error backlog.

## CI state at this entry's time

PR #426 head `7cf705e12`: most checks IN_PROGRESS, lint will fail (172 errors remaining), 24-test matrix will pass once it sees the fresh push. No flake to re-run.

Self-improvement: a dispatch brief that quotes only the first few lines of a log tail is a known failure mode when the failing tool produces a long error list. A pre-dispatch shepherd habit of pre-counting errors in the failing check (one `gh run view ... --log-failed | grep -c error`) before composing the brief would catch the 174-vs-2 gap at brief-write time rather than at dispatch-execute time. This is a steward-side improvement, not a shepherd-side one; routing to liaison.
