---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-14T23:26:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Migrate `@endo/slots` deliver bodies to the OCapN calling convention

Repo: https://github.com/endojs/endo-but-for-bots
Origin: https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3726366231

After https://github.com/endojs/endo-but-for-bots/pull/124 resolves, refactor `@endo/slots` so `deliver` carries one flat passable argument vector. Function application sends its arguments unchanged. String-named JavaScript method invocation prepends `passableSymbolForName(method)`; symbol-named methods remain unreachable and are rejected. Remove the `__call__` sentinel and the `[method, args]` body.

On receipt, mirror `@endo/ocapn`: local object Exos validate and decode the leading selector, then dispatch the corresponding string method; function Exos receive the complete argument vector through `applyFunction`. Preserve descriptor translation and reply semantics. Decide and document separately whether the existing `__get__` convention remains private or needs a distinct OCapN operation.

Ground truth: `packages/ocapn/docs/cbor-encoding.md` Body Content Format, `packages/ocapn/src/client/ocapn.js`, and `packages/ocapn/src/selector.js`.

Acceptance:

- Codec tests pin flat arguments and passable-selector encoding.
- End-to-end tests cover `E(object).method(value)`, `E(function)(value)`, send-only variants, malformed or non-selector object calls, and symbol-method rejection.
- No `__call__` or `[method, args]` wire shape remains.
- The `@endo/slots` README cites the OCapN Body Content Format.
- Add a breaking changeset, or document why the unreleased surface needs none.
- Run the `@endo/slots` JavaScript tests and Rust slots tests.
