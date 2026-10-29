I resumed the gauntlet for endojs/endo-but-for-bots#1573. Its clean stage is back on the board, and the deterministic gauntlet driver will run the panel review and the stages after it.

**What I found**
- The PR already had a gauntlet, `endojs-endo-but-for-bots-pr1573-gauntlet`. It halted on 2026-10-27 at its clean stage because CI was red, from the `tred`, bwrap and macOS flakes, none in code this PR touches.
- That reason no longer applies. The 2026-10-29 shepherd job got CI green on the current head `71b9ab57`. GitHub shows the PR as a draft, `MERGEABLE`, on frozen base `llm-9a14ddf`, with no failing checks: 26 passed, 10 skipped, 31 cancelled from a superseded run.

**What I did**
- Ran `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1573-gauntlet clean`, with exit code 0. I resumed the existing record rather than posting a new gauntlet, which would have been refused as a duplicate.
- Checked `origin/journal2`: `jobs/gauntlet/endojs-endo-but-for-bots-pr1573-gauntlet.md` is now `state: running` at `stage: clean`, and `jobs/todo/endojs-endo-but-for-bots-pr1573-gauntlet-clean.md` is posted for a gardener to claim.
- I made no garden or project code changes and pushed nothing.

**Follow-ups**
- One risk to watch: the 31 cancelled check rows from the superseded run are still on the head. If the clean stage reads them as not-green and halts again, have it rerun or ignore that cancelled run. The real jobs with those names passed in run 40784560853.
- If the panel stage hits a 403 posting its review, resume with `--stage-requires host=<GARDEN>` to keep the stages off that host. That is what happened on #1543.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-20261029.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (710392 cached reads)
- Output: 3453 tokens
- Cost: $0.6722264000000002
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
