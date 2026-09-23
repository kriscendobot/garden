CI is GREEN. All fixes applied, pushed, and verified.

## Completion report

**Job:** Gauntlet FIX round 5 — endojs/endo-but-for-bots PR #231 (`designs/familiar-release.md`, MVR release-plan design).

**Panel verdict applied (round-5 review at 2026-08-31T13:06:46Z):** I applied the ergonomist must-fix plus the concrete request-changes findings from decomplector, pedant, and novice, and the should-fix items from skeptic and copyeditor. One commit (`09fb85c78`), pushed to the PR head via `safe-push-pr-head.sh` (advance mode, `f354fa998..09fb85c78`).

Changes:
- **G11 (ergonomist, must-fix):** Named the credential-entry error-visibility residual — a first turn that fails on a mistyped host/token/model surfaces only as a failed turn in Chat, with no CI tier driving a failed turn through the rendered UI — as an explicit acknowledged-risk residual, matching the G9 and Linux-launch residuals.
- **G4 (decomplector):** Trimmed the `**Severity:**` field back to a bare `Important (Linux)` rating and moved the Blocker-adjacent cross-reference to a new `**Note:**` line.
- **G4 (skeptic):** Corrected the Linux userns claim to distinguish upstream kernel default from distro security policy; named Ubuntu 23.10+/24.04 AppArmor userns mediation and Debian's `unprivileged_userns_clone=0`, and pinned the pre-tag manual-launch backstop (prose + MVR table) to Ubuntu.
- **G2 (novice):** Made the `Resolved by` pointer terminate accurately at Open Q2 instead of looping back to G2.
- **Gaps intro (novice):** Dropped the unused four-category taxonomy; glossed the builder/designer/gardener "pass" terms once.
- **MVR table (copyeditor, pedant):** Recast the Node-pin and pre-tag-launch rows as imperatives.
- **Prose nits:** Split the overloaded Tier 0/2 sentence, de-double-negatived the macOS x64 sentence, added the `e.g.,` comma, unified `M1`→`Milestone 1`, and trimmed the accreted Updated-cell changelog to the bare date.

Verified no em-dashes / curly punctuation slipped in. CI watched to terminal: **GREEN** (5/5 checks, 0 failed, rc 0).

Per stage instructions, I did **not** re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2581730 cached reads)
- Output: 20621 tokens
- Cost: $2.619297
- Wall-clock: 756s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
