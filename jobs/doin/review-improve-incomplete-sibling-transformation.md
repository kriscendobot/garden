---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# review-improve: incomplete-sibling-transformation

You are closing a review-miss cluster surfaced by the review-retrospective loop
(skill `skills/review-retrospective/SKILL.md`). Deliver the **two-part contract in
full** — prevention AND durable review-cycle sensing — then close the cluster.
A completion that delivers only one half is incomplete.

## The cluster

- File: `review-misses/clusters/incomplete-sibling-transformation.md` (on `journal2`;
  read it for the canonical members/prs/status).
- Category: `correctness-bug`. Count 4, across PRs **#475** and **#1099**.
- Pattern (verbatim): "A commit that generalizes an operation across a family of
  sibling call sites (read-only byte ops, twin packages, a shared helper shape)
  converts some sites but silently skips others; no panel lens enumerates every
  sibling of the generalized operation and verifies each was converted, so a
  skipped sibling carrying a live latent bug reaches the maintainer."
- Members (read each record under `review-misses/misses/`):
  - `endojs-endo-but-for-bots-pr475-9885f3d8` (#475)
  - `endojs-endo-but-for-bots-pr475-review-69a8dffc` (#475)
  - `endojs-endo-but-for-bots-pr475-review-f66ed689` (#475) — DataView vs
    TypedArray emulation constructors both maintaining the reverse buffer-map
    invariant; fix `4dbe5ffff` "pair buffer maps at creation".
  - `endojs-endo-but-for-bots-pr1099-review-6694e2d7` (#1099) — TWO instances in
    one review: (1) `packages/hex/src/encode.js` gated the native `toHex` path on
    `bytes.buffer.immutable !== true` while its committed-correct sibling
    `packages/base64/src/encode.js` dispatches on `ArrayBuffer.isView(bytes)`
    (issue #573); fix `331dfdfae2`. (2) `packages/harden/make-hardener.js` was
    refactored to call `isMutableTypedArray` but its sibling
    `ses/src/make-hardener.js` still gated `freezeTypedArray` on `isTypedArray`;
    surfaced by the maintainer's "scan this PR for this kind of inconsistency."

## (a) Prevention — narrowest artifact governing the producing work

The producing role is `builder` (and `fixer` when it authors a family-wide
change). Add a standing norm at the doer: when a change **generalizes an operation
across a family of sibling call sites** — twin packages (`hex`/`base64`),
duplicated helper copies (`harden/make-hardener.js` vs `ses/src/make-hardener.js`),
parallel constructors (DataView vs TypedArray emulation), or any N sites that
jointly maintain one invariant or share one dispatch shape — **enumerate every
sibling of the operation and verify each was converted**, before pushing. Name the
concrete sibling families observed here as worked examples. Prefer the narrowest
artifact: `roles/builder/AGENT.md` + `roles/fixer/AGENT.md` operating norms, and/or
a skill (consider whether this belongs alongside the existing
`incomplete-rename-old-name-sweep` discipline, or as its own short skill the two
roles reference). Where any part is mechanically detectable at authoring time,
prefer a pre-push gate over an instruction (mentor's move-judgment-into-scripts
bias).

## (b) Sensing — a durable review-cycle check

The pattern's defining gap is that **no gauntlet seat enumerates the sibling family
of a generalized operation**. Add sensing in descending order of preference
(`skills/review-retrospective/SKILL.md` § 5):

1. A deterministic pre-push gate / panel-stage script check where mechanizable —
   e.g. a probe that, when a diff edits one member of a **known sibling family**
   (seed with `packages/hex/**` vs `packages/base64/**`; `packages/harden/make-hardener.js`
   vs `packages/ses/src/make-hardener.js`; the immutable-arraybuffer sibling
   constructors) but not its twin, fails/flags for a sibling-consistency check.
   Err toward firing — a loose probe is acceptable, a missed fire is not.
2. Otherwise, amend the seat named in `missed_by` (the byteArray/passable
   correctness lens — `breaker`/`prover`/`corner-prober`, or the `transplanter`
   seat whose lens is parallel/ported structure) in
   `roles/jurors/<seat>/AGENT.md` with an explicit **sibling-enumeration finding**
   ("for a change that generalizes an operation across a family of sites, list all
   N siblings and verify each was converted"), plus a `panel-hints` probe under
   `skills/panel-hints/probes/` firing that seat on the diff signal (probe and seat
   change in the SAME commit, per the panel-hints "Adding a probe" convention).

## Verification — the re-litigation test (mandatory, per member)

For each of the four members, name the exact new check (gate, or probe + seat
line) that would now catch it, and demonstrate the probe/gate fires on the real
historical diff where the miss occurred. Pull historical content from the
`endojs-endo-but-for-bots.git` bare clone (e.g. #1099 head `feat/narrow-bytearray-master`,
fix commits `331dfdfae2`/`c88c7e0f91`; #475 fix `4dbe5ffff`). Show the controls
abstain (the already-consistent siblings do not fire).

## Close

When both halves are delivered and verified:

    scripts/jobs/review-miss-record.sh cluster-status incomplete-sibling-transformation closed \
      --improved-by "<commits/files changed>"

Report the prevention edit, the sensing check, the per-member re-litigation
results, and the close.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T10:11:47Z
