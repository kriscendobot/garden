# Investigation: beta3 portfolio-contract (ymax0) upgrade crashes with "stack overflow"

> SCOPE: Authorized fleet work on **OUR FORK** `kriscendobot/agoric-sdk` ONLY. No
> interaction with upstream `Agoric/agoric-sdk` — no PRs to, pushes to, or merges
> with upstream. All work, branches, and any fix land on the bot fork. (The off-limits
> rule is upstream agoric-sdk; the bot-owned fork is in scope, maintainer-authorized
> 2026-06-27.)

**Goal:** Find the exact recursive code path that overflows the XS native stack during
the portfolio (ymax0) contract vat upgrade, identify the root-cause change, and
propose/implement a fix — on the fork.

## Environment / artifacts
- **Repo:** `kriscendobot/agoric-sdk` (our fork). Check out commit `9d518832d4`
  (tag `ymax-v0.3.2606-beta3`) — confirmed present on the fork ("Open with
  Auto-Features (#12761)"). Work from a branch off that commit on the fork; do not
  touch upstream.
- **Bundles:** `beta2.js` (working, ~35,131 lines, 1,129,924 B) and `beta3.js`
  (crashing, ~35,447 lines, 1,139,323 B) — minified Endo/SES bundles; raw diff is
  ~99% noise, so **diff string literals only**. Available in the maintainer's gist:
  - gist: https://gist.github.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212
  - beta2.js raw: https://gist.githubusercontent.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212/raw/ef847278f5a87bb62a7cf50cc77e7fa3878858a4/beta2.js
  - beta3.js raw: https://gist.githubusercontent.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212/raw/79a341122452f138ce9e06cfe0b1110db099a344/beta3.js
- **Crash log (slog):** the raw 152-entry swingset slog JSON (flattened dotted keys;
  use `jq`) is now in the gist as `gistfile1.txt` (428,083 B):
  - raw: https://gist.githubusercontent.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212/raw/73cbba56249536e52b2818913694acdf516478f7/gistfile1.txt
  Use it to read the exact syscall order around the failing v320 `startVat` delivery
  (the `vom.dkind.15/16/17` rehydration → `getBundle` sequence) and to confirm the
  `exited: stack overflow`. The distilled facts in "Established" below are the summary.

## Established (high confidence)
1. **Crash:** vat v320 (`zcf-…-ymax0`, the portfolio contract) upgrade-vat incarnation
   70→71, `bringOutYourDead → startVat`, fails with `exited: stack overflow` during
   durable-exo rehydration (last syscalls: `vom.dkind.15/16/17` rehydration → `getBundle`).
2. **Mechanism:** native stack overflow = unbounded/too-deep recursion — NOT the
   `*_OWN_STACK_ACCESSOR` assertion throws (those exist at `beta3.js:5330/5957` but are
   not the failure).
3. **Prime mover:** commit `3952deecd4` "sync Endo to latest including ses 2.x" — bumps
   `ses ^1.14.0 → ^2.2.0` + all `@endo/*`; lands after beta2, ancestor of beta3; the only
   runtime/hardening change between the bundles.
4. **Why env-dependent:** chain runs on XS (shallow native stack); tests run on Node/V8
   (deep). SES 2.x adds call depth (or a cyclic/deeper traversal), overflowing XS but not
   Node — so it passed review.

## Open question
Which function recurses without bound (or too deeply) during `startVat` exo rehydration,
and why does SES-2.x do so when SES-1.14 did not? **Leading candidates:**
1. `@endo/pass-style` `passStyleOf` / `@endo/patterns` matcher over the contract's interface guards;
2. SES 2.x `harden` over a deep/cyclic durable graph;
3. a true cycle from the Endo bump (rule out by reproducing on Node first).

## Plan
1. On the fork, locate the ymax0/portfolio contract source (`packages/portfolio-contract`,
   plus `orchestration/async-flow`); map its durable kinds and interface guards rehydrated
   at `startVat`.
2. Reproduce under XS via `packages/xsnap`/swingset harness, driving the vat upgrade with the
   beta3 deps; capture the repeating frame cycle in the XS stack dump (names the recursive
   function). Confirm it does NOT overflow on Node or with beta2 (SES 1.14) deps.
3. If inconclusive, bisect the Endo bump — pin `pass-style`/`patterns`/`marshal`/`exo`/`ses`
   back toward beta2 versions until it stops overflowing.
4. Inspect the suspect function's SES-1.14 vs 2.2 source against the contract's data shape
   (depth grew? base case removed? cycle no longer broken?).
5. Fix (ON THE FORK): correct the Endo recursion (or pin/patch the package), or flatten/break
   the cycle in the contract's guard/durable schema; raising the XS stack limit is a
   last-resort mitigation only. Re-verify the upgrade repro + portfolio test suite. Any fix
   lands on `kriscendobot/agoric-sdk`; an upstream-Endo bug report (with minimal repro) is a
   deliverable, NOT an upstream push.

## Deliverable
Root-cause writeup naming (a) the exact recursive function and the data driving its
depth/cycle, (b) why SES 2.x regressed it vs 1.14, (c) a verified fix (PR-ready diff ON THE
FORK, or an upstream-Endo bug report with minimal repro), with the XS upgrade repro confirmed
passing.

## Confirm commands (regression window / string-diff / crash facts)
Derive the exact forms on the fork; sketches:
- regression window: `git merge-base --is-ancestor 3952deecd4 9d518832d4 && git tag --contains 3952deecd4`
- string-level diff: extract quoted literals from each bundle (gist raw), sort, `comm -3` the two sets.
- crash facts: `jq` the slog (gistfile1.txt) for the v320 `startVat` delivery and the
  `exited`/stack-overflow entry; cross-check against the "Established" section.

Provenance: re-parked from plan/ and adjusted to fork-scope + gist artifacts by liaison
(maintainer-authorized 2026-06-27).

---
claim:
  host: endolinbot
  gardener: 63
  claimed_at: 2026-06-27T16:01:07Z
