Job routed and posted successfully. Completion report:

---

# Completion report — `kriskowal-garden-pr9-b87e3247` (attention → route directive)

## What the directive was
Re-fetched the source comment (kriskowal on kriskowal/garden issue #9, treated as untrusted data): *"Please also post a job to capture the debug instrumentation improvements to xsnap in forks of the relevant repositories."* This is a maintainer directive to **post a job**, not to do the capture inline — so my attention-router job was to translate it into a well-formed board job.

## Context I resolved
Traced the directive to the `investigate-beta3-ymax0-xs-repro-and-fix` investigation (its `tada` report and the referenced maintainer-inbox entry `20260627T164806Z-1db40f.md`). The "debug instrumentation improvements to xsnap" are the diagnostic artifacts that investigation produced: the XS/V8 stack-depth probes (run inside a real `xsnap` worker to measure the ~350-frame XS budget and derive `passStyleOf`/`marshal`/`mustMatch` level limits), the beta2-vs-beta3 Endo bisection probe, and the xsnap build workaround for this host (bypass yarn's build runner, run `prebuild-install`/prebuilt `xsnap-worker` directly). They currently exist only as untracked scratch on `endolinbot`.

## What I did
Posted job **`capture-xsnap-debug-instrumentation-in-forks`** to the board (`post-job.sh`, landed and pushed to `origin/journal2`; already claimed into `doin/` by a gardener). The body:
- Names the artifacts and their on-host paths, with fallback to reconstruct from the investigation report if scratch is GC'd.
- Sets the deliverable: a preservation branch on the **bot-owned fork** `kriscendobot/agoric-sdk` (probes + build-workaround README), no PR, plus a `result` entry indexing what was captured.
- Carries **hard scope guardrails**: bot-owned forks only; **no upstream push/PR/comment/cross-reference** against `Agoric/agoric-sdk` or `endojs/endo`; re-enabling push only to the bot's own fork. This honors both the maintainer authorization and the standing "agoric-sdk upstream is off-limits" scope rule.

Verified the job landed (fetch-only, read-only — no pull of the live journal worktree) and cleaned up the scratch body file.

## Follow-ups
- The capture work itself proceeds under the new job (already in `doin/`); nothing left for me.
- A separate, still-open thread on issue #9 — the issue body's *"continue this investigation to the possible extent without the export"* — is **not** part of this comment's directive and was out of scope here; if it isn't already tracked, it's a candidate for its own job.

Self-improvement: nothing this time. The one judgment call (a bot-owned fork of agoric-sdk is in-scope "bot fork," while upstream agoric-sdk stays excluded) is already covered by the existing scope memory; I encoded it as explicit guardrails in the job body rather than as a rule change.
