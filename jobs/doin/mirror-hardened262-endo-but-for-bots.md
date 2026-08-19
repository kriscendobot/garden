---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Mirror hardened262 from upstream endo into endo-but-for-bots

Repository: endojs/endo-but-for-bots, branch `llm`.

## Source (read-only reference — do not comment on, link to, or act on the
## upstream PR; borrow the code content only, same as its own commits borrow
## test262 cases from Moddable)

https://github.com/endojs/endo/pull/2593 — "feat(hardened262): Preliminary
harness" (kriskowal, OPEN, unmerged), on branch `kriskowal-xs-native` of
`endojs/endo` (reachable in the garden's bare clone via the `endo-upstream`/
`kc-endo`/`upstream` remotes — already fetched).

PR description: "Introduces a harness for test262 style tests for Hardened
JavaScript, toward verifying parity between SES and SES specialized for
native Hardened JavaScript on XS... generate a cross product of tests with
more dimensions... agent: SES on Node.js, SES on XS, SES on XS specialized
with `-C xs`, bare XS." Refs endojs/endo#400, endojs/endo#2259.

## Why we need it (two consumers, name both in the design/report)

1. **Ironhorse.** `designs/ironhorse-engine.md` § test262 conformance already
   anticipates a convergence: the existing `packages/test262-runner` (which
   today proves XS↔Node HardenedJS parity via `ses-xs-parity`-tagged tests
   run against `xst` and `node` hosts) is meant to grow into an
   `ironhorse-xst` runner with Ironhorse as a third host alongside `xst` and
   `node` — see `designs/ironhorse-test262-convergence.md`, which already
   exists on `llm`. Read both before writing any code; hardened262's
   cross-product-of-agents harness shape may largely BE (or directly inform)
   that planned convergence, not a separate thing to bolt on beside it.
2. **Byte-array validation.** PR #475's review cycle has been finding
   genuine-vs-emulated-Uint8Array parity bugs by hand (`bytesEqual`,
   `base64` `encode.js`, `ocapn` `diagnosticEquals` — see the silent-merge-
   drop audit on that PR) — exactly the class of bug a
   Node/XS/XS-native-SES cross-product harness is built to catch
   systematically. Once mirrored, this harness should be usable to sweep
   `@endo/bytes`, `@endo/base64`, `@endo/hex`, `@endo/immutable-arraybuffer`
   for the same bug class, not just serve as a one-off validation.

## What's actually in the source stack — read the whole thing, it's not isolated

The hardened262-specific commits (`chore(hardened262): Scaffold` through
`test(hardened262): Borrow test262 cases from Moddable at a9e80d0c1`, plus
later `mark failing`/`WIP` fixups) sit **on top of, and depend on**, a chain
of other XS-native SES/module-source infrastructure commits on the same
branch (`feat(ses): Anticipate a ModuleSource shared intrinsic`,
`feat(module-source): Introduce a shim that composes with lockdown`,
`feat(ses): Expose console shim`, `feat(ses): Add XS variant of shim`,
`feat(module-source): Specialize for XS native ModuleSource`,
`feat(compartment-mapper): All parsers on request`,
`refactor(import-bundle): Couple to archive parsers package exports`) — the
harness testing "SES on XS" as an agent needs XS-native SES support to
exist in the first place. Determine how much of this underlying chain
`llm` already has (some may already be superseded by Ironhorse/endor work
landed independently) versus what genuinely needs mirroring alongside the
harness itself. Do not mirror the harness commits alone and discover at
test time that its "SES on XS" agent has nothing to run against.

## What to do

Mirror (port, adapting package naming/layout to this repo's conventions —
check the source's own `package.json`/directory name on the upstream branch
rather than assuming `packages/hardened262`) the harness and its test262
borrow, reconciled against the two existing pieces of infra named above
rather than landed as a disconnected third thing. Land as a normal PR
against `llm` (this repo's usual flow).

**If reconciling hardened262's harness against `test262-runner` and the
`ironhorse-test262-convergence` design turns out to be a genuine
architectural judgment call (not just mechanical porting) — stop and say so
explicitly rather than forcing a decision; that's designer-shaped work, and
this job should hand off to a `design` job naming exactly the fork in the
road, rather than guess.**

## Deliverable

A PR (or, if you hand off per the paragraph above, a completion report
naming the fork and recommending the design job) — either way, close the
loop on how this harness relates to the two existing consumers named above,
not just that the code compiles.

`handler-timeout: 10800` — this is a large, interleaved commit stack across
two upstream repos' worth of history to reconcile; budget accordingly.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-19T05:30:36Z
