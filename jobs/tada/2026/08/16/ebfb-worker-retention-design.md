The deliverable is complete and delivered. Inbox is empty; draft PR #997 is open against `llm`.

## Completion report

**Job:** Design research brief — worker retention, revocation, and the batch-flush retention root (`endojs/endo-but-for-bots`, `llm` branch).

**What I did:**
- Grounded the design in the actual codebase and design corpus: read `daemon-cross-peer-gc` (Complete), `daemon-retention-paths`, `ocapn-orthogonal-persistence` (name hub / upgrade-by-rebinding / at-most-once abort), `daemon-debug-worker-restart`, and `daemon-xs-worker-metering` (admission control), plus the design-doc house style.
- Ran a library prior-art sweep for the named threads. It returned precise, citable material — and several corrections I folded in: E's `partition` is **collective** (not per-reference), Endo's own concept names (**cohort-destruction**, **revocation-by-withdrawal**, **captp-bounded-transient-pin**), SwingSet's exact GC delivery vocabulary, the OCapN wire verbs (`fulfill`/`break`, `op:gc-exports`/`op:gc-answers`/`op:abort`), Miller's Distributed Confinement sources — and honest **gaps** (no CapTP-embargo page, no "nothing-further-forthcoming" wire message, no Hofman-worker-model/zygote pages, which I therefore cite as the conversation's positions, not library facts).

**What changed:**
- New `designs/worker-retention-and-revocation.md` (822 lines, Status: Proposed). Each of the five threads lands a recommendation or an explicit "not yet, because X". Priority Thread 5: **recommend building the batch-flush retention root as a specialization of CapTP question/answer refcounting** (refining the existing captp-bounded transient pin from connection-lifetime to single-question-lifetime), all four numbered questions answered concretely — including "locally derivable, no OCapN change" for the two-party case and an explicit multi-party deferral. Positions worker-type-as-constraint on the incarnation formula; scopes (does not solve) durable pending-promises; keeps every path clear of guest-observable formula identifiers; includes a Citations section.
- `designs/README.md`: summary-table row, M3 milestone row, top "Layered on" note, totals synced (Proposed 26→27, 151→152 designs). I deliberately did **not** place it on the Gantt/critical path (it's a reassessment, not a build target).

**Delivery:** committed on branch `design/worker-retention-and-revocation`, pushed to the `kriscendobot` fork, opened **draft PR #997** against `endojs/endo-but-for-bots:llm` (https://github.com/endojs/endo-but-for-bots/pull/997). Draft is appropriate — it's an exploratory doc for the maintainer to decide on.

**Follow-ups (for the maintainer, captured in the doc's Open Questions):** the state of three-party-handoff embargo in `packages/ocapn` (blocks Thread 5's multi-party scope); whether any pipeline state is neither resolved nor GC-dropped nor session-aborted (Q4 residual); default lease/cap numbers; the incoherent worker-discipline combinations to reject; and whether the daemon can detect direct-in-heap vs. host-mediated references at revocation time.

Note on evidence: I verified structure, internal-link resolution, and the PR/commit state by running the commands; I did **not** execute any code (none to run for a design doc), and the design's recommendations are reasoned proposals, not verified implementations.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-worker-retention-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 74 tokens (4957163 cached reads)
- Output: 57180 tokens
- Cost: $6.83774325 (1 engagement(s) unpriced)
- Wall-clock: 860s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
