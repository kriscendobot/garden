Done. One panel round run, verdict posted. Summary:

**What I did**
- Set up an isolated project worktree of PR #1085 head (`endojs:feat/mount-stream-glob-grep`), computed the real merge-base against `llm` (`65eb8869…`) locally since the base is an upstream branch (per the panel-base-normalization rule; GH API was rate-limited anyway).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against that worktree. Note: an early accidental second invocation clobbered the shared-path aggregate, so I re-ran cleanly into a dedicated `GARDEN_PANEL_RUNDIR`. The clean 29-seat code panel decided **must-fix**.
- Synthesized the aggregate into a panel-review-shaped body (grouped by disposition, cite-or-propose tags preserved, em-dashes swept), and posted it as a formal `gh pr review`.

**Verdict posted (must-fix).** Three `must-fix-loop` items block un-draft:
1. `designs/mount-stream-glob-grep.md:52-53,67` — "Surface" section contradicts the PR-rewritten "Producer implementation" sections on whether early return stops `streamGlob`'s (eager) walk; doc flipped to "Implemented" while self-contradicting.
2. `.changeset/daemon-mount-stream-glob-grep.md` — 332-word changeset addressed to the wrong audience (duplicates the design doc's threat model); trim to release-note register.
3. Missing invariant test that a `streamGrep` match's `{line, text}` identifies the matched source line.

Plus should-fix (U+2192 arrows in new help/design prose; undeclared `done` in a help example; class-level `revoke` doc not updated for the non-atomic streaming window) and follow-ups (per-grant `buffer` ceiling; fast-check property coverage). One escalation surfaced by the scribe seat: maintainer comment `#issuecomment-5462863853` ("explain premature halts generally") remains unaddressed — its routing job was reaper-doomed 2026-08-29 and is still parked.

**Posting note:** the PR is self-authored (`kriscendobot` == authenticated fleet identity), so GitHub blocks `--request-changes`. Per the panel-review pitfall I fell back to `--comment` while keeping the **Must-fix before merge** heading the next-stage-owed heuristic keys on. Review landed as a `COMMENTED` formal review at 2026-09-01T21:13:02Z.

**Stopping here** — single-round stage: no fix, no un-draft, no loop. The fixer stage is owed next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1797516 cached reads)
- Output: 15988 tokens
- Cost: $2.1081209999999997
- Wall-clock: 1545s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
