Round 4 of the review panel on endojs/endo-but-for-bots#1355 finished normally and returned **must-fix**. The verdict is posted on the PR.

**Run**
- I checked out the PR head `a4511c64fe` (branch `design/hardened-url-shim-status-reconciliation`, on the endojs repo) in an isolated worktree for this job.
- I ran `panel.sh` in single-round mode against the base commit `47f6965d88` (`llm-47f6965`). It exited 0 with `design-panel single-round — must-fix`. All 9 design seats reported ok. Seven approved or left comments only; the ergonomist and pedant asked for changes.

**Must-fix items**
1. **ergonomist:** the `## Design` body of `designs/hardened-url-shim.md` still uses the old option name `urlBlobMethods`. That includes a copy-pasteable `lockdown({ urlBlobMethods: 'remove' })` example at line 176 and prose at lines 180, 186, 245, 333, 387, 402-403, 489, 500 and 532. The option that shipped is `urlBlobTaming`, and lockdown silently ignores unknown keys, so copying the example would quietly do nothing. The fix is to rename it in the body, or add a pointer to the Status section wherever the old name appears.
2. **pedant:** in the Status section, the list item "documentation and a changeset; and" has an extra "and" in a semicolon-separated bullet list. The capitalization of the "resolved" markers is also inconsistent.

**Review posted:** GitHub won't let the bot request changes on its own PR, so the review went up as a COMMENTED review at 2026-09-30T10:33:16Z. It opens with "Disposition: must-fix" and the two items, followed by every seat's findings.

**Duplicated aggregate:** the panel output `round-1.md` held each seat's findings twice. I started the panel once, killed it within seconds to relaunch it so its exit code would be captured, and the killed run's seats appear to have kept writing into the same run directory. The two copies differed only in the skeptic's verdict (comment-only vs. approve). I posted the copy that matches the current seat files, where the skeptic approves. The final disposition doesn't depend on which copy is used.

I made no garden commits. Per the stage contract I did no fixing and did not un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 74 tokens (2043772 cached reads)
- Output: 11007 tokens
- Cost: $1.5408063999999997
- Wall-clock: 2000s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
