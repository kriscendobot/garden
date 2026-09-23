The panel verdict is posted. The stage is complete.

## Completion report

**Job:** Gauntlet PANEL round 1 for endojs/endo-but-for-bots PR #1061 ("refactor(marshal): move public types to declarations").

**What I did:**
1. Resolved the PR head (endojs fork, branch `refactor/marshal-types-declaration-module`, base `master-8c402ee` @ `8c402ee89`) and set up an isolated project worktree of the head at `f5b159eb7`.
2. Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against that worktree with base `origin/master-8c402ee`. The full seat fan-out completed and aggregated to disposition **must-fix** (`panel #1061: code-panel single-round — must-fix`; `record-meta` confirms `disposition=must-fix`).
3. Posted the aggregate as a `gh pr review` on PR #1061.

**Panel outcome — must-fix.** Three seats returned request-changes; the blocking items:
- **integrator [must-fix]** — PR body cites `Refs: #475`, but #475 is an unrelated PR (`feat(pass-style)!: narrow byteArray…`); the design-lineage citation is unsupported.
- **prover [request-changes]** — `types.test-d.ts`'s `PublicMarshalTypes` tuple is asserted against itself (`expectType<T>(null as unknown as T)`), pinning no shape; replace with per-type literal assertions.
- **purist [should-fix]** — `FromCapData` lost its `@returns … a Passable` doc comment while its `ToCapData` partner kept the contract in-signature (family asymmetry).
- **integrator [should-fix]** — the two `// spell-out-exempt:` comments match no enforcing tool in the repo.
- **packager [comment]** — the new `.gitignore` `!…/marshal/src/types.d.ts` line breaks the section's alphabetical-by-package order.

**Note on review type:** the PR is authored by `kriscendobot` (the bot), so GitHub rejects a self `--request-changes` review. Posted as a **COMMENT** review instead (confirmed live, `state: COMMENTED`), carrying the full must-fix summary header plus per-seat detail (trimmed to fit GitHub's 65536-char review-body limit). The fixer stage reads "the latest panel verdict" review regardless of type, and the gauntlet driver advances on the stage-result marker below.

**Follow-up:** none owed by this stage — I ran exactly one round and stopped (no fix, no un-draft). The gauntlet driver will post `panel-fix-1` off the must-fix result.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1218229 cached reads)
- Output: 9906 tokens
- Cost: $1.4518055000000003
- Wall-clock: 716s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
