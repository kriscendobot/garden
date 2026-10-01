Panel round 1 on endojs/endo-but-for-bots#1408 ("feat(claude): run the confined claude in a bwrap slice") came back **must-fix**, and the verdict is posted on the PR.

**Run:** I ran the panel in single-round mode on an isolated checkout of `bot/build/claude-sandbox-bwrap-slice` at head `2d05ca3ef2`, against base `llm-d4124e6` (`d4124e6e40`). `panel.sh` exited 0 with disposition `must-fix`.

**Seat verdicts (33 seats):**
- **Request changes (9):** assessor, curator, migrator, purist, integrator, changeset-auditor, surfacer, pruner, releaser.
- **Comment only (10):** saboteur, breaker, spec-keeper, wire-watcher, engine-realist, gateway, corner-prober, fast-checker, transplanter, coverage-auditor.
- **Approve (14):** all remaining seats.

Two of the requested changes:
- **assessor:** when `claudePath` is a symlink (the usual global npm install), `--ro-bind` replaces it inside the sandbox with the target file's contents. Node then looks up the files next to the entry script in `/usr/local/bin` instead of the real install directory. No test covers a symlinked `claudePath`.
- **pruner:** cut sections of the PR body that add process detail without substance, such as § Scaling Considerations.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1408#pullrequestreview-5380069986
- **Comment, not request-changes:** GitHub refused a request-changes review because the bot authored the PR. The review starts with a header that says **Disposition: must-fix** and lists the seats, followed by an in-scope / must-fix section.
- **Body trimmed:** the full aggregate is 83 KB, over GitHub's 65,536-character review limit. The review keeps every request-changes and comment-only seat's text in full and lists the 14 approving seats by name only (about 60 KB in total).

**Follow-ups:**
1. Check that the next-stage heuristic accepts a COMMENTED review whose body says "must-fix" as a panel verdict. On bot-authored PRs a request-changes review can never be posted.
2. `panel.sh` should cap or split its aggregate itself, so the gardener doesn't have to trim an oversized one before posting.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1490869 cached reads)
- Output: 7365 tokens
- Cost: $0.9713857999999999
- Wall-clock: 934s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
