The approval reconciler now reads `maintainers/allowlist` once per tick instead of once per PR. The change is pushed to `main2` as `f943afdabc4`; the updated `approval-reconciler-test.sh` passes 34/34.

**What I changed**
- **Reconciler** (`scripts/jobs/approval-reconciler.sh`): right after the existing check that skips the tick if the journal fetch fails, it copies the allowlist out of the journal clone it has already fetched into a temporary file. It then exports that file as `GARDEN_MAINTAINERS_ALLOWLIST`, a setting the approval handler (`pr-maintainer-approval-gh.sh`) already supports. The mergeability probe calls that same handler, so both per-PR probes now skip their own journal sync.
  - If the allowlist file is missing from the journal, the copy is empty. The handler then falls back to its documented default owners (kriskowal, erights), which is what its own read did before.
  - If an operator has already set `GARDEN_MAINTAINERS_ALLOWLIST`, it is left alone.
  - The temporary file is deleted when the tick exits.
- **New test case S**: it runs the real approval handler, with a stubbed `gh`, across four PRs in one tick. It checks that:
  - the handler never creates its own journal clone;
  - every probe read the same allowlist file;
  - that file is gone after the tick;
  - maintainer approvals still post conductors (950–952), and an approval from someone not on the allowlist (953) does not.

With the reconciler change reverted, case S fails on its first two checks, so it catches this regression.

**Follow-ups**
- The fix only takes effect on each host once the next deploy picks up `f943afdabc4`. Until then, timeouts on these probes are expected and need no new job.
- A probe that still times out after deploy would be slow on the GitHub calls themselves, not on the journal.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-probe-snapshot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1176092 cached reads)
- Output: 10036 tokens
- Cost: $1.0392823999999998
- Wall-clock: 289s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
