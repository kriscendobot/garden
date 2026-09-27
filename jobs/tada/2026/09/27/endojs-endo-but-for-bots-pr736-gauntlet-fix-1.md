# Gauntlet FIX round 1: endojs/endo-but-for-bots PR #736 (`design/endo-ls-json`)

I applied the round-1 panel findings, rebased the PR onto its base, and CI is green (31 checks, 0 failed).

**Findings addressed** (the review had no must-fix items, only should-fix; commit "docs(designs): address endo-ls-json panel round 1"):
- **skeptic:** The Compatibility section now lists every flag combination that works today and will start failing. The main one is `--follow --json --type`, which currently succeeds and streams every event. It also covers `--follow --json --verbose/--grouped` and `--json --verbose/--grouped`.
- **skeptic:** The verification plan now includes a test on a directory reached through an `EndoMount`. The rationale for rejecting `--type` in follow mode now explains why text mode's "filter additions, pass removals through" behavior shouldn't be copied into JSON.
- **critic:** Added a note that plain text `--follow` already ignores `--verbose` and `--grouped` without saying so, and that this design leaves that unchanged.
- **ergonomist:**
  - The implementation section now specifies `JSON.stringify(names, null, 2)`, matching `inspect`, `paths` and `trace`.
  - All five option conflicts use one shared helper and one message shape: `endo ls: --<a> cannot be combined with --<b>`. The message goes to stderr with a nonzero exit, and it sets the pattern for other commands.
- **decomplector:** The open question about `--jsonl` now explains why it isn't added in this PR.
- **novice:** Added a "Prior discussion" subsection summarizing PR #658 and the maintainer's closing comment, and briefly explaining `EndoMount` and "name hub". I checked that summary against the actual PR and comment first, and corrected my first draft, which had described #658 wrongly.
- **copyeditor / pedant:**
  - Title-cased the "User-Facing Contract" heading and added an `**Updated**` row.
  - Split the "matches … convention" sentence, dropped "additive", and changed "string pet name" to "pet-name string".
  - Rewrote the README roadmap row as a noun phrase to match its neighbors.

**Rebase:** The first CI wait returned rc 3 because the PR conflicted with `llm`, so CI couldn't start. I rebased onto current `ebfb/llm`. The only conflict was the milestone summary table in `designs/README.md`; I kept `llm`'s rows and added `endo-ls-json` to M9 (13 → 14), which takes the total from 65 to 66. I then pushed with `safe-push-pr-head.sh --mode rewrite`, a force-push that refuses to overwrite newer commits on the branch (b16db0d36a → 2e83d3ba1d). Prettier passes on the design file.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 11 minutes. The PR only changes design docs, so most code jobs were skipped rather than run.

**Follow-ups:** None. The driver re-posts panel round 2. I couldn't check my inbox because the journal clone timed out while offline.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr736-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 42 tokens (1364838 cached reads)
- Output: 9023 tokens
- Cost: $1.0133796
- Wall-clock: 1014s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
