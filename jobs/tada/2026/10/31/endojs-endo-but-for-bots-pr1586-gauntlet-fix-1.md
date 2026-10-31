Fix round 1 for endojs/endo-but-for-bots #1586 is finished and CI is green, with all 36 checks passing (`ci-wait-merge.sh --no-merge` returned 0).

- **What was done:** an earlier claim of this job had already applied both pre-pass findings and pushed them to `build/fs-interface-reconciliation` as commit d42122a9a:
  - **Failing probe (spelled-out identifiers):** the `streamBase64` rest parameter was renamed from `args` to `streamArguments` in `packages/platform/src/fs/types.ts`, and the code-mode declarations were regenerated. `generated/code-mode-globals/fs-declarations.js` no longer contains `args`.
  - **Advisory (comment concision):** the comment on `EndoReadableTree` at `packages/daemon/src/interfaces.js:961` is down to two lines: the `SnapshotTree` shape and the design reference.
- **What this attempt did:** I checked that both fixes are on the PR head, made no new commits, and waited for CI to finish.
- **Follow-ups:** none. The driver posts panel-2; the PR stays a draft until then.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1586-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 54 tokens (1475321 cached reads)
- Output: 8011 tokens
- Cost: $1.2063322
- Wall-clock: 5007s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
