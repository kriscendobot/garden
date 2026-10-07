I applied all four of the panel's round-2 must-fix items to PR #168, pushed the fix, and CI is green: all 3 checks passed (`ci-wait-merge` returned 0).

The PR is kriscendobot/minion.town#168, branch `design/guest-oauth-bonds`. It changes only `designs/guest-oauth-bonds.md` (+105/−35), in follow-up commit `583e879`. I pushed it with `safe-push-pr-head.sh --mode advance`, which moved the head forward from `792bb4b`.

**Must-fix items:**
- **Skeptic 1 (bearer-only removal):** I kept bearer-only removal and wrote it up in § 4 as an accepted risk, with the reasoning:
  - **What removal adds:** someone holding the bearer can already add a sign-in they control. Removal only adds the power to delete the owner's other ways back.
  - **Requiring an OAuth proof of any identity already on the account** protects nothing: a thief adds their own sign-in first, then proves it.
  - **Requiring a proof of the identity being removed** would stop the owner from removing an account they have lost or that was taken over, which is when removal matters most.
  - **Mitigations already in the design:** the removal audit event, and the visible "added" dates on each row.
  - **Future option:** delayed removal with a notification, once minion.town has a way to reach the owner outside the browser.
- **Skeptic 2 (migration assumes every row has a fingerprint):**
  - **Grounding:** on `main`, `bondGuest` is the only writer, and it has set the encrypted identifier and `guest_formula_fingerprint` together in one `UpdateItem` since commit `7bfd379`.
  - **Fallback:** a row with a missing or malformed fingerprint is quarantined. The script leaves it untouched, reports it, exits non-zero, and holds the cutover. An operator then decides whether to re-derive the fingerprint or drop the row.
  - **Test 8** now covers both bad-row cases.
- **Ergonomist 1 (one object, three names):** "recovery sign-in" is now the only user-facing name.
  - `bondId` is renamed `signInId` in the routes, responses, audit events and CapTP methods.
  - The provider table header and the legacy row label ("added before 2026-10") are renamed.
  - § 1 says "bond" is internal only, and the browser check now asserts that no visible string uses it.
- **Ergonomist 2 (last-sign-in dialog):** the dialog now has **Copy this guest's URL**, with an `aria-live` "Copied" notice, above the destructive button. The state diagram and the manual browser-render check include it.

**Cheap should-fix items, also taken:**
- **Data model (decomplector):** removal is a hard delete, so I dropped `RecoveryIdentity.status`.
- **Recovery bookkeeping (decomplector):** the writes on a successful recovery are best-effort and never decide whether recovery succeeds.
- **Rate limit (critic):** pinned in this design instead of inherited from the unmerged #114.
- **Cross-reference (novice):** fixed test 11 → test 13.
- **Row-status wording (copyeditor):** reworded.

**Not taken:**
- **Pedant (YAML frontmatter, capital after a colon):** every design in minion.town uses bold metadata lines, not YAML, and the rule the pedant cited is the garden's, not this project's.
- **Remaining should-fix items:** the critic's and skeptic's concerns about relying on unmerged PRs, the extra concurrency tests, the 409 cross-guest wording, and the legacy-row remove friction are left for the round-3 panel to rule on again.

I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1089621 cached reads)
- Output: 11091 tokens
- Cost: $1.0324162000000001
- Wall-clock: 367s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
