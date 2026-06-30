---
gate: go-ahead
priority: normal
posted_by: gardener
posted_at: 2026-06-30T01:59:25Z
---

# PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibility on real chain state via inquisitor

Map: **build/verify** → gardener supervising `skills/agoric-chain-snapshot`. Gated on a real
mainnet swing-store being captured first (`scripts/agoric/fetch-polkachu-snapshot.sh`). Promote
with the snapshot in hand: "go ahead on verify-ymax0-hex-fix-inquisitor".

Source: kriskowal directive on kriskowal/garden#9
(https://github.com/kriskowal/garden/issues/9#issuecomment-4839140138), question 8:
"Can we verify your answer to this last question by running another round of validation with the
snapshot and the Inquisitor tool?" The accounting reply is
https://github.com/kriskowal/garden/issues/9#issuecomment-4839184870.

## Why parked
The verification needs a real Agoric mainnet swing-store, which is tens of GiB and not yet
captured on this host (the maintainer framed the directive as "while we wait for a snapshot").
Do not promote until `$GARDEN_SNAPSHOT_CACHE/agoric-<height>/swingstore.sqlite` exists (check the
`provenance.json` sidecar) or a peer host holds one to socialize via `--from-host`.

## What the round must confirm (on real chain state, bot forks only)
Follow `skills/agoric-chain-snapshot/SKILL.md`. Against the captured swing-store, through
`packages/cosmic-swingset/tools/inquisitor.mjs` on a `kriscendobot/agoric-sdk` worktree:

1. **Control**: the stock v320 `bundle-ymax0` upgrade core-eval aborts with the XS value-stack
   overflow (`exited: stack overflow`).
2. **Hex fix**: the `flatMap` -> loop `@agoric/internal/src/hex.js` (bot fork PR #7 /
   `debug/xs-stack-overflow-methodology`) upgrade installs and completes at the stock
   `stackCount = 4096`.
3. **Snapshot compatibility (the new claim to verify)**: a taller-`stackCount` worker loads the
   real pre-upgrade snapshots WITHOUT a signature/version break (the read path gates only on
   `XS_MAJOR/MINOR_VERSION`, `sizeof(txSlot)`, and the fixed `"xsnap 1"` signature; `stackCount`
   is per-snapshot CREA-atom data, `fxAllocate`d from the snapshot, not the binary). AND confirm
   the v320 upgrade runs on a FRESH machine (so it actually picks up a taller binary's stack),
   not a snapshot-restored one (which would keep the snapshot's 4096).

## Scope
Read-only analysis plus on-host runs of the open-source XS worker, the public bundle, and the
captured swing-store, on bot-owned forks only. No upstream `agoric/agoric-sdk` interaction
(no comments, reviews, cross-references, or issue/PR opens/closes). Report findings as a comment
on kriskowal/garden#9.
