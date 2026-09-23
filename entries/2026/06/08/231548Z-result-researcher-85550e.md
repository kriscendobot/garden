---
ts: 2026-06-08T23:15:48Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/researcher--85550e
refs:
  - entries/2026/06/07/043800Z-dispatch-fixer-a538e1.md
  - entries/2026/06/07/050114Z-result-fixer-a538e1.md
  - entries/2026/06/07/050400Z-result-steward-426-chain.md
---

# result: researcher — builder brief for bot-fork master eslint-warning cleanup

The proposed builder dispatch opens a PR on the bot fork's `master`
branch that addresses every eslint warning currently surfacing
workspace-wide, with one commit per category-of-warning-that-befits-
an-equivalent-solution. The refinement below grounds the brief in the
known destructive-autofix hazard (fixer `a538e1`'s 2026-06-07 lesson
on `@endo/harden-exports` deleting `harden()` calls and
`jsdoc/require-param` injecting empty `@param` lines), the bot fork's
frozen-base discipline, the `chore: Update yarn.lock` separation
convention, and the project README's "every commenter is maintainer-
equivalent" routing for any review feedback that follows. The
library has no concept page for "destructive autofix"; the canonical
record remains the fixer `a538e1` result entry, which the refinement
cites directly.

## Refinement to inline into the builder dispatch

```markdown
## Library and project references

### Library concepts and sections

- [`skills/frozen-base-branch/SKILL.md`](../../skills/frozen-base-branch/SKILL.md) — every fork-side PR opens against a `<base>-<short-sha>` snapshot, not directly against `master`. Use `master-<sha7>` here; the snapshot lives on `kriscendobot/endo-but-for-bots`.
- [`skills/yarn-lock-separate-commit/SKILL.md`](../../skills/yarn-lock-separate-commit/SKILL.md) — every `yarn.lock` change ships in its own `chore: Update yarn.lock` commit, after the per-category source commits. Not "drag in with the last commit".
- [`skills/pre-push-gates/SKILL.md`](../../skills/pre-push-gates/SKILL.md) — the gate the builder runs before every push. Stage 2's `yarn lint --fix` is the *general* auto-fix; this PR is specifically about its workspace-wide effects and which subset to actually take.
- [`skills/changeset-discipline/SKILL.md`](../../skills/changeset-discipline/SKILL.md) — lint-warning cleanup is not user-observable; no `.changeset/*.md` for any of the per-category commits. The PR body's `[Documentation]` line says "no changeset (internal hygiene)".

### Project context (endo-but-for-bots)

- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md) § Rules of engagement — bot fork's roadmap branch is `llm`; **implementation base is `master`** (per the design/implementation split). This PR is master-based, so it does not pass through `llm` and is eligible for upstream ferry once green.
- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md) § Standing authorizations — the garden may comment, review, and reactji on this repo without per-action authorization in the dispatch prompt. The PR open and the body are inherent to the builder's job.
- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md) § Authority structure — every commenter on `endojs/endo-but-for-bots` is treated as maintainer-equivalent; a `CHANGES_REQUESTED` review from any commenter routes through the standard fixer chain.

### Prior precedent (the load-bearing lesson)

- [`journal/entries/2026/06/07/050114Z-result-fixer-a538e1.md`](../../../journal/entries/2026/06/07/050114Z-result-fixer-a538e1.md) — fixer `a538e1`'s scope decision on PR #426. **Workspace-wide `corepack yarn lint:eslint --fix` cascades into destructive non-numeric edits via two rules the builder must AVOID:**
  - **`@endo/harden-exports`** *deletes* `harden(...)` calls on named-export module-level constants. The project's `CLAUDE.md` § Hardened JavaScript (SES) Conventions makes `harden(exportName)` after every named export MANDATORY; the autofix violates the rule. Concrete example from `a538e1`: `packages/chat/browser-tree.js` lost three `harden(...)` lines when the workspace-wide autofix ran.
  - **`jsdoc/require-param`** injects empty `@param <name>` lines lacking descriptions. The project's pre-PR checklist favors substantive JSDoc; the autofix output would still want a follow-up edit, so taking the raw autofix is worse than not taking it.
- [`journal/entries/2026/06/07/050400Z-result-steward-426-chain.md`](../../../journal/entries/2026/06/07/050400Z-result-steward-426-chain.md) — the steward's chain-summary of the `a538e1` lesson plus the *verify by content not `--stat`* rule for any "run `--fix` workspace-wide" recipe (`git diff -U0 | grep -E '^[+-]' | grep -vE '^[+-]{3}|^[+-][ \t]*[0-9a-fA-F_xn,]+'`).

### Why each reference is relevant

- *frozen-base-branch* — master-based PR still uses the frozen-base convention; open against `master-<sha7>`, not `master`.
- *yarn-lock-separate-commit* — the per-category split should never combine source edits with `yarn.lock` churn even if a rule's autofix happens to update transitive deps.
- *pre-push-gates* — stage 2's `yarn lint --fix` is broad; this PR explicitly takes a narrower selective approach (per-rule, per-file) because the broad form is destructive.
- *changeset-discipline* — lint cleanup is internal hygiene; no changeset.
- *project README rules of engagement* — confirms master-base is the correct target for this PR (implementations land on `master`, designs on `llm`).
- *project README standing authorizations* — the PR open and body do not need per-action authorization on this repo.
- *project README authority structure* — any subsequent review comes through the standard fixer/judge chain regardless of commenter.
- *fixer `a538e1` result* — the destructive-autofix shape the builder must explicitly NOT trigger. Take the safe subset of warning categories; for `@endo/harden-exports` and `jsdoc/require-param`, either skip entirely or hand-curate per-file edits with the rule disabled in the autofix invocation.
- *steward `426-chain` result* — the content-diff verification recipe; run before each per-category commit to confirm the diff is purely the category's intent.

### Operational shape for "commit per category"

The fixer `a538e1` precedent suggests the safe per-category form is `eslint --fix --no-eslintrc --rule '{"<rule>": [...]}' --plugin <plugin> ...` against an explicit file list, not workspace-wide with the full ruleset. The builder then commits each category as a focused `style:` or `chore:` commit:

- `style: apply unicorn/numeric-separators-style autofix` (precedent: PR #426's `9cfaec9c`)
- `style: apply <rule> autofix` per safe category
- For destructive-autofix rules (`@endo/harden-exports`, `jsdoc/require-param`), either skip the category or write a separate commit doing the hand-curated equivalent that respects the project's `harden()` mandate and JSDoc substantiveness expectation.

Prettier may need a follow-up pass after underscore insertions or other reformatting that changes line widths (precedent: `a538e1` re-ran Prettier on 4 files); fold that into the same per-category commit when it is clearly a downstream consequence of the rule's autofix, or as its own `style: prettier reflow after <rule>` commit when more substantial.

### Open questions

- The library does not carry a concept page for "destructive autofix" or for the specific rules `@endo/harden-exports` / `jsdoc/require-param`. The fixer `a538e1` result is currently the only journal record. A scholar pass to draft a concept page (or at minimum, a `pre-push-gates` *Pitfalls* row) would benefit future builders and fixers. This refinement adds a keyword shortcut to `journal/library/keywords.md` pointing at the `a538e1` entry; a fuller concept page is out of researcher scope.
- The brief mentions "every eslint warning" but the workspace currently surfaces ~2167 warnings (per `a538e1`'s post-fix verification). The builder should enumerate the categories first (`yarn lint:eslint 2>&1 | grep -oE '@?[a-z@/-]+/[a-z-]+$' | sort -u`) and budget the PR's scope before attempting any. A PR addressing every category in one engagement is likely too large; the builder may want to scope to the N highest-count safe categories.
```

## Library writeback

Added two keyword shortcuts to `journal/library/keywords.md` so the next researcher (or builder, fixer, designer) hits the destructive-autofix lesson via grep rather than having to re-walk recent fixer entries:

- `destructive-autofix | (see entry: entries/2026/06/07/050114Z-result-fixer-a538e1.md)` — points at the fixer `a538e1` result entry which carries the canonical evidence.
- `@endo/harden-exports autofix deletes harden() | (see entry: entries/2026/06/07/050114Z-result-fixer-a538e1.md)` — narrows to the specific rule + its destructive behavior.
- `jsdoc/require-param autofix injects empty @param | (see entry: entries/2026/06/07/050114Z-result-fixer-a538e1.md)` — narrows to the second rule.

No concept page drafted: the term is load-bearing but the canonical material lives in a journal entry, not a library section file, and drafting a concept page from a single source entry would risk freezing one engagement's framing as gospel. Routing the *grow a concept page* item as a self-improvement message to liaison.

## Open questions

- A "destructive autofix" concept page (or a `skills/pre-push-gates/SKILL.md` *Pitfalls* row enumerating known rules) would compound across future builder/fixer engagements. The librarian or gardener picks this up on a later pass.
- The library's coverage of project-specific lint conventions (the `harden(exportName)` mandate from the project `CLAUDE.md`, the `@import` JSDoc preference, etc.) is thin. A scholar pass over the bot fork's `CLAUDE.md` to extract a *project lint conventions* section file would be valuable.

Self-improvement: surfaced two routing items to liaison (destructive-autofix concept page + project-lint-conventions section). Added three keyword shortcuts during this engagement.
