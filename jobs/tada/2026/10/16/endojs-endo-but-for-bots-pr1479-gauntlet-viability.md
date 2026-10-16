**Gauntlet viability: endojs/endo-but-for-bots PR #1479. Result: proceed.**

PR #1479 is a docs-only draft opened today (2026-10-16T18:59Z). It marks `designs/ocapn-tcp-syrup-framing.md` Complete, records what actually shipped, and corrects the M4 milestone row in `designs/README.md`. Its base is the frozen `llm-61cd656`, and live `llm` has no commits ahead of that base. The PR is open and unmerged.

Deciding question: Does `llm` still show the stale "Not Started" status and the never-built `tcp+syrups` text that this PR fixes, with no other open or landed change already fixing them?

Evidence:
- **The problem the PR fixes is still on `llm`:**
  - `designs/ocapn-tcp-syrup-framing.md` still says **Status: Not Started**. Its last commit is 598cfb479f, a rename on 2026-08-09.
  - `designs/README.md` line 1191 still says `@endo/syrups` on a distinct `tcp+syrups` netlayer identifier. Line 1912 still says `@endo/syrups` package, new `tcp+syrups` netlayer.
- **The PR's claims about shipped code are true on `llm`:**
  - `packages/syrup-frame` exists, named `@endo/syrup-frame`.
  - `packages/ocapn/src/netlayers/tcp-test-only.js` defaults `framing` to `'syrup'`, with `'none'` kept for the Python test suite.
  - `packages/ocapn/test/netlayer-tcp-syrup.test.js` exists.
- **Nothing newer replaces it.** The only overlapping PR is #741 (opened 2026-07-15). #741 is older and edits the old `designs/ocapn-tcp-syrups-framing.md` path, which no longer exists after the rename. So #1479 is the newer fix, not the one that's been replaced. Nothing else on `llm` touches this design's status.

No clean, panel, fix, CI-wait or un-draft budget was spent, and nothing was changed.

Follow-up: once #1479 lands, #741 is probably obsolete and the maintainer could close it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1479-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172412 cached reads)
- Output: 1775 tokens
- Cost: $0.4214144000000001
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
