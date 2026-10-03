Fix round 6 for kriscendobot/minion.town PR #147 is pushed, and CI is green (3 of 3 checks pass).

**Inputs:** the round-6 design-panel verdict on head `8bed1aa`. It asked for changes in five seats (critic, decomplector, skeptic, novice, ergonomist).

**Changes:** one review-feedback commit, `c340df2`, to `designs/mcp-resources-getting-started.md`. It went to `kriscendobot/minion.town:design/mcp-resources-getting-started` through `safe-push-pr-head.sh --mode advance`, which moved the head from `8bed1aa` to `c340df2`.
- **critic:** § 6.4 now puts T1's `powers` leak under the strict "must beat baseline" bar, next to T2 and T3. The rule is strictly fewer runs that leak authority, and the tie clause now covers all three tasks.
- **decomplector:** § 4 has a new **App compatibility** rule. A resources commit R is served with app commit A only if `git diff --quiet A R -- src/` holds:
  - `deploy-resources.sh` refuses on any skew.
  - A forward app deploy passes by construction, because it ships its own resources.
  - An app rollback under a newer guide is the one skew allowed. It is stated as accepted and bounded: logged, and it ends at the next forward deploy or a guide revert.
  - Table 2 row 1 now states the same compatibility rule.
- **skeptic:** § 3.3 item 1 now checks the bootstrap's authority as well as its identity. Over the CapTP session, no method a remote caller can invoke may write, mutate, or return another reference.
- **novice:**
  - § 1 now defines the MCP terms (tools, resources, prompts, `instructions`) before they are first used.
  - § 3.2 now says what "the tool rule" is: a tool whose group is not mounted is missing from `tools/list`.
- **ergonomist:** `guide/evaluate` is renamed to `guide/workers` in both places it appears, so every `guide/*` name is a topic noun.

I left the panel's comment-only findings alone: the Table 2 live pointer, `commit` in default mode, the role of `instructions.md`, re-checking alignment with #95, the copyedits, and `§`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 3 minutes, with no failed checks.

**Follow-ups:** none from this stage. Per the gauntlet, the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 32 tokens (1055187 cached reads)
- Output: 7731 tokens
- Cost: $0.9393933999999998
- Wall-clock: 341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
