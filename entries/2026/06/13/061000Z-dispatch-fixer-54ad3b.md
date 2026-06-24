---
ts: 2026-06-13T06:10:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--54ad3b
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4697693153
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/055100Z-result-fixer-89bfcd.md
---

# dispatch: fixer — append targeted-casts + ts-expect-error for type incompatibilities on PR #5

Maintainer directive on PR #5 (kriskowal at 2026-06-13T06:05:26Z,
issue comment `4697693153`):

> @kriscendobot Rather than a dedicated PR, please append fixes
> for the latent type incompatibilities with targeted casts. It
> is acceptable to add `ts-expect-error` annotations, with the
> reason why they are necessary, if a type issue cannot
> otherwise be addressed.

The 👀 reactji is on the directive comment.

## Context

Prior fixer `89bfcd` bumped `@endo/*` + `ses` to latest npm
versions on PR #5 (head now `be7c0ec4ff`). That bump surfaced
**36 type errors across 9 workspaces** (async-flow, ERTP,
SwingSet, governance, internal, network, orchestration, vats,
zone) — same shape as the prior `35c18254e4 fix(types)` commit
but ~10× scope.

Now the maintainer wants those addressed **inline on this PR**
(not a separate PR), via:
- **Targeted casts** (`x as Type`) at call sites.
- **`@ts-expect-error` annotations** with reason comments
  where targeted casts aren't enough.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `be7c0ec4ff748c6edb10d17bee24c9c7022ecdd3` (`be7c0ec4ff`).

## Task

In your `project/` worktree on
`mirror/12527-endo-sync-refresh` at `be7c0ec4ff`:

1. **Enumerate the 36 type errors**:
   `corepack yarn workspace @agoric/async-flow lint:types`
   (and the other 8 workspaces). Capture the error file:line
   list. Group by file.
2. **For each error**:
   - Prefer the **targeted cast** approach. Identify the
     value at the call site whose inferred type is too
     narrow/wide; add `(x as Type)` or
     `/** @type {Type} */(x)` (JSDoc form for JS files).
     Choose the narrowest cast that satisfies the type
     checker.
   - If a targeted cast cannot resolve the issue (e.g., a
     deep structural incompatibility in a third-party
     boundary), use `@ts-expect-error` with a reason
     comment: `// @ts-expect-error <one-sentence reason>`.
     The reason must explain WHY the cast isn't tractable.
3. **Reference the prior `35c18254e4 fix(types)` commit** as
   precedent for the shape of the fix.
4. **Commit per workspace** OR one commit total — designer's
   call based on the diff size. Conventional commit prefix:
   `fix(types): targeted casts for @endo/* bump per kriskowal
   review` (or per workspace if split).
5. **Run** `corepack yarn lint:types` across the 9
   workspaces to verify clean.
6. **Run pre-push-gates** (the bot doesn't run them on
   agoric-sdk by default; skip if not applicable).
7. **Force-with-lease push** to
   `mirror/12527-endo-sync-refresh` with lease anchor
   `be7c0ec4ff748c6edb10d17bee24c9c7022ecdd3`.
8. **Reply on the directive comment** (`4697693153`)
   at-mentioning `@kriskowal`:
   - Per-workspace summary (how many errors, how many casts
     vs how many ts-expect-error).
   - The reasoning shape used (e.g., "X errors are
     `Map<K, V>` covariance mismatches at WeakStore
     boundaries; Y errors are `Passable`-vs-concrete-type
     in marshal").
   - First-look CI state.
9. **Re-request review** from kriskowal once CI shows green
   (or escalate if substantial breakage).

## Authorizations (per-action, forwarded by liaison)

- **Force-with-lease push** to
  `mirror/12527-endo-sync-refresh` with lease anchor
  `be7c0ec4ff748c6edb10d17bee24c9c7022ecdd3` (full 40-char
  SHA).
- **Top-level comment + directive reply** on PR #5.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT do the structural type refactor (the maintainer
  explicitly accepted `ts-expect-error` as a valid escape
  hatch).
- Do NOT split into a separate PR.
- Do NOT rebase the base.
- Do NOT touch other workspaces unless their lint:types
  is affected.

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Pre/post head SHAs.
- Per-workspace error count → cast count + ts-expect-error
  count.
- Sample of the cast/annotation shapes used.
- `yarn lint:types` post-push result.
- The directive reply URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: shepherd` if CI still
  needs watching; `next: none` if green.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
