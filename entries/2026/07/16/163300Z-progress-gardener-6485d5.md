---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-16T16:33:02Z
---
# SturdyRef press tick (2026-07-16T16:20 dispatch, job endo-sturdyref-press-20260716-162017)

**Headline: PRESSED. The maintainer re-engaged 07-14/15 (the 07-13 stall is
over); this tick landed the explicitly-directed `sturdyRef` spelling rename on
the live single-review PR #737 and re-surfaced the gated prefix decision
there.**

## Landscape shift since the 07-13 ticks (verified via gh, 16:21–16:30Z)

- **#521 CLOSED** (2026-07-15) per kriskowal's directive *"close, collapse the
  stack, and propose a single review"* → replaced by **#737**
  (`build/sturdyref-pass-style-ocapn-single`, single squashed commit, opened
  under kriscendobot so kriskowal can review; was byte-identical to #521 head).
  CI was 26/26 green before this tick's push. **No kriskowal review on #737 yet.**
- **#695** (agent provide/accept design): kriskowal CHANGES_REQUESTED 07-15
  05:00Z; addressed at `f5df0a4c83` 05:07Z (token → first-class SturdyRef
  pass-style value throughout). **Awaiting re-review.**
- **#697** (cross-peer bridge design): kriskowal CHANGES_REQUESTED 07-15
  05:37Z (six inline answers — swiss-num = formula identifier, node-key =
  OCapN identity, etc.); folded in at `e4a0a614b816` 05:43Z. **Awaiting re-review.**
- **#541 + bridge cuts #698–#704**: still stacked on closed #521's old branch
  `build/sturdyrefs-pass-style-ocapn`; will need restack onto #737's branch or
  fold-in, pending the maintainer's holistic-review preference.

## What this tick did

- Renamed the pass-style discriminator `'sturdyref'` → `'sturdyRef'` per
  kriskowal's inline review (#521 discussion_r3582807958, a direct instruction,
  not gated): pushed **`ce7341b47d`** to `build/sturdyref-pass-style-ocapn-single`
  (#737). 10 files, +32/−32: PassStyle union, helper styleName + shape checks,
  ocapn mint + codec-table key, tests. Wire vocabulary (`ocapn-sturdyref` Syrup
  label, `OcapnSturdyRefCodec`, `ocapn://` URI kind, `SturdyRef` toStringTag)
  deliberately untouched.
- **Real-execution evidence:** `yarn test` → pass-style 68 passed, marshal 82
  passed (1 skipped), ocapn 534 passed; `yarn lint` (tsc && eslint) → 0 errors
  in all three packages. (Install needed TMPDIR off noexec /tmp for
  better-sqlite3.)
- Commented on #737 (issuecomment-4994276944) with the rename evidence and
  re-surfaced the two decisions buried in closed #521's thread: the marshal
  rank-prefix pick (options A/`q` recommended, B/`t`, C/`w`) and the
  stack-collapse preference.

## Confinement statement

This tick's change is a spelling rename of the pass-style discriminator —
no confinement surface changed. Standing invariants preserved as-is: the
secret (swiss-num) is never a property on a SturdyRef instance (pass-style
shape tests re-run green, including the forged/decoy rejections); the raw
locator remains off-band in the ocapn session manager's closely-held map.
Token unlinkability (no-identification) remains pending the #695-gated
provide/accept build.

## Guidance for the next tick

- Watch for: kriskowal's first review on #737, re-reviews on #695/#697, and
  his prefix pick + stack-collapse answer (now visible on #737).
- On the prefix pick: implement encode/decode arms + `encodeSturdyRef`/
  `decodeSturdyRef` hooks in marshal on #737's branch (the "follow-through"),
  minding the encoded-identity question (encode a host-supplied ordinal,
  never the secret).
- On a stack-collapse "yes": fold #541 + #698–#704 into #737 for holistic
  review; otherwise restack them onto `build/sturdyref-pass-style-ocapn-single`.
- CI on #737 will re-run on `ce7341b47d`; if a check goes red the pr737
  shepherd lane exists (jobs/tada/endojs-endo-but-for-bots-pr737-shepherd.md).
- No stall: maintainer active as of 07-15; do not escalate.
