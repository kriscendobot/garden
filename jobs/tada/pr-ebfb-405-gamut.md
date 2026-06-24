Job complete. Worktree torn down, branch deleted, and `jobs/tada/pr-ebfb-405-gamut.md` confirmed at `origin/journal2`.

---

# Completion report — pr-ebfb-405-gamut

**Result: endo-but-for-bots#405 driven through the gauntlet and un-drafted (now ready-for-review in the maintainer's queue).**

## What I did
- **Next-stage-owed:** PR was DRAFT, MERGEABLE/CLEAN, no panel verdict, CI green → the **code panel** was owed. Ran it.
- **Panel** (code panel, 5 diverse adversarial lenses: correctness, tests, security/ocap, style/changeset, API/wire-consistency). Disposition: **must-fix → fix → pass** (1 fixer round).
  - **Consensus must-fix** (3 of 5 seats, independently): `endo list --follow --type <t>` passed through add events lacking a `type` field (older daemons that don't yet enrich `followNameChanges`), silently defeating the filter.
  - Tests seat: the CLI grouping/filter logic had **zero coverage**.
  - One panel "should-fix" was a **false positive** — I verified the `'remote'` changeset/JSDoc claim is accurate (`getTypeForId` returns `'remote'` for non-local ids at daemon.js:1075; the `.catch(()=>undefined)` is only the genuine-error path). No changeset edit made.

## What changed (commit `52b30865`, bot identity, on `feat/inventory-grouping-by-type`)
- `packages/cli/src/commands/list.js`: in `--follow`, resolve the type via `locate()` when the event omits it and a `--type` filter is active — mirroring the snapshot path and the chat UI's `onTypeResolved` fallback. No-filter path unchanged (no extra round-trip).
- Exported `groupForType`/`INVENTORY_GROUPS`; added `packages/cli/test/list-grouping.test.js` (7 tests) pinning every formula-type→group mapping, including the previously-untested `host`/`guest`/`pet-store` Hub sub-types and the unknown/undefined fall-through.

## Verification
- eslint + tsc + prettier clean on changed files; 7/7 new tests pass.
- (8 pre-existing CLI tests fail *locally* only with `spawn endo EACCES` — a sandbox non-executable-bin quirk, not my change; CI exercises them.)
- **CI on the new head: 23 checks pass, 0 fail.** `gh pr ready 405` → `isDraft: false`.

## Follow-ups (non-blocking — should-fix/nit dispositions, not in-scope must-fix)
- `--follow --type` still emits `-name` remove events regardless of the filter (removes carry no type) — minor stream inconsistency.
- `enrichWithType` serializes the change stream (`yield await`) — latency coupling on high-frequency add batches; fine for human-paced inventory ops.
- Type→group taxonomy is duplicated between CLI (`list.js`) and chat (`tree-source.js`); they agree today and the CLI table now carries a cross-reference comment, but a shared module would remove the sync hazard.
- Daemon-level `followNameChanges` tests cover `directory` only at the component layer; `host`/`guest`/`pet-store` enrichment is untested daemon-side.

Job board: `jobs/tada/pr-ebfb-405-gamut.md` written; doin/work/inbox cleared; dispatch worktree torn down. Inbox was empty throughout.
