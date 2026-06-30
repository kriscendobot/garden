# endo-but-for-bots PR #405 — rebase, retcon, conduct (maintainer directive)

**Repo:** `endojs/endo-but-for-bots` (bot has direct push; bot identity).
**PR:** https://github.com/endojs/endo-but-for-bots/pull/405 — *feat: group inventory by formula type*
- author kriscendobot; **reviewDecision: APPROVED** by kriskowal.
- head `endojs:feat/inventory-grouping-by-type` → base **`llm-a1dcc70`** (a frozen/pinned base — honor the frozen-base-branch discipline).
- currently MERGEABLE / CLEAN.

**Maintainer directive** (kriskowal, 2026-06-30T03:05Z, comment 4839488122):
> Please rebase, retcon, and conduct.

Run the compound chain **in order**, each stage gating the next:

1. **Rebase** (`skills/rebase-*` / weaver) — rebase the head branch onto the current
   tip of its base `llm-a1dcc70` (frozen-base discipline; do NOT silently retarget to
   plain `llm`), resolving any conflicts. Force-push-with-lease.
2. **Retcon** (`skills/retcon`) — reset the branch and restage cleanly: per-package
   commits, a **separate `chore: Update yarn.lock`** commit, implementation+tests
   combined, **net diff invariant** (the tree must be identical to pre-retcon). Force-push.
3. **Conduct** (conductor role) — merge the PR. **Do not name the merge method**;
   the conductor's canonical norm chooses it. Conduct only **after** the rebase+retcon
   are pushed and CI is green on the rewritten branch.

**After merge:** post a top-level **summary comment** on the PR (final merged SHA +
what the rebase/retcon changed structurally + CI/verification), per the
PR-summary-comment norm — not just silent force-pushes.

Scope: all artifacts on `endojs/endo-but-for-bots`; bot identity; no upstream-of-endo links.
