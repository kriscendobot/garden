Both slices are landed, pushed, and green. Job complete.

---

## Completion report — Stage-5 fix5 2/5 (tagged-template + template-literal TV lexing)

**Both slices landed cleanly and pushed to `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600 stays DRAFT; no PR comment, no maintainer message).**

### Slice 1 — Tagged templates (`expressions/tagged-template`)
**Before:** 26 of 27 ENDOR-REJECTED (coder panic: "tagged template reached in control-flow coder"). **After:** 0 rejected, **27/27 byte-identical.**

Ported the tagged branch of `fxTemplateNodeCode` (`xsCode.c`) structurally into `endor-compile/src/coder.rs` (`code_tagged_template`):
- Builds the frozen template object once per call site behind a `TEMPLATE_CACHE.#<tag>` `BRANCH_COALESCE` guard: the cooked `strings` array and raw `raws` array (`length` set, each slot via `NEW_PROPERTY_AT` with the frozen `DONT_DELETE|DONT_SET` = 10 flag), `strings.raw = raws`, then `TEMPLATE` to freeze; caches under the per-site symbol and calls the tag with the object as argument 0 (`RUN_1`/`RUN_TAIL_1` in tail position).
- Added a `the->tag`-equivalent counter to `Coder` and `generate_tag()` minting `#<tag>` cache symbols (no `@path` — the oracle compiles with no sourceURL), interned at code time so atom-table IDs match XS byte-for-byte.
- Illegal-escape cooked slots emit `UNDEFINED`: threaded the lexer's `string_error` onto the cooked `String` node via a new `mxStringErrorFlag` (bit 1, `ast::flags::STRING_ERROR`) in `parser.rs`.

### Slice 2 — Template-literal TV lexing (`expressions/template-literal`)
**Before:** 13 ENDOR-ONLY-ACCEPT (endor accepted illegal escapes XS rejects; the 14 endor-rejected named in the spec were already closed on the branch tip). **After:** **0 accept-disagree**, full accept/reject agreement (41 identical, 13 oracle-rejected+endor-rejected).

Added `reject_untagged_template_cooked_error()` in `parser.rs`: an untagged template whose cooked value carries `STRING_ERROR` (truncated/illegal `\x`/`\u`, bad `\u{…}` code point/separator, or legacy octal in template position) is a SyntaxError — mirroring `fxStringNodeCode` — while a tagged template accepts the same source.

### Fixtures & invariants (all green)
- `coder_byte_identity.rs::tagged_templates` (12 pinned shapes: no/one/many substitutions, member-tag receiver dance, distinct `#0`/`#1` sites, illegal-escape `undefined` cooked, tail-position `RUN_TAIL_1`).
- `parser/tests.rs::untagged_template_illegal_escape_is_error` (7 reject cases + 3 accept cases including tag-makes-legal).
- Curated **1711/1711** byte-clean; `statements/class` and `expressions/class` byte-clean; `cargo test --workspace --test-threads=1` **EXIT=0** (0 failures); `#![forbid(unsafe_code)]` intact (diff adds no unsafe); README residual ledger updated.

**Follow-ups:** none for this child. (Note: normal single/double-quoted strings with illegal escapes are not rejected by this change — only templates; that surface, if divergent, belongs to a string-literal slice, not templates.)
