## Fix round 4 report: endojs/endo-but-for-bots PR #1408

I fixed the one must-fix finding, pushed, and CI is green: ci-wait-merge returned rc 0, with 35 of 35 checks passing and none failed. The PR head moved from `e9d568da3e` to `3d02782072`.

**What I changed:**
- **integrator (must-fix):** The PR body was missing two template sections. I rewrote it against `.github/PULL_REQUEST_TEMPLATE.md` and added the "Scaling Considerations" and "Upgrade Considerations" headings.
- **pruner:** I cut the PR body from 628 words to about 240. The per-file test walkthrough is now a one-line summary. I shortened the Security, Documentation and Compatibility sections but kept every template heading, because the integrator's must-fix requires them.
- **purist #3 (comment-only):** I committed `3d02782072` (`docs(claude): justify the read-only package-directory grant`). It adds a comment in `packages/claude/src/confined-turn.js` explaining why the sandbox gives `claude` read access to its whole package directory rather than narrower paths. The package loads files at run time from paths that change between releases. The access is read-only and the directory holds none of the daemon's state.
- **purist #1/#2 (should-fix):** I did not do these. They ask for shared bwrap code: one mount format and one set of security flags (such as `--disable-userns`) used by both this PR's slice and `@endo/sandbox`'s bwrap driver. That would change `@endo/sandbox`'s public interface, which is too big for a fix round. I explained the deferral in a PR comment (https://github.com/endojs/endo-but-for-bots/pull/1408#issuecomment-5943946223).

**Follow-ups:**
- The purist voted request-changes this round, so panel round 5 may raise #1/#2 again. If so, the shared-bwrap-code work should become its own PR.
- No job has been posted for it yet.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1128653 cached reads)
- Output: 6508 tokens
- Cost: $0.8172586000000001
- Wall-clock: 2879s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
