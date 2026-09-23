The refresh is complete and pushed. Final verification confirmed the PR is clean (2 files, +160/−0, base `llm`, mergeable).

## Completion report

**Job:** refresh directive on endojs/endo-but-for-bots PR #89 (`docs(designs): propose genie-integration`).

**What the directive asked:** the maintainer's comment said a scheduler is now in progress as `@endo/reminder` (superseding the earlier scheduling designs), to look for other facets of Genie that made similar progress, and to trim the proposal down to what remains.

**What I found (research against current `origin/llm`):**
- **`@endo/genie` was retired entirely** (`42bc7d516`, 2026-08-13) — the package, its `PLAN/TODO/TADA` docs, and every subsystem the survey catalogued are gone. The PR's `designs/genie-integration.md` never existed on `llm` (this PR introduces it), and the PR base was a frozen pin (`llm-1132289`) 1271 commits behind trunk.
- **Scheduling → `@endo/reminder`**: shipped as an unconfined plugin (Phases 1–3 of `endo-reminder.md`, which supersedes `endoclaw-timer`); the daemon `interval-scheduler`/`scheduler` formula was never taken. Adoption by any consumer is still pending.
- **Pi engine → `@endo/agentry`** (`@earendil-works/pi-*`): `lal` migrated; `fae`/`jaine`/`floot` still use `@endo/lal/providers`, so that dir + `fae/src/extract-tool-calls.js` remain undeleted.
- **Memory → `EndoDirectory`/`Mount`** via `@endo/platform/fs/extended` + `@endo/agent-tools`; FTS5 `memory-index` was abandoned (platform glob/grep instead); searchable recall is now unimplemented backlog.

**What changed:**
- Rewrote `designs/genie-integration.md` from an ~880-line survey of live code into a ~155-line **retrospective** — where the three facets landed plus the residual `lal`/`fae` consolidation backlog.
- Added a `designs/README.md` index row and a dated refresh note.
- Rebased onto `llm`; dropped the prior revision's now-superseded `designs/scheduler.md` and `designs/endoclaw-timer.md` edits (trunk's `endo-reminder.md` owns scheduling).
- Moved the PR base off the frozen pin to `llm`; force-pushed `docs/design-genie-integration` (clean diff: 2 files, +160/−0, mergeable).
- Updated PR title/body, posted a reply summarizing the refresh, and 👍'd the maintainer's comment.

**Follow-ups (for the maintainer, flagged in the PR/reply):** genie's design doc was deliberately deleted from trunk with the retirement, so this re-adds it only as the trimmed reconciliation the refresh asked for — the maintainer may prefer to close rather than keep a retrospective. Substantive remaining engineering work (not this docs job): migrate `fae`/`jaine`/`floot` off `@endo/lal/providers`, adopt `@endo/reminder`, and decide the memory-recall question.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr89-refresh.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 79 tokens (3917883 cached reads)
- Output: 41549 tokens
- Cost: $5.81393925
- Wall-clock: 740s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
