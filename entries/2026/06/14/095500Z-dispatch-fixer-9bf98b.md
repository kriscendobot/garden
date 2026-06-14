---
ts: 2026-06-14T09:55:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--9bf98b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-4492739829
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/095115Z-result-barrister-103358.md
---

# dispatch: fixer — PR #440 loop round 1 (must-fix + summary-fix + CI red)

Barrister `103358` finished first code-panel round on PR #440 (cuts 1+2+3): **3 must-fix-loop**, **5 summary-fix**, 5 follow-up, 4 acknowledge, 2 drop. Verdict: `--request-changes` (in-band fallback: posted as COMMENTED on PR; reasoning in body). The 3 must-fix-loop items share root cause with the pre-existing CI red on cut 1 (the `make-bundle` orphan). Fold all into one retcon.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`, head `888951a9f`.
- **Review body**: https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-4492739829

## Must-fix-loop items (3)

1. **`'make-bundle'` is not a real formula type.**
   - `packages/daemon/src/formula-record.js:98-103` — drop the `case 'make-bundle':` arm. Add `case 'make-archive':` (properties: `archive`, `powers`, `worker`) and `case 'make-from-tree':` (properties: `tree`, `powers`, `worker`). Verify by reading `packages/daemon/src/daemon.js:4903` (`formulateArchive`) and `daemon.js:4945` (`formulateFromTree`) to confirm property names.
   - `packages/chat/formula-view-registry.js` — drop the `make-bundle` registry entry; ensure `make-archive` / `make-from-tree` entries exist with matching `propertyList`.
   - `packages/cli/test/demo/inspect-formula.js:18` — change `stdout: /^make-bundle {2}[0-9a-f]{128}\n/u` to match `^make-archive` (or whichever the daemon actually emits per `endo make counter.js`). Verify with a manual run if needed.
   - The same fix resolves the cut-1 CI red on `packages/daemon/src/formula-record.js` TypeScript errors.

2. **`packages/cli/test/demo/inspect-formula.js` demo assertions are wrong.**
   - Re-derive every regex in this file from one end-to-end manual run of `endo inspect counter --json` so the type string and property names match what the daemon actually returns.
   - Folded into item 1's `make-bundle` → `make-archive` correction.

3. **`'keypair'` is not a formula type.**
   - `packages/chat/test/unit/formula-view-registry.test.js:13-49` — drop `'keypair'` from the `canonical` array OR add an inline comment noting it as reserved for a proposed future formula type. Recommended: drop the test's claim that `keypair` is canonical; keep the registry entry with a clear "reserved" comment.
   - `packages/chat/formula-view-registry.js:224-229` — keep entry but document as forward-looking (or drop entirely, designer's call).

## Summary-fix items (5)

4. **Registry-vs-record drift catalog**: `channel`, `timer`, `git`, `git-credential`, `git-remote`, `mount`, `scratch-mount`, `readable-tree`, `make-archive`, `make-from-tree` are real daemon types but have no `formula-record.js` case. Add at least the obvious literals (`mount.path`, `timer.intervalMs`, `git.*.path`) so daemon and chat surfaces are coherent. Per-type regression test in `formula-record.test.js`.
5. **`Object.create(null)` discipline**: `packages/chat/formula-view-registry.js:52` use `{ __proto__: null, ... }` for the REGISTRY object literal per `packages/daemon/CLAUDE.md` § Modernisms.
6. **PR body open-question 1 fix**: `formula-type.js:20` is `'known-peers-store'`, not `'make-bundle'`. Update the body to acknowledge the researcher was correct and name the daemon's actual emission (`make-archive` for `endo make counter.js`).
7. **PR body cut-3 paragraph 1**: re-phrase "covering the canonical daemon formula types plus forward-looking types" to clarify `keypair` is a user-side reservation, not a current daemon type.
8. **`valueComponent` JSDoc**: spell out back-face mount-point optionality in the `@param $parent` block (`#value-back-face`, `#value-flip-to-formula`, etc. are optional; component degrades to front-face-only when absent).

## Pre-existing CI red (fold into same retcon)

- `packages/daemon/test/endo.test.js` — prettier drift; run `yarn format` on it.
- (Item 1's fix should resolve the TypeScript errors in `formula-record.js`.)

## Task

In your `project/` worktree at `888951a9f`:

1. Read the full barrister review body (URL above).
2. Apply all 8 substantive items + the prettier fix.
3. Run `corepack yarn workspace @endo/daemon test` and `corepack yarn workspace @endo/cli test` and `corepack yarn workspace @endo/chat test` and `corepack yarn lint` to confirm everything passes.
4. Run pre-push-gates from project/.
5. Commit per logical group (suggested):
   - `fix(daemon): replace orphan make-bundle case with make-archive + make-from-tree per panel`
   - `fix(cli): update inspect-formula demo regexes to match make-archive`
   - `fix(chat): drop keypair from canonical registry test claim`
   - `feat(daemon): add per-type record cases for channel/timer/git/mount/etc. registry drift`
   - `chore(chat): use Object.create(null)-style REGISTRY map`
   - `docs(chat): document back-face mount-point optionality on valueComponent`
   - `chore(daemon): yarn format endo.test.js`
6. Update PR body (`gh pr edit`) to fix the two body items (#6, #7).
7. Push to `feat/formula-inspector` (append only).
8. Post a top-level summary comment on PR #440 at-mentioning `@kriskowal`:
   - Per-item resolution + commit SHAs.
   - Local test results.
   - Note that CI red items are folded in.

## Authorizations

- Push commits to `feat/formula-inspector` (append only).
- Edit PR body via `gh pr edit`.
- Top-level summary comment on PR #440.

## Out of scope

- Do NOT touch daemon-cas (separate PR #442).
- Do NOT touch the design (separate merged PR).
- Do NOT mark PR ready (justice will after the panel re-run).
- Do NOT re-request review.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post head SHAs.
- Per-item resolution with file:line + commit SHA mapping.
- Test results per workspace.
- pre-push-gates result.
- PR body changes.
- PR #440 summary comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: justice` for the panel re-run.

End your turn with a concise summary back to the orchestrator.
