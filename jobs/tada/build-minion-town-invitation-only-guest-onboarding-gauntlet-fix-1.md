CI is genuinely GREEN against the new head `81b5ae9` (fresh run 33641803246, not the stale check). The fix round is complete.

## Completion report

**Job:** FIX round 1 for kriscendobot/minion.town PR #81 (invitation-only guest onboarding browser core). Applied the jury panel's request-changes items once, pushed as a follow-up commit, watched CI to green.

**What I did** — got an isolated project checkout of the PR head, read the 20-seat panel verdict (disposition: must-fix), and applied the high-consensus must-fix items in one commit (`81b5ae9`):

Security/correctness:
- **Credential displacement / session fixation** (top item — locksmith, warden, wire-watcher, purist): `selectStartupCredential` now surfaces the displaced identifier as `replacedGuest` when an explicit guest fragment overrides a *different* valid stored guest, so the swap is observable instead of a silent, unrecoverable destruction.
- **Unreachable `malformed-fragment` branch** (6 seats): deleted — `new URLSearchParams(<string>)` never throws.
- **Label trust-prompt spoofing** (warden): `readLabel` now rejects control/bidi code points.
- **URL path-math** (purist, corner-prober): `buildInvitationUrl`/`buildGuestUrl` reduce the origin via `new URL(origin).origin`, making the documented `search===""`/`pathname==="/"` invariant true and throwing on a non-origin.
- **Best-effort Web Storage** (engine-realist, corner-prober): `safeGet/Set/Remove` degrade a blocked/quota store instead of aborting startup.

Cleanups: rename `forgetBrowser`→`forgetGuest` (duality-auditor); delete dead `buildGuestFragment` re-export (surfacer, pruner); remove redundant `guest as string` cast and dead switch `default`; guard `parseFormulaIdentifier` at the type boundary (spec-keeper); export `MAX_LABEL_LENGTH` (surfacer).

Tests: the fake `BrowserEnv` now re-serializes `replaceState` through the URL parser (spec-keeper); added displacement, best-effort-storage, bidi/newline-label, label-bound, and origin-validation coverage. **44 web tests; full suite 343 passed / 5 skipped; `tsc --noEmit` clean.**

Docs: corrected the stale "34 tests" count → 44; de-linked the not-yet-landed `guest-primer.md` (draft PR #78) in both docs to avoid dead links on merge; made the lessons recipe use a resolvable relative specifier; added a `src/web/` line to README.

**Result:** pushed `0092d49..81b5ae9` via `safe-push-pr-head.sh` (advance mode); CI `test` check COMPLETED/SUCCESS against head `81b5ae9` (rc 0, GREEN).

**Follow-ups not taken (out of scope for a one-shot fix round):** `harden()`-ing returned records (contested — purist raised it, but warden/locksmith noted the module is deliberately SES-free here); routing the lessons annex into the guest primer via a #78 comment/absorption job (scribe); naming the browser bundler/entry-point seam (integrator). These are should-fix/follow-up, not blocking; the panel-2 stage can re-raise any that remain.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-only-guest-onboarding-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 137 tokens (7762227 cached reads)
- Output: 37638 tokens
- Cost: $6.103978499999999
- Wall-clock: 625s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
