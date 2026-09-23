The fixer job has already been claimed by a peer. Everything is landed.

**Panel backfill complete — endojs/endo-but-for-bots#713.**

**What I did**

Ran the missing jury panel against PR #713 (`feat(daemon): EndoMount glob+grep+glorp delegated to @endo/platform/fs/search`), head `454b2b97db`, base `llm`, 16 files / +1525. Confirmed first that the PR carried **zero reviews of any kind**, so the backfill was warranted.

- **Panel:** the full **28-seat code panel**. This host's *deployed* `panel.sh` predates `main2`'s concurrent fanout, so I fanned the seats 6-at-a-time with a detached driver (each seat still one `claude -p` over its `roles/jurors/<seat>/AGENT.md` with `panel.sh`'s exact `seat_review` prompt), then handed the blocks back to the real `scripts/jobs/gardening/panel.sh` via `GARDEN_PANEL_SEAT` so panel-kind sensing, aggregation and the disposition were the script's. Foreperson: **must-fix**.
- **Verdicts:** 24 request-changes, 1 approve (`gateway`), 3 comment-only (`scribe`, `transplanter`, `coverage-auditor`).
- **Interruptions:** a mid-run session-limit exhaustion killed 12 seats; re-run after reset. All 28 have real verdicts.

**Findings** — 9 must-fix, a 14-item summary-fix bundle, 11 follow-ups, 4 acknowledged/dropped. The severe ones are empirically measured, most by several independent seats:

1. `maxResults: M.number()` admits `NaN`/`Infinity` — `NaN` scans the whole tree, buffers every match, then returns `[]` (10 seats).
2. Caller-supplied RegExp on the daemon's single event loop — **56–57 s** stalls measured from one 34–41 byte line, on an engine whose sibling glob matcher was hand-rolled *specifically* to avoid ReDoS.
3. Revocation checked only at method entry — a revoked holder still received 432–1640 paths and 1000 records of file contents.
4. Deny filtering tests only the enumerated entry *name*, so an in-root symlink `pub -> .ssh` leaks `.ssh/id_rsa` contents through the default no-argument `grep`. I re-verified this one against `search.js` myself (`isDeniedName` :127 vs `resolveChild` :276-280); it falsifies the guarantee text this PR ships and the cross-language contract it publishes.
5. The three help entries were hand-written into a **generated** file whose source (`help.md`) was never touched — next regeneration deletes them.
6. The grep deny tests are inert: disabling deny filtering leaves 14/14 green, and the parity table has no deny row.
7. Phantom trailing line from an unguarded `split('\n')`; 8. the claimed `glorp` native-override seam does not exist; 9. the PR body still describes only layer G′.

**Artifacts**

- Review posted: https://github.com/endojs/endo-but-for-bots/pull/713#pullrequestreview-4801900438 (as `--comment`; GitHub refuses `--request-changes` on the bot's own PR).
- Fixer job `endojs-endo-but-for-bots-pr713-panel-fixes` posted — **already claimed** by a peer (`jobs/doin/`).
- Follow-up ledger `projects/endo-but-for-bots/followups/endo-but-for-bots--713.md` (11 parked items).
- Journal `result` entry `entries/2026/07/28/212025Z-result-gardener-031da3.md`; two messages to the liaison carrying the proposed rules.
- Garden commit `9adce6f038` on `main2`: `skills/panel/SKILL.md` now names the two hook hazards.

**Not verified:** I did not run the project suites; every measurement quoted in the review is a seat's own probe against a built mount (finding 4 additionally re-checked by me against the engine source). CI-green on this head is GitHub's report.

**Follow-ups for the garden** (messaged, not landed by me)

- A `GARDEN_PANEL_SEAT` hook cannot read its own block: `seat_review > "$block"` truncates it first. Cost me one seat's block. Documented; a script-side guard is still open.
- The retry-on-empty guard treats a session-limit message as a real verdict (non-empty stdout, exit 0) — 12 seats filed limit text as their block. Needs a content check, not just a blankness check.
- I initially reported the serial fanout as unfixed and **corrected it**: `main2` already has `GARDEN_PANEL_CONCURRENCY`; this host's deployed root is behind, so workers here still hand-roll drivers. The ask is a deploy, not a code change.
- Two seat briefs cite rules that do not exist (`benchmarker` → `skills/benchmark-comparative-report/SKILL.md` + `roles/scout/`; `changeset-auditor` → a "Sentence-per-line" section of `skills/changeset-discipline/SKILL.md`), forcing both to downgrade citations to `proposed-rule`.
- `skills/panel-review/SKILL.md` § Pre-round state check still tells a gardener to short-circuit on `isDraft == false`, which a literal reading would no-op this job shape (also raised by the #848 backfill).

The project worktree is left in place for the scratch janitor.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr713-gauntlet-backfill.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 110 tokens (8196824 cached reads)
- Output: 40519 tokens
- Cost: $8.233525
- Wall-clock: 815s

<!-- garden-usage-end -->
