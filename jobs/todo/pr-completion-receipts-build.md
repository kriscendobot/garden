---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-05T12:46:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement the PR completion receipt automation designed by
`design-pr-completion-receipts` (read its `jobs/tada/design-pr-completion-receipts.md`
report and whatever design doc/schema it landed before writing any code).

Deliverables:
1. **The receipt generator** — per the landed schema: per-engagement rows
   (model, tokens, harness, role, notional cost, calibrated estimated cost)
   plus the one per-PR maintainer-review-feedback heuristic figure, built on
   `scripts/jobs/cost-by-pr.sh` and the reputation/usage ledgers per the
   design (extend `cost-by-pr.sh` itself if the design calls for that, rather
   than duplicating its join logic).
2. **The trigger** — wire it per the design's chosen mechanism so it fires
   once, idempotently, for every PR this garden completes work on going
   forward, merged or closed.
3. **PR-comment posting** — via the fleet's existing identity-pinned `gh`
   posting path, only for repos already authorized under CLAUDE.md's
   monitoring-safety constraint.
4. **Journal archival** — under the layout the design specifies
   (`journal/receipts/<repo>/...`, categorized by repository, date, and PR
   number).
5. **Ten example receipts** — generate and archive 10 receipts from real,
   already-completed PRs in this garden's own history (a mix of merged and
   closed-without-merge, per the design's guidance on candidates). Save them
   under the same journal archive layout as live receipts would use. Do
   **not** post these 10 as live PR comments — they are backfilled
   demonstration examples; say so explicitly in your completion report, and
   list all 10 PR URLs plus a link/path to each generated receipt.

Verify the generator's numbers are sane against at least one PR you can
cross-check by hand (e.g. against `cost-by-pr.sh`'s own existing output for
that PR, or the `## Cost` blocks on that PR's own `jobs/tada/*.md` reports)
before treating all 10 as done.
