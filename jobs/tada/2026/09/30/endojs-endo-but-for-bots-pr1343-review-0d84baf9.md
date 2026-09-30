I sent kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots#1343 (review 5360774903) to two new jobs. I made no code changes myself. Both jobs are confirmed in `jobs/todo/` on `origin/journal2`.

**Preflight:** exited 0 (PROCEED). No peer had already resolved this review.

**What the review asked for:** the review body plus three inline comments.
- **Review body:** endowment values should use a pet-name or pet-name-path shape.
- **Review body:** post a follow-up job so the Exo surface accepts only pet-name paths, and record why.
- **`packages/daemon/src/provision/shapes.js:71`:** is `introducedNames` still needed?
- **`packages/daemon/src/provision/shapes.js:72`:** can the value side be a pet-name path?
- **`packages/daemon/src/host.js:1918`:** make a breaking change and merge everything into one `endowments` option, with keys starting `@` treated as special names.

**Jobs posted**, each with a `--identity` tied to review 5360774903:
1. **`ebfb-pr1343-endowments-fix`** (fixer): covers all four asks on PR #1343.
   - Endowment values move to the pet-name-path shape.
   - It decides whether `introducedNames` is obsolete (remove it if so) and answers in that thread either way.
   - It merges everything into a single `endowments` option split by the `@` prefix, replacing `endowSpecialNames`, and updates tests, types, docs and the PR body.
   - It replies to each inline thread with the commit that resolves it.
2. **`ebfb-petname-path-only`** (builder): the follow-up the review asked for. It is a breaking change across the Endo Exo surface: accept only pet-name paths (arrays) and reject a single pet-name string, with an error telling the caller to retry with an array of path components.
   - The job records kriskowal's reason: agents, like people, can't tell whether a string is a delimited path or what the delimiter is.
   - It must coordinate with the #1343 fix rather than duplicate it.

**On the PR:** I posted a comment acknowledging the review and naming both jobs: https://github.com/endojs/endo-but-for-bots/pull/1343#issuecomment-5904533405

**Next:** a fixer and a builder need to claim the two jobs. The inline threads get their replies when the fixer pushes to #1343.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-review-0d84baf9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (372979 cached reads)
- Output: 4324 tokens
- Cost: $0.5068598
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
