Done. The rebase is complete and verified.

## Completion report

**Job:** Rebase PR endojs/endo-but-for-bots#937 ("fix(daemon): restore XS bundle generation on llm") onto a freshly pinned snapshot of the current `llm` tip, now that endojs/endo-but-for-bots#903 has merged.

**What I did:**
- Cut a fresh frozen base `llm-0c3598a` (snapshot of `llm` tip `0c3598ada2`, the #903 merge commit) per the frozen-base-branch discipline, replacing the stale `llm-5f9ccde`.
- Rebased #937's commits onto it. The rebase surfaced that **#903 landed a refined superset of nearly all of #937** — 9 of its 10 commits become empty against the new `llm`:
  - the whole `@endo/sha256` package (llm's `sha256-endor.js` is the evolved successor of #937's `sha256-xs.js`, behind the same `xs` export condition),
  - the daemon host-tool-powers + XS-bundle injection (`host-tool-powers.js`, `bundle-bus-daemon-rust-xs.mjs`, the type-checked test),
  - platform BlobRef, chat node-crypto fold, and the design-doc updates.
  - llm's CI already runs the daemon XS bundle generation, so #937's stated "restore XS bundle generation" goal is already met on `llm`.
- The single surviving, non-superseded commit is `bundle:xs` — an npm script folding the three explicit `node …bundle….mjs` CI lines into one named script (net **+2/-3** across `package.json` + `ci.yml`). Resolved cleanly against llm's evolved CI.
- **Verified builds on the new base:** `node packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` (EXIT 0, ~2.1 MB bundle) and full `yarn bundle:xs` (all three sub-bundles, EXIT 0).

**What changed (pushed under the bot identity):**
- New branch `llm-0c3598a` on `endojs/endo-but-for-bots`.
- Force-pushed `fix/xs-bundle-llm-reconcile` → `3c866b34c5` (llm tip + the one surviving commit).
- Retargeted PR #937's base to `llm-0c3598a`. PR is **MERGEABLE**, 2 files changed, +2/-3 — a clean, interpretable diff.
- Posted a factual PR comment documenting the supersession; messaged the maintainer.
- Left the old `llm-5f9ccde` base in place (swept on PR close per convention).

**Did not** merge or request review — the rebase was the deliverable.

**Follow-up for the maintainer:** because #903 superseded the substance, #937 is now a small cosmetic refactor rather than the feature it opened as. Decision pending: keep it as the `bundle:xs` refactor, or close #937 as superseded by #903. (Messaged.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr937-rebase-onto-new-llm.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2417699 cached reads)
- Output: 34982 tokens
- Cost: $2.9841905000000004
- Wall-clock: 586s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
