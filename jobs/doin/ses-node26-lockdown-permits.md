---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# SES lockdown on Node.js 26: silence the removed/tolerated-intrinsics report

## Background

`packages/ses/src/cauterize-property.js` (endojs/endo, upstream `master`) is
what emits SES's intrinsics-report warnings during `lockdown()`:
- `Removing <path>` — a property found on some intrinsic that is NOT listed
  in `packages/ses/src/permits.js` at all (permits didn't anticipate it).
- `Tolerating undeletable <path> === undefined` — a property that couldn't
  actually be deleted, but whose value was nulled out.

A newer Node.js major routinely adds/changes global intrinsics ahead of
`permits.js` catching up, so `lockdown()` under a new Node major logs these
warnings even when nothing is actually unsafe — noise that should be silenced
by an explicit, audited permit, not suppressed.

## Step 1 — reproduce and capture the logs

Install/use Node.js **26** (via nvm/volta/whatever toolchain is available;
Node 26 should already be a published release by now — verify, don't assume).
In a fresh checkout of `packages/ses` at endojs/endo's **upstream master**
(fetch `master` directly from `endojs/endo`, not our `llm`/bot branch — this
change needs to be based on real upstream to be upstreamable later), run the
package's lockdown under Node 26 and capture ALL `console.warn`/`console.error`
output verbatim — every `Removing ...` and `Tolerating undeletable ...` line.
(`packages/ses`'s own test suite exercises `lockdown()`; also try a bare
`node -e "require('./packages/ses/dist/ses.cjs'); lockdown();"` or the
package's own repl/smoke-test entry point if one exists — use whatever the
package's own tooling provides rather than hand-rolling a harness.) Save the
raw log as an artifact in your job report — this is the ground truth the fix
must silence.

## Step 2 — adapt permits.js so the report goes silent

For each `Removing <path>` line: determine what the new intrinsic actually is
(spec-check it — don't blindly permit). If it is a legitimate, powerless
spec-defined property Node 26 added, add the correct permit entry (following
`permits.js`'s existing conventions: a typeof-name for primitives, an
intrinsic name, `'fn'`/`FunctionInstance` for a function, or explicit `false`
if it should be removed AND you want the diagnostic silenced going forward
because you've now audited and decided it's fine to remove quietly). For each
`Tolerating undeletable ...` line: confirm whether that's expected on Node 26
specifically (document why in a code comment near the relevant permit).

Iterate: re-run lockdown after each edit until the log is completely silent
(no `Removing`/`Tolerating` lines) on Node 26, AND confirm no regression on
whatever Node version(s) the package's CI currently tests (don't silence
Node 26 noise by accidentally breaking coverage for the versions already
audited).

## Step 3 — open the PR

Standard `pr-creation-flow`/`frozen-base-branch` conventions: base the change
on endojs/endo's real `master` (fetched fresh, not our `llm` branch), open
the review PR on our garden-side fork (`endo-but-for-bots`) so it runs
through the normal gauntlet (CI + panel). Do **NOT** push or open anything
directly against the real `endojs/endo` repository — that is a separate,
maintainer-authorized `ferry` step, out of scope for this job. PR body should
cite the captured Node 26 log (Step 1) as the evidence for each permit added,
and state explicitly that the goal is a silent lockdown report on Node 26
with no loss of audit rigor (i.e. no blanket/lazy permits — each new entry
should be justified).

Report in your completion: the full before/after lockdown log (noisy →
silent), the diff to permits.js with rationale per entry, and confirmation
existing tests (including any other Node majors in CI) still pass.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-15T22:55:48Z
