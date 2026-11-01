# Botanist report: endojs/endo-but-for-bots#1631 (Dependabot `all-minor-patch` group, 23 bumps)

**Verdict: escalated to a fixer (`next: fixer`), not yet MERGE-NOW.** The PR stays open on purpose. Every supply-chain check passes; what blocks it is a test-harness regression that ava 8.1 introduces, and fixing it needs a project decision.

## Supply-chain checks
- **Supersession:** nothing supersedes this PR. No other open Dependabot PR moves the same packages, and the base `llm` was behind on every headline package.
- **Lockfile:** the PR moves 101 resolutions and removes 93.
  - Four packages are new to the tree: `@es-joy/escodegen`, `@es-joy/estraverse`, `marked-cjk-friendly` and `word-wrap`. They are explained and licensed MIT or BSD.
  - No license changed.
  - No moved version was under 24h old when the PR opened.
  - Publishers match each package's long-standing maintainer or npm trusted publishing.
- **Maturity floor:** 2026-10-31T18:44:36Z, taken from `unist-util-visit@5.2.0` (the freshest moved version). It has already passed.
- **Advisories:** OSV, GHSA and `yarn npm audit` show none on any incoming or outgoing moved version. The audit hits that remain are on js-yaml 3.x/4.x and picomatch 2.x/4.0.2, which this PR doesn't move.
- **Install:** done with scripts disabled.
- **Source read:** I diffed 16 high-risk packages and ava, and found no new process-spawn, network or eval sites. core-js's `postinstall` is byte-identical between versions.
- **Prose gate:** the classifier was unavailable (`TYPESAFE_API_KEY absent`, so `proceed_unclassified`). I also read the Dependabot PR body before running it through the gate; it was handled as untrusted data, and I read no upstream changelogs.

## Changes pushed to the PR head
1. **Commit `401fd7c0f`:** ava 8.1 now resets `regex.lastIndex` before every match, which throws on a regex frozen by `harden()`. That broke six table-driven tests (exo-git, sandbox, codex-sandbox, and three in opencode-sandbox). Each assertion now gets a writable copy via `new RegExp(message)`. All six pass locally, and the sandbox `cover` legs went green on CI.
2. **Rebase onto `llm` `4ae452c59`:** #1635 merged and left the PR conflicting.
   - The manifest conflicts were adjacent lines; I kept #1635's unicorn `^79` alongside this PR's jsdoc and typescript-eslint versions.
   - I rebuilt yarn.lock with a three-way merge so it moves exactly the same 101 versions. A plain re-resolve would have pulled in releases newer than the maturity floor.
   - `yarn install --immutable` passes.

## What still blocks it
- **New regression:** the `@endo/claude-sandbox` mcp-bridge "socket server relays" test fails intermittently. It times out, then hits `Cannot find module 'lodash/isLength'`.
  - Runs of that file: ava 8.0.1 passes 8 of 8, ava 8.1.2 passes 4 of 8, and ava 8.1.2 with its new lazy concordance load made eager passes 8 of 8.
  - The cause is ava 8.1's lazy `require('concordance')`. ava 8.3.0 still loads lazily.
  - The fix needs a choice (a project workaround or holding ava back), so it went to a fixer.
- **Not a blocker:** the macOS `restore-context` "Uncaught exception" also happens on an unrelated branch still on ava 8.0.1, so it was already flaky.

## Jobs and records
- **Fixer job `endojs-endo-but-for-bots-pr1631-ava-lazy-concordance`:** carries the full diagnosis and repair options.
- **Comment job `endojs-endo-but-for-bots-pr1631-botanist-comment`:** pinned to endolin, because this host's token gets a 403 when commenting on endojs. It posts the structured position comment, which is not yet on the PR.
- **Ledger:** entry `entries/2026/11/01/233041Z-message-botanist-9badc4.md` records the escalation, the floor, and when to recheck.
- **Recheck:** the daily `dependabotany-recheck-endo-but-for-bots` heartbeat already exists and will re-evaluate #1631. Once the fixer's repair is green and the moved set is unchanged, the verdict becomes MERGE-NOW through `ci-wait-merge.sh --dependabot-auto-merge`.

No garden (main2) changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1631-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 62 tokens (6200132 cached reads)
- Output: 22796 tokens
- Cost: $6.207902800000002 (1 engagement(s) unpriced)
- Wall-clock: 8891s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
