I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1644 with the job's title and body. It points `feat/lal-iterative-compaction` at the frozen base `llm-48d6f3e`.

- **Refs checked:** `git ls-remote` shows the head at `c4ede16c7d377526973f1a38ebf00e939bc0a558` and `llm-48d6f3e` at `48d6f3e08bcc`. `gh pr view` shows the PR is a draft and its head is that same commit.
- **Body:** I copied the text between the BODY markers in the job file verbatim to a file and passed it with `--body-file`.
- **Durable marker:** I ran `ensure-pr.sh` under the original job base `endopi-iterative-compaction-build`, so the `<!-- garden-job: endopi-iterative-compaction-build -->` marker matches the job that built the work.
- **First attempt failed:** run from the garden worktree, `ensure-pr.sh` stopped with `phase-evidence-verdict=undetermined reason=governing-design-unresolved`. The phase/evidence gate checks the git repo in the current directory, so it was not looking at the project at all. I made an isolated project checkout with `ensure-project-worktree.sh`, detached it at `c4ede16c`, and re-ran from there. The gate passed and the PR opened.
- **Warnings:** `ensure-pr.sh` warned that the body adds two headings the PR template does not name ("Where this departs from the job and the design", "Why not reuse existing code"). Extra headings are allowed, so I left the body unchanged.
- **Not recorded on the board:** it also logged `no work/endopi-iterative-compaction-build record on the board`, so the PR number was not written against the original job. This completion report, which names the PR URL, is how the gauntlet gets staged.

**Follow-up:** `ensure-pr.sh` reads the git repo in the current directory to run its phase/evidence gate. A job that opens a PR for work built elsewhere and calls it from the garden worktree will hit the same refusal. It could be worth making it fail with a clear "run me from a project checkout" message.

I made no garden commits and wrote no project code.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-iterative-compaction-build-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (594661 cached reads)
- Output: 3118 tokens
- Cost: $0.5734362
- Wall-clock: 75s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
