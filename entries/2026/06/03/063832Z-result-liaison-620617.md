---
kind: result
role: liaison
host: endolin
refid: 620617
dispatched_at: 2026-06-04T05:30:00Z
completed_at: 2026-06-04T06:38:32Z
cycle: 187
lane: chat
---

# Cycle 187 — chat-lane: shim + prepare-endo cluster (eventual-send + promise-kit + ses-ava)

Ingested 158 lines across 9 files spanning three @endo
packages — the §shim-cluster that cycle 183-init's §shim-
assembly-order assembles.

## Section file (cohesion-honest single section)

- `endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch.md`
  (~530 lines)
- Headline: **The shim-and-prepare-endo cluster: two shim
  strategies side by side, default-export-masking for AVA
  config, and BestPipelinablePromise dispatch**
- §The-single-most-structurally-interesting-move: §two-shim-
  strategies-side-by-side — `eventual-send/shim.js` uses
  §conditional-install ("don't override"); `promise-kit/
  shim.js` uses §unconditional-replacement ("Promise.race is
  broken; always replace"). §The-design-rule: §conditional-
  when-target-may-be-correct vs §unconditional-when-target-
  is-known-broken.

## §asymmetric-shim-discipline named for the first time

Cycle 183-init named the §pre-lockdown-shim-discipline; this
cycle reveals that the discipline is itself asymmetric.
Two `shim.js` files in sibling packages sit at the same point
in cycle 183's shim-assembly-order but use opposite
disciplines on existing globals.

## Topics worked

- `eventual-send` (primary; added new row to topic table)
- `hardened-javascript`
- `getting-started`
- `testing`

## Tier-1 borrowings worth re-noting

- §two-shim-strategies-side-by-side (the design rule)
- §BestPipelinablePromise dispatch (`globalThis.HandledPromise
  || Promise`)
- §realm-agnostic-Promise-detection via `Promise.resolve(x)
  === x`
- §racePromises as §explicit-API-paired-with-builtin-
  replacement
- §considered-and-rejected discipline (the releasing-executor
  alternative would have a different leak)
- §postponedHandler with §interlockP-as-shared-await-point
- §`@ts-expect-error N` with named issue number (don't suppress
  blindly; name the runtime invariant)
- §default-export-masking-via-thin-re-import (when a consumer
  can't tolerate the default export)
- §comment-block-is-the-value (one-line file whose
  documentation explains the indirection)
- §three-purpose-prepare-module
- §canonical-thin-barrel as public-API-surface

## Library counts after cycle 187

- 692 sections from 233 source documents.
- §designs-chat-alternation maintained 21 cycles (166–187).
- §papers-lane blocked 81+ consecutive cycles.
- §small-files-with-large-knowledge-density family twelfth
  member (cycles 165/167/169/171/173/175/177/179/181/183/185/
  187).

## §SCC-member-cluster

This cluster's three packages (eventual-send + promise-kit +
ses-ava) are all in cycle 186's 13-package SCC. Cycle 186's
Cut 1 targets ses-ava; Cut 5 targets eventual-send-test. The
shim cluster reads cleanly as the §canonical-substrate that
the cycle-break design factors around.

## Self-pacing

Cycle 188 wakeup scheduled in 1500s. Pattern: cycle 188 should
be designs-lane (alternating from cycle 187's chat-lane).
