CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 5 for endojs/endo-but-for-bots PR #1226 (`designs/endo-guest-stdio-mcp.md`).

**What I did:** Read the latest (round-5, must-fix) panel verdict and applied its must-fix and request-changes items once, as review-feedback follow-up commits to the PR head, then watched CI to green.

**Changes applied** (one commit `4e1696a4b` on `design/endo-guest-stdio-mcp`):
- **novice (must-fix):** Added a define-before-diagram gloss ahead of the "Division of labor" mermaid diagram, glossing `guest`, `harness`, `formula id`, `facet`, `CapTP`, and `UDS` before the boxes use them.
- **skeptic #1:** Flagged the per-guest broker-socket re-mount as a *new cross-document obligation* on `endo-claude` (DD7 covers only credential files) and `endo-posix-sandbox`, with a matching Open Question.
- **skeptic #2:** Named the `SO_PEERCRED` per-guest-uid assignment as a not-yet-committed obligation on `endo-posix-sandbox`, added an Open Question, and extended the negative-confinement test to exercise both the assigned-uid path and the degraded single-uid fallback.
- **decomplector:** Stated the argument-scope check derives from the facet's own fail-closed petstore lookup (a pre-flight call), not a second authorization table — closing the two-sources-of-truth ambiguity.
- **ergonomist #1:** Unified discriminant grammar — renamed request-time `data.reason` `name` → `name-scope` so construction and request discriminants share compound-kebab shape; added a sentence making the grammar parity explicit.
- **ergonomist #2:** Gave the minion.town reserved-name collision warning a discriminated `{ warning: 'reserved-name-collision', names }` shape.
- **copyeditor / pedant:** Expanded UDS on first use, fixed the missing preposition (`branch on … versus …`, `vs.` → `versus`), split the leading-"So" run-on.
- Added an `endo-posix-sandbox` row to the Dependencies table.

Verified no Latin shorthand, em-dashes, or typist-hostile code points in the result. Excluded an unrelated warm-cache artifact (`packages/floot/package.json`) from the commit.

**Push:** `safe-push-pr-head.sh --mode advance` advanced the head `265034f57 → 4e1696a4b`.

**CI:** `ci-wait-merge.sh … --no-merge` returned **rc 0 — CI GREEN** (7/7 checks, 0 failed). No merge performed (per `--no-merge`). Stopped here without re-running the panel; the driver re-posts panel-6.

**Follow-ups:** none for this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3399851 cached reads)
- Output: 20553 tokens
- Cost: $3.1966934999999994
- Wall-clock: 864s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
