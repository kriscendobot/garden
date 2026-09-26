PR #600 remains DRAFT/OPEN; inbox empty. The job is complete.

## Completion report

**Job:** Stage-10p child 1 — AT-key RegExp `lastIndex` WRONG-completion (PR #600, `xs2rust-endor`, `endojs/endo-but-for-bots`).

**Reproduced first (dual-run against the 8.3.1 oracle, pin `23b4d6b0`):**
- The finding `var re=/x/; re['lastIndex']=3; re.lastIndex` → oracle `3`, endor `0` (silent stale read).
- Root cause split into three layers: the AT-key WRITE fell through to `instance_put` (missing the `regexps` side table); the AT-key READ used `instance_get` (wrong `undefined`); and `resolve_at_key` honest-skipped (`Unsupported("at")`) any RegExp side-table name that was only ever a computed string, since it couldn't prove a boot default-key absent off `RegExp.prototype`.

**Fix (`rust/engine/endor-vm/src/interp.rs`):**
1. Shared one `regexp_named_get` between the dot (`re.k`) and computed (`re[k]`) READ paths — `lastIndex` reads the side table, `source`/`flags` mint a string, per-flag getters read `code[0]`.
2. Routed the AT-key `lastIndex` WRITE into the same side-table store as the dot form, honoring `Object.freeze`'s non-writable stamp identically (sloppy write ignored; strict self-names).
3. Taught `resolve_at_key` (via `regexp_reachable_default_key`) that a RegExp's `lastIndex`/`source`/`flags`/per-flag-getter names are reachable.
4. Routed by **name** (`key_id_name`), not by the cached program-relative ids, so a purely-computed key (runtime-interned past the program-symbol range) resolves the same as a program symbol. Removed the now-redundant `RegExpGetterIds` struct + `regexp_flag_bit_for` (replaced by name-keyed `regexp_flag_bit_for_name`) — the shared helper means dot and AT can't drift.

**Gate:** new `regexp_computed_property_at.rs` (3 tests) — write-then-dot-read, dot-write-then-computed-read, computed-write-then-`exec`/`test`, freeze coherence, and the source/flags/per-flag getters. All pass (fail on the unfixed engine). `in`/`delete`/pure-computed-method corners remain honest skips (acceptable).

**Bars at the pushed tip (`f6a17fdbfe`):** workspace **949/0** (grew from 943); corpora compile-diff **1909/1909 identical + SYMB 1909/1909**; boot **30/0**; **0 non-oracle warnings**; no new `unsafe`; extended the existing `regexps` side table (no new one).

**Pushed** `3028c313f5..f6a17fdbfe` to `xs2rust-endor` (clean CAS, first attempt). PR #600 kept **DRAFT**.

**Follow-up (ledgered, not fixed — a separate increment):** `re.lastIndex` is a plain data property in XS; assignment stores the value verbatim and `ToLength` applies only inside `exec`. endor coerces+clamps at assignment on **both** the dot and AT paths, so a direct read after a negative/fractional/non-numeric write diverges (`re.lastIndex=-5; re.lastIndex` → oracle `-5`, endor `0`). Pre-existing, dot-path-shared, invisible through `exec`; full fidelity needs the side table to store an arbitrary slot.

**Caveat:** the ROOT (repo-root) bar was not freshly rebuilt — `rust/engine` is `exclude`d from the root workspace and no ROOT member depends on it (invariant by construction), and the root's `xsnap` crate can't compile in this ephemeral worktree without the gitignored SES boot bundle (a yarn/`@endo/bundle-source` step, node_modules/yarn absent) the engine README documents as out of scope.
