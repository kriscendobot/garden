All five CI checks (browser-tests, build, lint, test, zizmor) pass on the pushed head `f354fa998`. CI is terminal GREEN.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #231 (`designs/familiar-release.md`, a design-doc PR).

**What I did:** Read the latest panel verdict (round 4, must-fix) on PR #231. Three seats requested changes (critic, skeptic, ergonomist); copyeditor/pedant were comment-only with should-fix nits. Applied all of them to the design doc in an isolated project checkout, then pushed as a review-feedback follow-up commit and drove CI to terminal.

**Changes (commit `f354fa998` on `design/familiar-release`):**
- **critic** — G4's Severity line now cross-references the "Platform coverage of the runtime tiers" section that elevates the `chrome-sandbox`/userns risk to Blocker-adjacent, so a reader triaging by Severity alone carries the elevation; added the missing macOS x64 end-state sentence to the MVR exit criterion; added a pre-tag manual Linux `.app` launch backstop (MVR table row) for the CI-unverified Linux launch path.
- **ergonomist** — G4's Linux remediation now gets point-of-friction delivery matching G2 (a note on the GitHub release/download page next to the `.zip`, not README-only), reflected in G4's Target and the MVR table.
- **skeptic** — flagged the "no tier drives the MVR exit criterion through the rendered Chat UI" residual with the same acknowledged-risk discipline used elsewhere; repointed G14/G16 builder-pass cross-references from Followups to the MVR table (their work is MVR, not followup); added the missing G7 icon-projection row to the Followups table.
- **copyeditor/pedant** — verbed the `xattr` command, matched the `chrome-sandbox` chmod/chown phrasing to line 270, added a colon before the ship-list appositive, split the ~85-word Linux-risk sentence, added "namely" to the weblet-flavor apposition, and normalized `follow-on`→`followup`, `in-scope`→`in scope`, `un-caught`→`uncaught`. Verified the doc stays em-dash-free and ASCII-only (I fixed one em-dash and arrow characters I had initially introduced).
- Updated the changelog "Updated" line to record the round-4 pass.

**CI:** all five checks (browser-tests, build, lint, test, zizmor) pass on head `f354fa998` — terminal GREEN.

**Follow-ups:** none for this stage. The driver re-posts panel-5 next; the panel may still flag further should-fix polish.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 102 tokens (3923634 cached reads)
- Output: 21901 tokens
- Cost: $4.308232
- Wall-clock: 499s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
