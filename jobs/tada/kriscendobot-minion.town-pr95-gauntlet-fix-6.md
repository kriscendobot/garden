CI is green (rc 0). The fix stage succeeded.

## Completion report

Applied the design panel's round-6 (must-fix disposition) items to `designs/mcp-guest-surface-documentation.md` on PR #95 (kriscendobot/minion.town), a docs/design-only PR. This is one FIX stage of the gauntlet; I did not re-run the panel.

**What changed** (one commit, `51a77aa`, pushed to the PR head `design/minion-town-guest-surface-documentation`):

- **ergonomist must-fix** — reconciled the `readText` not-found / `has` pre-check guidance with §1's TOCTOU refusal for `remove`: added a passage naming the two as *consistent* (the surface never advertises an atomicity it can't hold, but a caller may still opt into a racy best-effort `has` check with the race made explicit).
- **novice + copyeditor must-fix** — removed the dangling "an earlier draft named" / "an earlier framing" self-references so the UTF-16-code-unit-vs-code-point note is self-contained.
- **decomplector (request-changes)** — replaced the unsound "third copy" argument with the concrete enforcement-tier reason: length is a by-reference scalar (`.max(MAX_PET_NAME_LENGTH)`) mechanically mirrored, whereas the character grammar would require re-authoring the rule as a regex (a second independent encoding that can drift).
- **critic (should-fix)** — pinned the `remove` far-error match to the exact literal prefix `Formula does not exist for pet name`, and named both the too-narrow (drift) and too-broad (swallow a different daemon failure → false `✅ removed`) failure modes.
- **ergonomist + critic (should-fix)** — named the `has` boolean-vs-prose ergonomic tradeoff explicitly.
- **ergonomist + skeptic (should-fix)** — trimmed the proposed `send` description to a minimal one-clause recovery pointer; moved the full invite/accept recipe out of the tool description into the design body/companion design.
- **skeptic (should-fix)** — added a defense of idempotent-remove as the *desired* contract (owner-owned namespace, ensure-absent ergonomics, two of three implementations already idempotent), and added per-child journal provenance (`jobs/tada/<base>`) so the campaign classification is auditable.
- **copyeditor + pedant (should-fix)** — reworded the "them"/"moves who"/"two halves"/"Neither party" sites, grouped the three build files into two named halves, standardized "JSON Schema" hyphenation, and glossed "far-error" at first use.
- Kept the document em-dash-free (converting the em-dashes I introduced to colons/parentheses/semicolons) to preserve the style the pedant explicitly confirmed.

Committed only the design file with an explicit pathspec; reverted a stray `package-lock.json` change from the warm-cache install.

**CI:** GREEN (`ci-wait-merge.sh` rc 0 — the single `test (typecheck + vitest)` check passed on the new head).

**Follow-ups:** none for this stage. The gauntlet driver re-posts the panel (panel-7) to re-review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr95-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (4943082 cached reads)
- Output: 33803 tokens
- Cost: $4.268351
- Wall-clock: 557s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
