Completion report posted to the issue. Summary:

## What I did
Picked up issue-kriskowal-garden-9 (maintainer asked to recap the ymax0 v320 stack-overflow findings and continue **without** the v320 swing-store export). I consolidated the two prior journal investigations and then advanced the analysis by re-walking the full slog at syscall granularity.

## Key result (a genuine advance, not just a recap)
The decisive new finding: **the overflow is at contract-bundle import, not at durable-data unserialization.** The `startVat` crank rehydrates durable kinds 10→17 cleanly, then dies on `invoke kd513 getBundle` with `Stack meter exceeded` — and there are **zero vatstore reads of any async-flow LogStore/bijection/accumulated durable data before the crash.** That:
- reconciles the two prior reports (the first located it in the SES-2.x import/link/membrane path; the second mis-attributed it to accumulated durable data, which the slog rules out as the trigger);
- means the **v320 export is most likely NOT the blocker** — the deep work is determined by the contract bundle (in hand), Endo/SES, and the zcf import path under XS;
- reopens the Endo attribution for the import path (the prior bisection only tested the unserialization recursions, not module-link/evaluate/harden, which SES 2.x did change).

I also confirmed the prebuilt **XS v0.14.2 engine is already cached on the host and executes**, so the recommended export-free repro (drive `importBundle(bundle-ymax0.json)` through the zcf/xsnap supervisor on XS) needs no native rebuild.

## What changed
Nothing in any repo — read-only analysis of slog + bundle artifacts already on host; no agoric-sdk pushes/PRs/merges (scope-respecting). Posted findings as a comment on the issue (left open for the submitter to close).

## Follow-ups for the maintainer
1. Run the export-free XS import repro (decisive, cheap, engine already warm).
2. Only if that import *passes* cleanly does the swing-store export become necessary again.

No peer/maintainer messages required; inbox was just the echoed "recap findings" comment, already folded in.
