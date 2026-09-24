I applied both of dckc's review points to Oros-AI/oros-ckm-data-readiness#2 and #3, and the two PRs still have the same diff.

**What changed on both PRs (follow-up commits)**
1. **CONTRIBUTING.md is too long:** cut to two sentences. Commits: #2 `d824a8d`, #3 `ca062a4`.
2. **"Don't we already have a CI workflow?":** yes. `kriscendobot/oros-ckm-data-readiness#1` merged a `.github/workflows/ci.yml` into the fork's `ckm-poc-build`, and it already runs `npm run typecheck`. With this PR's change, that command now enforces `erasableSyntaxOnly`. So there was no step to add, and I deleted `lint.yml`. Commits: #2 `48e9615`, #3 `619d058`.
   - **Caveat:** that CI workflow is only on the kriscendobot fork. Oros-AI's `ckm-poc-build` (and every other upstream branch) has no workflows at all. Until `ci.yml` goes upstream, the check runs only through `npm run typecheck` / `npm run build`, not in CI on Oros-AI.

The #3 commits keep the `Requested-by:` and `Generated-by:` trailers.

**GitHub updates**
- Put 👀 on both review threads, then replied in each with links to the #2 and #3 commits (`r4096520764`, `r4096521593`).
- Updated the "What changed" bullets in both PR descriptions: removed the lint.yml bullet and added a note that the fork's CI workflow already runs the check. I also edited #2's description because it said the repo had no CI, which was wrong.
- In #3's description, I made the "Third-party material" disclosure line match the new diff and changed the bare `#2` to a full `Oros-AI/oros-ckm-data-readiness#2` reference. The rest of the disclosure section is unchanged.
- Commented on kriscendobot/garden#112 with the commit links: https://github.com/kriscendobot/garden/issues/112#issuecomment-5818954763

**Follow-up:** the maintainer should decide whether to send the fork's `ci.yml` (`kriscendobot/oros-ckm-data-readiness#1`) upstream to Oros-AI. Without it, #2 and #3 have no CI enforcement there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-oros-ckm-pr2-pr3-review-feedback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (818986 cached reads)
- Output: 8302 tokens
- Cost: $0.7350051999999998
- Wall-clock: 116s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
