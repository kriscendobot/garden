CI is GREEN (rc 0). The fix is pushed and CI passes. Job complete.

## Completion report

**Stage:** FIX round 3 — endojs/endo-but-for-bots PR #1277 (`design: invitation retention labels and pin lifecycle`).

**What I did:** Read the latest panel-3 verdict (aggregate comment reconstructed from durable record; recovered the full per-seat prose from the on-disk panel rundir since the comment titles were truncated) against head `3dbce00b`, applied every must-fix and should-fix item to `designs/daemon-retention-labels.md`, pushed one follow-up commit, and watched CI to a GREEN terminal.

**Panel items addressed (commit `05d387f93`):**
- **critic + skeptic (must-fix):** the compare-and-remove was binding a public `endo://` locator against the internal `formula_id` column (never matches → `prune` always reports `changed`, Invariant 5 unimplementable). Fixed: `prune` now takes `expectedTargetId: FormulaIdentifier`; `list()` returns both `target` (locator, display) and `targetId` (internal id compared); the CLI internalizes `--expect <locator>` before the guarded `DELETE`; prose spells out the id-vs-locator distinction.
- **novice (must-fix):** Problem section now leads with the two gaps (missing metadata/lifecycle surface; late overlong-key rejection) instead of burying them behind four paragraphs of encoding detail; host/guest model defined at first use; forward-reference added to the Prompt section.
- **copyeditor (must-fix + should-fix):** "The inviter uses its best current…" corrected to `invitingAgent` (glossary contradiction); two imperative sentences recast to declarative voice; "optional additive field" tightened.
- **ergonomist (request-changes):** `list()` now returns a discriminated `{ kind: 'pins' } | { kind: 'legacy' }` so a legacy guest is distinguishable from a genuinely-empty modern guest; the `invitationRetentionPins()` accessor is reconciled against the read-only `diagnostics()` idiom (it mutates, so it stays separate); `label`/`name` identity aligned across surfaces.
- **skeptic (should-fix):** the legacy `-from-<handle-number>` suffix length check moved to `accept()` (where the handle number first exists), not `invite()`.
- **decomplector (comment-only):** `invitation`/`invitingAgent` reason fields marked may-be-collected at the type.
- **pedant (should-fix):** two en-dashes replaced with ASCII hyphens; also cleaned an ellipsis I briefly introduced.

**Result:** pushed `3dbce00b..05d387f93` to `endojs/design/daemon-retention-labels` via `safe-push-pr-head.sh` (advance mode). CI terminal GREEN — 29 checks, 0 failed (7 success, 22 skipped). Only the design doc was committed; a yarn-install artifact in `packages/floot/package.json` was reverted and untracked test fixtures left unstaged.

**Follow-ups:** none. Per the stage contract I did not re-run the panel; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1277-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 116 tokens (5132530 cached reads)
- Output: 39076 tokens
- Cost: $4.668043
- Wall-clock: 1251s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
