Job complete.

## Completion report

**What the job asked:** Classify the observed provider envelope *"Selected model is at capacity. Please try a different model."* as a transient provider-capacity failure so `gardener.sh` requeues/backoffs instead of escalating a real handler failure, with regression coverage alongside the existing transient-signature tests.

**What I did:**
- **`scripts/jobs/common.sh`** — added `at capacity` to `GARDEN_TRANSIENT_CLAUDE_SIGNATURES`, the single source of truth that both `gardener.sh`'s inner-claude classifier and `follow-up-claude.sh` consume via `is_transient_claude_signature`. The envelope is overload-shaped and self-resolving, so it belongs in the ambiguous/overload family (like `overloaded`) — deliberately **not** in the `GARDEN_EXPLICIT_CAP_SIGNATURES` floor-exempt subset, because it carries no named reset time, so it correctly keeps `gardener.sh`'s short-elapsed plausibility floor. Documented the rationale in the signature-set comment block.
- **`scripts/jobs/test/claude-session-limit-classifier-test.sh`** — added regression coverage: two `assert_transient` cases (exact + uppercased envelope) in SUBTEST 1 and one `assert_notcap` in SUBTEST 1b pinning that the envelope stays floor-gated. Extended the header comment. Full run: **43 passed, 0 failed** (was 40).

**Note on process:** My first pass of edits accidentally landed in the deployed garden root (`/home/kris/garden2/...`) rather than the worktree, due to using those absolute paths. I caught this before any git operation, reverted those files with the Edit tool (no git ever run in the root), verified they are byte-identical to `HEAD`, then re-applied the changes correctly in the per-job worktree. No git command ever ran in the deployed root; journal sync is unaffected.

**Result:** Committed `c626b1d09d` and pushed to `origin/main2`. The change takes effect on the next fleet deploy of `common.sh`.

**Follow-ups:** None. `claude-session-limit-classifier-test.sh` is not in the `GARDEN_DEPLOY_TEST_SUITES` deploy-gate list, but neither were its sibling classifier tests before; leaving that unchanged to stay in scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-selected-model-capacity-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (2781551 cached reads)
- Output: 15268 tokens
- Cost: $2.4733055000000004
- Wall-clock: 249s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
