Design landed on PR #16's branch and the summary comment is posted. Done.

---

**Completion report — job `kriskowal-garden-pr15-33ace472`**

**Directive:** A kriskowal comment on issue #15 asking to design the *reputation bootstrapping* for the bid/accept gardener market: measure past and future jobs by effectiveness and cost, with effectiveness controlled by the acceptance criterion (so cost is the free variable, normalized to dollars and duration), seed reputation from the current fleet, explore/exploit the marketplace, refine roles into fresh-reputation bidders, and bound role proliferation with a cap or hierarchy plus a consolidator.

**Context established:** The bid/accept market design lives on branch `design/gardener-bid-accept-market` / **PR #16** (DRAFT, Status: Proposed). It had also landed on `main2` (bf740ad4c) and was correctly reverted (cb8066c8f) to keep `main2` clean, so the design is PR-only. The garden already meters token cost deterministically (`scripts/jobs/usage-meter.sh`, from Claude Code session logs) and the journal `todo`/`tada` lineage carries timestamps, so the cost primitives and a labeled history already exist to ground the design.

**What I did:**
- Authored `designs/gardener-reputation-bootstrapping.md` (companion to the market doc, not an overload of it), covering all six asks: effectiveness-as-gate + cost-as-free-variable unified as *cost per accepted job* (§1); two-source bootstrap (retrospective journal seeding + synthetic `tada`-replay) (§2); per-job urgency/quality/cost demand weights (§3); a Thompson-sampling contextual bandit, deterministic and budget-throttled (§4); a reputation-driven role refiner minting fresh-prior bidders (§5); and a hard cap + consolidator with hierarchy as the follow-on (§6). Plus journal layout (§7), additive shadow-first phasing (§8), open questions (§9), and decides/defers (§10).
- Cross-linked it from the market doc's §3.4 and the `designs/README.md` index.
- Committed (`629de0ef`) and pushed to `design/gardener-bid-accept-market` via a rebase-CAS loop (fast-forward, clean).
- Posted a top-level summary comment on PR #16 (the design discussion venue) mapping each ask to its section: https://github.com/kriskowal/garden/pull/16#issuecomment-4838585481

**Changes:** `designs/gardener-reputation-bootstrapping.md` (new, ~270 lines); small edits to `designs/gardener-bid-accept-market.md` and `designs/README.md`. Design-only, no source or behavior change.

**Follow-ups for the maintainer (called out in §9):** whether notional dollars (flat subscription) or the real weekly token quota is the right long-run cost unit; load-contended duration normalization; cost attribution across a cross-arm requeue; the consolidator's statistical "indistinguishable" test. The design notes that §2.1 retrospective shadow measurement can begin immediately, before bid/accept ships, since it reads only existing journal + session-log data.

**Self-improvement:** nothing this time.
