# Reconstruct endo-but-for-bots #474 (retire function-keyword) on CURRENT upstream master → new PR, retcon, shepherd
Repo: **endojs/endo-but-for-bots** (bot direct push; bot identity). Base: **`master`** (the upstream
endojs/endo mirror). **Never** push to / comment on upstream endojs/endo — the eventual upstream ferry is
a separate boatman step; all artifacts on the fork.
**Source:** PR #474 — *refactor: retire function-keyword in favor of arrow/method syntax per erights
review* (https://github.com/endojs/endo-but-for-bots/pull/474) — **MERGED**, head `chore/retire-function-
keyword`, base `master`. It converted `function`-keyword usages to arrow/method syntax across many
packages and established `docs/house-style/function-keyword.md`.
**Task — reconstruct on CURRENT upstream master (not a cherry-pick):**
1. **Sync** endo-but-for-bots `master` to the **current upstream endojs/endo master** (the standard
   sync-bot-master-to-upstream step), and branch off it (e.g. `chore/retire-function-keyword-v2`).
2. **RE-APPLY the transformation to the CURRENT tree** — do NOT cherry-pick #474's old commits; the
   codebase has evolved (files changed, new files with fresh `function`-keyword usages). Follow #474's
   approach, the **`docs/house-style/function-keyword.md`** convention it established, and erights' review:
   convert `function`-keyword declarations/expressions to arrow / concise-method syntax across the current
   codebase (respecting the documented exceptions — e.g. where `function` is genuinely required). Ensure
   the house-style doc is present/current.
3. **Open a NEW PR** on endo-but-for-bots (base `master`), titled/descibed to note it reconstructs #474 on
   current master (link the fork #474 — a fork ref, fine).
4. **Retcon** the new PR (`skills/retcon`): clean restage — per-package commits, a separate
   `chore: Update yarn.lock` if the lockfile moves, implementation+tests combined, net-diff-invariant;
   force-push-with-lease.
5. **Shepherd** CI to green (escalate to a fixer for any real breakage the transform introduces; the
   `function`→arrow change can shift `this`/hoisting semantics — watch for that).
Run local-verify (format/lint/build/test) before relying on CI. Post a **summary comment** on the new PR
(scope, how it differs from the merged #474, verification). Bot fork; no upstream endojs/endo contact.

---
claim:
  host: endolinbot2
  gardener: 50
  claimed_at: 2026-07-01T19:51:04Z
