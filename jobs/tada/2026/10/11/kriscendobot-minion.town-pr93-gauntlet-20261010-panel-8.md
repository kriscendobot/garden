Panel round 8 on PR #93 came back **must-fix**. I posted the verdict as a review, and per the job I made no fixes and left the PR in draft.

- **Panel run:** `panel.sh` ran in single-round mode against head `e0cc943a` (base `main-c9a073c`) and exited 0. Of 34 seats, 6 approved, 24 left comments only, and 4 requested changes: breaker, pruner, saboteur and scribe.
- **Mechanism check:** the decomplector was seated because the same parts of the change (`internBlob`, `inventoryBlobs`, `removeDirectory`, `content-gc-cli.ts`, `endo-gateway-gc`) drew must-fix findings in rounds 6 and 7. It judged the garbage-collection design justified, raised no must-fix, and found no maintainer decision rejecting it.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/93#pullrequestreview-5484920038. GitHub won't let the bot request changes on its own PR, so it went up as a comment, like rounds 6 and 7. The body opens with "Panel round 8 — must-fix", includes the four request-changes seat reports in full, and ends with a `garden-panel-verdict: must-fix round=8` marker.

What the request-changes seats want fixed:
- **One record can stall GC for everyone (breaker and saboteur):** if a tenant's `front` value points at junk (not a valid blob id, not a manifest, an already-swept blob, or a manifest over 8 MiB), every GC run aborts. `--drop-unresolved` can't clear it, so the only fix today is editing the record by hand. They want an operator-driven way to excise or skip a bad record, or per-record reporting.
- **Excision race (breaker and saboteur):** the code checks a record, waits on a liveness call, then renames the file to `.excised`. If the site is republished during that wait, the fresh live record gets moved aside. They want the record re-checked just before the rename, and a unique `.excised` suffix so a second excision doesn't overwrite the first.
- **Saboteur also flagged:** an error swallowed by a `catch` in `unpublish`, and no lock preventing a manual run from overlapping a timer run.
- **Pruner:** move the GC validation script and step-by-step procedure out of `DEPLOYMENT.md` into a separate runbook, and shorten the "Recovering from a bad settled record" section, which repeats earlier guidance.
- **Scribe:** the last PR summary comment refers to head `90502b5`, and 11 commits have landed since. A new summary should name `e0cc943` and say what changed in each round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-panel-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1073459 cached reads)
- Output: 4723 tokens
- Cost: $0.8497198000000001
- Wall-clock: 233s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
