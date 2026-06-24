# Done: pr-ebfb-405-gamut — endo-but-for-bots#405 un-drafted

PR #405 "feat: group inventory by formula type" driven through the gauntlet to
un-draft (ready-for-review, in the maintainer's queue).

## Next-stage-owed
DRAFT, MERGEABLE/CLEAN, no panel verdict, CI green → **code panel** owed.

## Panel (code panel, 5 diverse lenses)
Disposition: **must-fix → fix → pass** (1 fixer round).

Consensus must-fix (3 of 5 seats independently): `endo list --follow --type <t>`
passed through add events lacking a `type` field (older daemons not yet
enriching `followNameChanges`), defeating the filter. Tests seat also flagged
the CLI grouping/filter logic as having zero coverage.

One panel "should-fix" was a **false positive**, confirmed by reading source:
the changeset/JSDoc claim that non-local values surface as `'remote'` is
accurate — `getTypeForId` returns `'remote'` for non-local ids
(daemon.js:1075); the `.catch(()=>undefined)` is only the genuine-error
fallback. No changeset change made.

## Fix (commit 52b30865 on feat/inventory-grouping-by-type, bot identity)
- `packages/cli/src/commands/list.js`: in `--follow`, resolve type via
  `locate()` when the event omits it and a `--type` filter is active —
  mirroring the snapshot path and the chat UI's `onTypeResolved` fallback.
  No-filter path unchanged (no extra round-trip).
- Exported `groupForType`/`INVENTORY_GROUPS`; added
  `packages/cli/test/list-grouping.test.js` (7 tests) pinning every
  formula-type→group mapping, incl. the previously-untested
  `host`/`guest`/`pet-store` Hub sub-types and unknown/undefined fall-through.

## Verification
- eslint, tsc, prettier: clean on changed files.
- New tests: 7/7 pass. (8 pre-existing CLI tests fail locally only with
  `spawn endo EACCES` — a local non-executable-bin sandbox quirk, not the
  change; CI runs them.)
- CI on the new head: **23 checks pass, 0 fail**.
- `gh pr ready 405` → `isDraft: false`.

## Follow-ups (non-blocking; should-fix/nit dispositions, not in-scope must-fix)
- `--follow --type` still emits `-name` remove events regardless of filter
  (removes carry no type) — minor stream inconsistency.
- `enrichWithType` serializes the change stream (`yield await`) — latency
  coupling on high-frequency add batches; fine for human-paced inventory ops.
- Type→group taxonomy duplicated between CLI (`list.js`) and chat
  (`tree-source.js`); a shared module would remove the sync hazard (the two
  agree today; the CLI table now carries a cross-reference comment).
- Daemon-level `followNameChanges` tests cover `directory` only at the
  component layer; `host`/`guest`/`pet-store` enrichment untested daemon-side.
