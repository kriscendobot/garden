## Gauntlet FIX round 2: kriscendobot/minion.town PR #189

I fixed the panel's round-2 must-fix items in one follow-up commit and pushed it to the PR head (`df3f3e3..fdf8bd9`). CI is green: all 3 checks pass, and `ci-wait-merge.sh` returned 0.

**Changes, all in `designs/clip-shell-framework.md`:**
- **critic (COEP):** I removed the claim that the shell must not adopt COEP, and the planned test that would have pinned the shell's COEP. The section now says HTML's COEP navigation check looks at the child's own COEP, which the clip already sends. Any future change that adds COEP to the shell must re-run the three-engine browser suite before it ships.
- **skeptic and novice (fallback link):** New section 3.4 specifies the "Open in new tab" link that is always shown. It is the existing `#clip-open` link, and its `href` comes from `clipOrigin({id})`. It opens the clip with `noopener noreferrer` and leaves the shell's state alone. Section 3.7 adds a browser test that forces the frame to be blocked and checks the link still works.
- **decomplector and novice (#88 session locator):** The #88 locator handoff is now a deferred note. It links #88 and briefly explains what it does. It also says plainly that a shell which parses a link carrying a bearer locator receives and routes that capability. This increment frames public clip ids only, so I removed the locator tests from section 3.7 and marked open question 4 as deferred. The section 3.3 wording no longer depends on #88. This also covers the skeptic's should-fix about the #88 fragment grammar.
- **decomplector (ownership map):** I rebuilt the section 3.5 table with one owner per row (guest endpoint, browser clip origin, guest daemon, gateway), a restart/replay column, and "not applicable" where it fits. The shell is now described as starting the frame navigation, not "classifying" it, and the "commit" wording is gone.
- **copyeditor:** Fixed the malformed parenthetical.
- **pedant:** Replaced every section sign (§) in the file with "section", including ones that were already there before this PR.

**Follow-ups:** None from this stage; the gauntlet driver posts panel-3. One background CI wait hit its time limit and was stopped. I watched CI in the foreground instead, and a final `ci-wait-merge.sh` run confirmed green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1148763 cached reads)
- Output: 8957 tokens
- Cost: $0.9584526
- Wall-clock: 1608s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
