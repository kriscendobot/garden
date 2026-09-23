Design job complete. PR endojs/endo-but-for-bots#665 (draft, base `llm`) carries the design.

**What I did:**
- Authored `designs/release-automation-major-bump-exports-trigger.md` (the exact slug the in-flight exports-extensionless-migration design, PR #663, names as its "to be filed" follow-up) on branch `design/release-automation-major-bump-exports-trigger`, and opened draft PR **#665** against `llm`.
- The design specifies a deterministic, non-blocking, LLM-free CI notice: a dependency-free script (`scripts/check-major-bump-exports-notice.mjs`) that, on a PR adding a `major` changeset, enumerates the target package's `exports` keys that are removable-on-major (`./K.js` with a deep-equal extensionless sibling `./K`, the compat aliases migration pass 1 leaves), and surfaces them as `::notice` check annotations plus a step-summary table. Key decisions: a second detection surface on the changesets "Version Packages" PR (version diffs, since that PR consumes the changesets) so the reminder survives to the last gate before tags; diff-scoped changeset detection so a pending major elsewhere never spams unrelated PRs; annotations instead of a comment (zero write permissions); exit 0 on findings by construction; deep-equality guard makes it self-quieting after the cleanup ships; the pair enumeration is a helper shared with the migration's gate A.
- Synced `designs/README.md`: summary-table row, M2 (Project Hygiene) row plus reopen note, per-design estimate (S, 1-2 days), milestone totals, timeline, recently-added and last-updated headers.
- Journaled the result (`entries/2026/07/10/072826Z-result-gardener-f1712c.md`).

**Follow-ups:**
- PR #665 and PR #663 both edit the M2 regions of `designs/README.md`; whichever merges second needs a mechanical reconciliation (M2 count 1 → 2). The design-file cross-link in #665 resolves once #663 lands.
- Implementation is future builder work and is inert until migration pass 1 creates dual-key packages; un-drafting #665 is the maintainer's call.

Not verified in CI: this is a design-only PR; the check it specifies is not yet built.

Self-improvement: nothing this time.
