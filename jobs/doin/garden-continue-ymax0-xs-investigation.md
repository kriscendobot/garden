# continue the ymax0 v320 XS stack-overflow investigation (export-free, fork-authorized)

Map: **investigate** → continue the XS native-stack-depth investigation tracked on
kriskowal/garden#9, then report findings as a comment on that issue (issue-scoped
comms: comment on the thread, never the maintainer inbox).

## Authorization (new, supersedes the old scope rule)
kriskowal, on garden#9 (2026-06-28), revised the standing scope rule:
> "You are free to experiment with agoric/agoric-sdk using the kriscendobot/agoric-sdk
> fork and simply must avoid linking issues or pull requests to agoric/agoric-sdk or
> otherwise commenting upstream."
and "Agoric SDK is equally germane to the garden as Endo. Please continue this
investigation."

So: experiment freely on the **`kriscendobot/agoric-sdk` fork** (build, XS toolchain,
DRAFT PRs base+head on the fork, source reads). HARD LINE: never open/link an issue or
PR against **upstream `agoric/agoric-sdk`**, never comment upstream. Keep every artifact
fork-internal.

## Where the investigation stands (do not re-litigate; build on it)
- The crash is XS **value-stack WIDTH** exhaustion (`4096/4096 slots`), not deep
  recursion: two co-resident wide module-eval frames — the esbuild-flattened contract
  module functor (~2000 CLOSURE slots) + `@agoric/internal/src/hex.js`'s
  `decodings = new Map(encodings.flatMap(...))` (~1024 REFERENCE slots).
- The `flatMap`→loop patch on hex.js clears the stock-4096 overflow (proven decisive);
  it is carried as DRAFT, fork-internal, on `kriscendobot/agoric-sdk#7`.
- Two-worktree experiment (identical contract source, only Endo libs swapped): **beta3
  Endo libs overflow, beta2 pass** — isolates the *regression delta* to the beta3 Endo
  bump (pass-style 1.6.3→1.8.1 / marshal 1.8→1.10 / patterns 1.7→1.9.1), not the
  contract source (#12761).
- **NEW (verified this routing pass):** `@agoric/internal/src/hex.js` is **byte-identical**
  (blob `791b4d953bb5f5d957dd4490c3605e65e8a43cc8`) at its 2025-04-09 creation, at the
  ses-2.x sync `3952deecd4` (between the betas), at the #12761 tree `9d518832d4`, and at
  master. It did **not** change between beta2 and beta3. So hex.js is a *pre-existing*
  wide frame (a valid mitigation target, since shrinking it buys back slots), **not** the
  regression cause — confirming the maintainer's "red herring" suspicion at the
  root-cause level.

## What to do (export NOT required for any of this)
Re-provision the XS toolchain on-host (multi-hour; the prior built fork + bundle were
wiped by a redeploy) and pursue the remaining open question: **which specific beta3 Endo
change adds the ~128+ value-stack slots that tip the already-near-ceiling import over
4096?**
1. Rebuild the on-host instrumented `xsnap-worker` (the named-JS-frame + value-stack-kind
   trace from the methodology doc on `kriscendobot/agoric-sdk#6`).
2. Finer-grained bisection of the **real ymax0 import** against the Endo libs alone:
   hold the contract source constant, vary pass-style / marshal / patterns independently
   (not as a set) across the beta2↔beta3 boundary, and attribute the added width to a
   specific package/commit/function on the import/evaluate/harden/exo-registration path.
3. Report the attribution + whether an Endo-side width reduction is feasible *in addition
   to* the contract-side hex.js patch. The real-data swing-store trace still needs the
   v320 **export**, which only the maintainer can source — flag it as the one remaining
   blocked path; do not attempt to source chain data.

## Report
Post findings as a comment on kriskowal/garden#9. Keep all PRs/branches DRAFT and
fork-internal on `kriscendobot/agoric-sdk`. No upstream agoric/agoric-sdk links or
comments.

---
claim:
  host: endolinbot
  gardener: 60
  claimed_at: 2026-06-28T06:35:37Z
