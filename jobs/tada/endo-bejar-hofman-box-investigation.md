The issue is live and authored by the bot; inbox is empty. This is a research-only job, so no garden-repo commit is needed. Writing my completion report.

---

## Completion report: Bejar-Hofman Box investigation

**What I did.** Researched the proposed "reachable-only-from-roots" monitoring primitive from primary sources, produced the full findings, and filed them as an issue on endojs/endo-but-for-bots. No implementation, no PR, no garden-repo change (correct for a research job).

**Deliverable:** **[endojs/endo-but-for-bots#1287](https://github.com/endojs/endo-but-for-bots/issues/1287)** — full findings, framed as proposal groundwork so the proposal can be written from it without re-research. Verified live, authored by `kriscendobot`.

**Key findings (all six asked-for deliverables covered):**

1. **Semantics.** `only-from(T,R)` = in the graph with edges *out of R* cut, `T` is unreachable from non-`R` roots. Over **strong** edges only; weak/ephemeron edges excluded (Hayes three-phase discipline). Inherently a **snapshot** — no post-condition liveness on its own; actionable only under a *no-re-acquire* side condition (which holds exactly in the cycle-break case). Recommended a **one-shot edge trigger**, disarmed on fire, not a re-arming level.
2. **Prior art, honestly.** CapTP/OCapN implement only **DAGC (acyclic)** by deliberate design ("no global analysis"); distributed reference counting *cannot* collect cross-vat cycles (Plainfossé & Shapiro). Cyclic-DGC families (trial deletion, back-tracing, migration, group merge) all cost global/group sync or back-trace traffic; leases trade correctness for a timeout. The box is a **fourth option**: an app-level *signal to break the edge*, not a system that collects the cycle. `FinalizationRegistry` is the special case `only-from(T,∅)` and can't express a parameterized, runtime-mutable root set.
3. **Runtime support.** As a **raw JS-heap primitive it needs engine support that does not exist** (stated as a legitimate finding) — not plausible in stock XS; *technically* implementable in the ironhorse exact collector but shouldn't be guest-exposed. **The real result:** at the **endo daemon/formula layer it is largely expressible on substrate that already ships** — `daemon-cross-peer-gc` (Complete) already maintains union-find retention groups and **syncs remote holder-sets on the wire** (`followRetentionSet`); `listRetentionPaths` already traces reachability. The box becomes a subscription that fires when a formula's holder set collapses to ⊆ `R`.
4. **Security (first-class).** A *parameterized* reachability predicate is strictly more informative than FR's death bit — it's a **reference-graph oracle** leaking third parties' holdings over time. Safe **only** at the daemon-mediated layer, inheriting the existing rule that `listRetentionPaths` is host-facet-only ("never reveal capabilities the caller doesn't own"). As a general guest-facing heap primitive: a clean **no**.
5. **Distributed extension.** Rides the existing retention-set sync (no new CapTP verb needed at the formula layer); **fail-safe under partition/restart** (unknown = held, never fire); defends against a lying peer via the inert-SturdyRef property (a peer can't re-forge a dropped reference).
6. **API sketch + worked two-party cycle-break** included.

**On-arc anchor:** the box is already circling this codebase — `sturdy-refs-endor-syscall` **Option A** ("daemon uses `FinalizationRegistry` to observe when a worker drops a SturdyRef") is literally the one-egress-edge degenerate case. Recommendation: fold the box into the sturdyref/retention arc, generalizing Option A to "holder set collapsed into roots `R`," with Option B's daemon-mediated posture.

**Follow-ups (left for the proposal, listed as open questions in the issue):** level-vs-one-shot as a hard rule; the exact authorization predicate for naming `R`; timing-granularity/jitter to blunt the oracle; whether ironhorse should expose a daemon-internal partial trace; whether the retention-set sync ever lags the underlying `op:gc-exports` drop enough to matter.

**Caveats on sourcing:** erights.org was unreachable from the container (connection refused), so the E/DAGC acyclic-only rationale is grounded in the OCapN CapTP spec (read directly) and the Goblins/E secondary docs rather than the erights page itself; the erights URL is cited but flagged as not-fetched. All endo `llm`-branch designs were read directly via the GitHub API.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-bejar-hofman-box-investigation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (862821 cached reads)
- Output: 21321 tokens
- Cost: $1.9725725
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
