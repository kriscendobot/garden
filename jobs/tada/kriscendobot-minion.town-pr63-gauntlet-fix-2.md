Fix stage complete. CI green.

## Completion report

**Stage:** FIX round 2 of the `kriscendobot-minion.town-pr63-gauntlet`, PR #63 (`docs(weblet): reconcile register-by-id design`), a docs-only PR touching `designs/weblet-ocap-synthesis.md`.

**What I did:** Read the panel-2 request-changes verdict (a design panel: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice; disposition must-fix) and applied every must-fix item in one review-feedback follow-up commit (`435d6c1`), pushed to the PR head via `safe-push-pr-head.sh` (advanced `ae28e8a..435d6c1`).

**Changes applied:**
- **critic / skeptic** — Reframed the caller-creation residual: its content-plane instance is **live in production today** (PR #55), not a future `back`-only concern. Restated it as a reachability/confidentiality escalation (not authority amplification), and re-tagged every § 9 residual as *live-vs-not-yet-built*.
- **decomplector** — Named the `register` (capability-structural) vs `weblet_list`/`weblet_unpublish` (identity-ACL) authority asymmetry in §§ 5 and 8, tracked as a residual in § 9 (dropped the incorrect "same shape" claim). Promoted `contentRoot` into the persisted record shape (`hash -> { directoryId, owner, contentRoot }`) with the identity-vs-served-value regime distinction.
- **skeptic** — Added a partial-failure-of-the-evaluate paragraph in § 3.1 (orphaned pet name, no gateway cleanup by design, no half-pinned record).
- **novice** — Glossed "owner-pinned" at first use; distinguished guest-scope `@agent` (self-denotes) from the dangerous Host-scope `@agent`; split the dense § 2.2 paragraph.
- **ergonomist** — Marked § 3.1 pre-substituted literals (`hash`/`frontTree`/`backPetName`) vs bound names; stated why list/unregister are excluded from the one-method `sites` facet.
- **copyeditor / pedant** — Removed all 45 em-dashes (period/colon/parens per em-dash-style) and all 3 Unicode arrows (`->`); added the missing serial comma; fixed "one that another guest", "the fixed evaluate source" (×3), and "the evaluate call". Verified zero offending code points remain (also confirmed no curly quotes/ellipsis/en-dashes).

**Result:** Fix pushed; CI terminal GREEN (rc 0). Mermaid block and all section headers intact. I did **not** re-run the panel (the driver re-posts panel-3). Comment-only notes (citation-form drift, verification-artifact pointer) were left unaddressed as non-blocking.

**Follow-ups:** none for this stage; the substantive residuals (caller-creation binding fix, `weblet_upgrade`, list/unpublish structural rework) are now documented as tracked open work in the design, not this PR's scope.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr63-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1535386 cached reads)
- Output: 41849 tokens
- Cost: $2.8154659999999994
- Wall-clock: 595s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
