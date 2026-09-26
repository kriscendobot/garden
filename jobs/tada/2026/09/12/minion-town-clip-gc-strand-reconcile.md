PR #93 survived as the authoritative strand; rebased onto current `main`, updated to the register-by-id model, and pushed at `7374bbe44ad4d7b2476c43deb6a54dea263f6e13`. Its body now explains the choice and supersession.

Salvaged from PR #92: production audit evidence, randomized timer delay, and AWS deployment documentation. Dropped: its alternate entry point, broader service identity, lower memory ceiling, serving-unit coupling, and instance-specific runbook identifiers.

Added remaining safety fixes for missing stores, zero-grace deletion, interrupted vhost writes, explicit excision outcomes, collision-resistant temporary files, and worker-stable guest cleanup.

Closed PR #92 with a supersession comment linking PR #93. PR #93 remains draft, mergeable, and has green CI.

Verification: 402 tests passed with 5 integration tests skip-gated; build, typecheck, all 7 pre-push gates, shell syntax, systemd verification, and GitHub CI passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-gc-strand-reconcile.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 663s

<!-- garden-usage-end -->
