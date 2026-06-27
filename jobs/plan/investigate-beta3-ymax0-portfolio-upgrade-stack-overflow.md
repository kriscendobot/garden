---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-06-27T15:29:39Z
---

# Investigation brief: beta3 portfolio-contract upgrade crashes with "stack overflow"

> SCOPE / GATE: This targets **agoric-sdk** (off-limits for autonomous garden work)
> and its artifacts live on the maintainer's machine (`/Users/kris/...`), not the bot
> host. It is **go-ahead gated**: NEVER auto-promoted, run only on explicit maintainer
> authorization, by the maintainer or a maintainer-supervised session. Not bot-fleet work.

**Goal:** Find the exact recursive code path that overflows the XS native stack during
the portfolio (ymax0) contract vat upgrade, identify the root-cause change, and
propose/implement a fix.

## Environment / artifacts
- Repo `/Users/kris/agoric-sdk` (detached HEAD at tag `ymax-v0.3.2606-beta3`, commit `9d518832d4`).
- `beta2.js` (working bundle, ~35,131 lines) and `beta3.js` (crashing bundle, ~35,447 lines)
  — minified Endo/SES bundles; raw diff is ~99% noise, so **diff string literals only**.
- Crash log `/Users/kris/Downloads/Logs-2026-06-26 13_58_58 (1).json` — 152 swingset slog
  entries; flattened dotted keys; **use jq**.

## Established (high confidence)
1. **Crash:** vat v320 (`zcf-…-ymax0`, the portfolio contract) upgrade-vat incarnation
   70→71, `bringOutYourDead → startVat`, fails with `exited: stack overflow` during
   durable-exo rehydration (last syscalls: `vom.dkind.15/16/17` rehydration → `getBundle`).
2. **Mechanism:** native stack overflow = unbounded/too-deep recursion — NOT the
   `*_OWN_STACK_ACCESSOR` assertion throws (those exist at `beta3.js:5330/5957` but are not
   the failure).
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
1. Locate the ymax0/portfolio contract source (`packages/portfolio-contract`, plus
   `orchestration/async-flow`); map its durable kinds and interface guards rehydrated at `startVat`.
2. Reproduce under XS via `packages/xsnap`/swingset harness, driving the vat upgrade with the
   beta3 deps; capture the repeating frame cycle in the XS stack dump (names the recursive
   function). Confirm it does NOT overflow on Node or with beta2 (SES 1.14) deps.
3. If inconclusive, bisect the Endo bump — pin `pass-style`/`patterns`/`marshal`/`exo`/`ses`
   back toward beta2 versions until it stops overflowing.
4. Inspect the suspect function's SES-1.14 vs 2.2 source against the contract's data shape
   (depth grew? base case removed? cycle no longer broken?).
5. Fix: correct the Endo recursion (or pin/patch the package), or flatten/break the cycle in
   the contract's guard/durable schema; raising the XS stack limit is a last-resort mitigation
   only. Re-verify the upgrade repro + portfolio test suite.

## Deliverable
Root-cause writeup naming (a) the exact recursive function and the data driving its
depth/cycle, (b) why SES 2.x regressed it vs 1.14, (c) a verified fix (PR-ready diff or
upstream-Endo bug report with minimal repro), with the XS upgrade repro confirmed passing.

## Confirm commands (regression window / string-diff / crash line)
The maintainer's brief notes ready-to-run `git`/`jq`/`comm` commands accompany this plan
(confirm `3952deecd4` is post-beta2 + ancestor-of-beta3; extract the string-literal-only diff
between `beta2.js`/`beta3.js`; pull the stack-overflow crash line from the slog JSON). Paste
the exact command block here when promoting, e.g.:
- regression window: `git merge-base --is-ancestor 3952deecd4 9d518832d4 && git tag --contains 3952deecd4`
- string-level diff: extract quoted literals from each bundle, sort, `comm -3` the two sets.
- crash line: `jq` the slog for the entry whose `*.exited`/`*.deliveryResult` mentions
  "stack overflow" around the v320 startVat delivery.
(Replace with the maintainer's verbatim commands on promotion.)
