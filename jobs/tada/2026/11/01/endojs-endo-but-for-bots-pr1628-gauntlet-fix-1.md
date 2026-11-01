Fix round 1 for endojs/endo-but-for-bots#1628 is pushed and CI is green (34 of 34 checks passed).

**What I fixed** (both items come from the style pre-pass block in the job, since panel-1 stopped before any jurors ran):
- **Abbreviated identifier (`spell-out-identifiers`, failing):** in `packages/exo-agent-factory/test/daemon.test.js`, in the test "a crash after Revoking is journaled converges to Revoked across nested namespaces and releases quota", I renamed the destructured `summary: c` to `deeperChild`. I also renamed its sibling `summary: a` to `subChild` so the two read the same way, and updated every place they are used. The child names passed to `create` (`'a'`, `'c'`) are unchanged.
- **Comment advisory (pruner, non-blocking):** I kept the header comment at line 6. The PR only adds "removal and revocation interrupted by a crash" to that comment's existing list of which recovery cases the file covers, so it describes the test's scope rather than restating nearby code. Nothing to delete.

**Commit:** `4a17faa2c7` ("style(exo-agent-factory): spell out the nested-revocation child summaries"), a follow-up commit on `build/exo-agent-factory-crash-recovery`. I pushed it with `safe-push-pr-head.sh`, which moved the branch forward from `8703beb0b3`. Prettier passes on the file, and eslint reports no errors (only the existing `@ts-nocheck` warning).

**CI:** `ci-wait-merge.sh --no-merge` exited 0.

**Follow-ups:** none from this stage. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1628-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (608658 cached reads)
- Output: 3074 tokens
- Cost: $0.6036515999999998
- Wall-clock: 674s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
