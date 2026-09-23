CI is green (rc 0). All must-fix items applied, pushed, CI terminal green.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1083 gauntlet FIX round 4 — a design-docs PR (`designs/npm-registry-as-directory-tree.md`, `designs/README.md`, `designs/registry-capability.md`).

**Panel disposition addressed:** must-fix (7 request-changes seats + 2 should-fix items). One follow-up commit (`77d437be4`) pushed to the PR head `design/npm-registry-as-directory-tree` on `kriscendobot/endo-but-for-bots`.

**Fixes applied:**
- **critic** — stated per-backend where the shared `resolveRegistryTree` runs (Endor: inside the XS engine, colocated with the tree Exos), and rewrote the self-referential locality claim; identified the *concrete* silently-regressing refactor the same-vat-dispatch test guards against (worker-side construction consuming `@registry` as an `E()`-wrapped Presence) and confirmed the platform's own invariants would not surface it loudly.
- **skeptic / ergonomist** — gave `getInfo().temporal` a home as a registry-node facet layered above the guard (not the shared `readableTreeMethodGuards`, preserving the source-compat claim), and specified `temporal` for all four node kinds via a table (`'stable'` root, `'live'` hubs, `'live'` package dir, `'immutable'` leaf); made the deprecated adapter split scoped single-string names and added a scoped compat test case.
- **ergonomist / decomplector** — disambiguated the `@registry` re-incarnation (unconditionally the new tree; the deprecated adapter is a separately-named capability) and documented external-holder loud-failure behavior for stale two-string calls.
- **novice** — added forward pointers for `resolveRegistryTree` and the shared filesystem vocabulary.
- **copyeditor / pedant** — fixed the sentence-final missing complement ("behave as if it had no `list`"), the `…`→`...` code-span ellipsis, `npmrc`→`.npmrc` citation form (3 sites), and the two new README em-dash placeholder cells (repeated Created date / `n/a`). Verified I introduced **zero** new em-dashes in the main doc (which had none) after replacing my own with parenthetical/comma punctuation.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 — 5/5 checks, 0 failed, CI GREEN. Not merged (per `--no-merge`); panel re-run is the driver's job (panel-5).

**Follow-ups:** none. decomplector's comment-only item (whether the slash-bearing-segment diagnostic belongs in the wire protocol vs a client-side wrapper) was left as-is — it's a comment-only optional, not a must-fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1083-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4306833 cached reads)
- Output: 33410 tokens
- Cost: $4.0207635
- Wall-clock: 903s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
