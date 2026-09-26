The PR is clean — draft, correct cross-fork head/base, exactly the five intended files.

## Completion report

**Job:** garden issue #101 (from dckc) — build a PR fixing Oros-AI/oros-ckm-data-readiness#1 (enforce *erasable TypeScript* as a static check + document it), and answer the p.s.

**What I did**
- Read both issues verbatim. The upstream issue #1 asks to adopt [`erasableSyntaxOnly`](https://www.typescriptlang.org/tsconfig/#erasableSyntaxOnly) and enforce it via a static check + CONTRIBUTING.md (mirroring the Agoric convention it links).
- The bot has only `pull` on upstream Oros-AI but owns the fork `kriscendobot/oros-ckm-data-readiness`, so this is a fork→upstream PR. dckc's directive (and the `@kriscendobot` request in issue #1 itself) authorizes opening it.
- Branched `llm-erasable-syntax-lint` off the current upstream `ckm-poc-build` tip in an isolated project worktree.

**Changes (Oros-AI/oros-ckm-data-readiness#2, draft):**
- `tsconfig.json` — add `"erasableSyntaxOnly": true`.
- `package.json` + `package-lock.json` — raise `typescript` floor `^5.4.2` → `^5.8.3` (flag needs TS ≥ 5.8; already-locked 5.9.3 satisfies it, lockfile otherwise unchanged).
- `.github/workflows/lint.yml` — **new** CI (repo had none) running `npm run typecheck` on push/PR.
- `CONTRIBUTING.md` — **new**; documents the rule, rationale, and how to run the check.
- Verified: existing sources already pass — `npm run typecheck` and `npm run build` both clean (rc 0). Guardrail, not a migration.

**Notes**
- Left as a draft per garden convention (build stops at a draft; dckc promotes/merges). The garden runs no gauntlet on this third-party upstream.
- `ensure-pr.sh` refused the floating base (frozen-base guard). Since the base repo is a third party we can't push a pinned snapshot to, and review happens directly on GitHub, I used the documented `GARDEN_ALLOW_FLOATING_BASE=1` escape hatch.

**Issue reply:** commented on garden #101 (did not close) with the PR link, a change summary, and the p.s. answer — no, fork issues need not be filed in the garden repo: an `@kriscendobot` mention anywhere (trusted sender) dispatches a builder (as issue #1's body already did), the garden auto-watches its own forks (`kriscendobot/oros-ckm-data-readiness` is already armed), and this repo's issue inbox is just the convenient allowlist-only threaded surface.

**Follow-ups:** none required; dckc reviews/merges PR #2 at their discretion.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (1999969 cached reads)
- Output: 21419 tokens
- Cost: $2.1892365000000003
- Wall-clock: 349s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
