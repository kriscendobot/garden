Done. Both design docs and the index rows are on the PR #16 branch, the inbox is clear, and the reply is posted on issue #15.

---

## Completion report

**Job:** Dead-lettered comment from kriskowal/garden issue #15 (intended for the completed `issue-kriskowal-garden-15` doer). The maintainer asked to *also design the reputation bootstrapping*: measure past and future jobs by effectiveness and cost, with effectiveness controlled by the acceptance criterion so **cost is the free variable, normalized to dollars and duration**.

**What I did:**
- Folded the cost decomposition into the reputation-ledger section of `designs/gardener-bid-accept-market.md` (the in-flight DRAFT design on **PR #16**, branch `design/gardener-bid-accept-market` — the design was reverted off `main2` and lives only on the PR branch, so I extended the PR branch, not `main2`):
  - **§3.1** ledger event schema now carries a `cost` block (dollars, wall-clock + active duration, attempts, raw tokens, `subcontract_dollars`, `source: live|replay`).
  - **§3.3 (new)** — effectiveness is the binary acceptance *gate* (held at the criterion, so accepted work is equally effective); cost is the only differentiating axis; the two unify as **`E[cost-to-acceptance] = c/p`**, which the selector minimizes among adequate kinds. Reputation becomes a per-`(kind, job-kind)` estimate of `(p, c_dollars, c_duration)`, not a scalar.
  - **§3.4 (new)** — normalization to dollars (Σ tokens × dated journal rate-card; bidder production spend separated from market/oracle overhead) and duration (two honest clocks). Only token capture is new plumbing.
  - **§3.5/§3.6/§5.3/§7** — selection by expected cost; replay-based bootstrap (passes-identical-tests, not identical-artifact); start booking tokens now so dollar history exists going forward.
- **Reconciled with a concurrent peer's work:** a peer gardener (same intent) had already pushed a standalone companion `designs/gardener-reputation-bootstrapping.md` (Thompson sampling, `usage-meter.sh`, role refiner/consolidator) and cross-linked it. The rebase merged cleanly; I adjusted framing so the two docs are **complementary, not competing/contradicting** (deferred the full harness + Thompson-sampling explore/exploit to the companion; kept the in-ledger measure here). Verified substance aligns (their "cost-per-accepted-job" = my `c/p`; "metered tokens at list prices" = my dollar normalization).
- Pushed to the PR branch (`629de0efb..0be83ad86`).
- Posted the reply on issue #15 ([comment 4838610818](https://github.com/kriskowal/garden/issues/15#issuecomment-4838610818)) as `kriscendobot`, covering both artifacts; left the issue open for the submitter to close.

**Changed:** `designs/gardener-bid-accept-market.md` (+212/−38) on the PR #16 branch. No source or behavior change (design-only, Status: Proposed). The companion doc and both README index rows are present on the branch.

**Follow-ups:** (1) The subjective-convergence bootstrap variant (historical pairs with no re-runnable tests) is left as a follow-on; the objective test-replay path is the decided first cut. (2) The dollar-accounting plumbing (token capture + rate-card) is the one genuinely new mechanism and would be the first implementation step once the design is blessed. (3) Two design docs now address one directive from slightly different altitudes — if the maintainer prefers a single doc, they could be merged, but they're currently coherent and cross-linked.
