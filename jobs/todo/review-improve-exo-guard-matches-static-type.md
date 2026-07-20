---
role: builder
---

# review-improve: exo interface guards must match their known static type

Prosecutor (review-retrospective second loop) dispatch. The review-process miss
cluster `exo-guard-matches-static-type` has crossed the dispatch threshold under
the severity bypass: **three `severity: major` misses**, all on
kriscendobot/agoric-sdk PR #15, each grounded in the repo's standing, documented
`CONTRIBUTING` § TypedPatterns convention that already existed and did not bind.

You are a **builder**. Read `skills/review-retrospective/SKILL.md` § Improve for
the two-part contract you must satisfy, and `skills/panel-hints/SKILL.md`
("Adding a probe": probe and seat change land in the SAME commit). This is a
GARDEN (main2) change — roles/skills/scripts/probes — not a project-repo change.

## The pattern (from the cluster)

Cluster file: `journal2:review-misses/clusters/exo-guard-matches-static-type.md`
(read it on the journal2 branch; it is journal state, not on main2).

Pattern: An exo interface-guard PR reaches the maintainer with loose
`M.any()`/`M.record()`/`M.string()` guards (argument OR return position) on
methods whose static type is precisely known, contrary to agoric-sdk's
`CONTRIBUTING` § TypedPatterns convention (guards are the runtime enforcement,
static types are advisory; each guard should match its static type as tightly as
possible, and any remaining looseness be a deliberately-designed, documented
exception). A full 16-seat code panel affirmed the loose guards as
"compatibility-first / upgrade-safe" rather than flagging the under-specification,
because **no code-panel seat carries the guard-tightness-vs-known-type lens**. The
maintainer (dckc) was then forced to hand-file a cascade of guard-tightening
reviews on PR #15, one guard at a time.

## Member misses (all in journal2:review-misses/misses/)

1. `kriscendobot-agoric-sdk-pr15-review-396a141c.md` — argument guards left
   `M.any()`/`M.record()` where the static arg types are known; full-audit review
   directing each guard match its static type.
2. `kriscendobot-agoric-sdk-pr15-review-63f630f8.md` — `M.any()` **return** guards
   where the static return type is precisely known → tighten to precise shapes.
3. `kriscendobot-agoric-sdk-pr15-review-9a12af5e.md` — `returns(M.any())` on
   `withdrawHandler.handle` (portfolio.exo.ts) where the return is a
   `` `flow${number}` `` key; fixed by pinning to the already-exported
   `FlowKeyShape` and `M.promise()` for the async handler.

(Producing job for all three: `kriscendobot-agoric-sdk-pr15-gauntlet`, builder.)

## Deliverable (BOTH halves are mandatory)

### (a) Prevention — encode the convention where the producing work reads it

The producing role is **builder** authoring an agoric-sdk exo-interface-guard
change. Edit the **narrowest** artifact that governs that work so a future builder
tightens guards to their known static type by default and marks any residual
looseness as a documented, reasoned exception. Candidates (you choose the
narrowest fit; do not scatter):
- a focused skill or context-library page on agoric-sdk exo-guard authoring
  discipline (the TypedPatterns convention: guard matches known static type;
  looseness is a documented exception; prefer an already-exported precise shape
  like `FlowKeyShape` over a fresh loose matcher; async handlers use `M.promise()`),
  referenced from the builder's flow; OR
- the builder `AGENT.md` / an existing agoric skill if one already covers exo work.
Cite the repo's own `CONTRIBUTING` § TypedPatterns as the authority.

### (b) Sensing — a durable review-cycle check the panel cannot forget

The cluster's `missed_by` is **spec-keeper** (the closest convention-rigor seat;
judge whether its lens is the right home or whether a distinct guard-tightness
lens is warranted — skill § Improve descending-preference order). Default (option
2): amend `roles/jurors/spec-keeper/AGENT.md` with an explicit check — "on an exo
interface-guard diff, does each method guard (argument AND return position) match
its known static type as tightly as possible? Is any `M.any()`/loose matcher a
documented, reasoned exception, or an under-specification against a known type?" —
AND add a `skills/panel-hints/probes/` probe that **fires** that seat on the
guard-looseness diff signal (added `M.any()` / `returns(M.any())` / bare
`M.record()` inside an `M.interface(` / exo guard context in a `.ts`/`.js`
touching exo definitions). Err toward firing: a loose probe is acceptable, a
missed fire is not. Probe and seat amendment land in the same commit.

Prefer a deterministic mechanization where it fits (a probe that fires the seat is
the mechanizable half; deciding whether looseness is *justified* needs the seat).

### Re-litigation test (close with this, per member)

For EACH of the three member misses, name the exact check (the amended seat line +
the probe) that would now catch it, and **demonstrate the probe fires** on the
historical PR #15 guard diff where that miss occurred (e.g. run the probe against
a synthesized diff hunk adding `returns(M.any())` inside an exo `M.interface`).
All three are the same signal in different guard positions, so one probe should
fire on all three; show it.

### Close out

When done, close the cluster on journal2:
```
scripts/jobs/review-miss-record.sh cluster-status exo-guard-matches-static-type closed \
  --improved-by "<commits/files changed>"
```

Commit garden changes with explicit pathspecs and push to main2 with a rebase CAS
loop (`git push origin HEAD:main2`).
