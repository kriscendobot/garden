Both commits are pushed to `origin/xs2rust-endor`. The PR was never touched (stays DRAFT; no comments, no maintainer messages). Final state verified. Here is my report.

---

## Completion report: stage-5 fix3 2/5 — Class β private-member installation bytes

**Worked on** PR #600 `endojs/endo-but-for-bots` branch `xs2rust-endor` (kept **DRAFT**; no PR comment, no maintainer message). Oracle pinned at `48ee02d8`. Isolated project checkout, hard-synced to `origin/xs2rust-endor` tip (child 1 Class α had already landed).

### Landed — sub-shape 1: accessor-pair brand double-capture (CLOSED)

**Commit `4305c946d0`** — `endor-coder: share the private-accessor-pair brand closure (Class β)`.

A `get #x`/`set #x` pair resolved to **two distinct `symbolAccess` captures** in the synthesized field-init function, so it `RESERVE`/`RETRIEVE`/`STORE`d one extra brand slot (the extra `store_1` at op idx 128 in `inst-private-name-common.js`; oracle 373 / endor 375). XS's `fxScopeLookup` matches `symbolAccess` by **symbol pointer**, resolving both members to the first class-scope declare, and the field function's `fxScopeGetDeclareNode` dedups the use-closure — so the brand is captured **once**. Ported that by deduping the brand cap **by private name** in `code_field_init_function` (each member's `valueAccess` stays a distinct per-member cap). Confirmed byte-identical via a full disassembly diff.

- **Closed ~25 `private-accessor-name/*` divergences**: `statements/class` divergent **100 → 75**; `expressions/class` fell correspondingly (**57**).
- **Byte-identity fixture added**: `class_private_accessor_pair_shares_brand` (`coder_byte_identity.rs`) — minimal pair, pair-with-body, getter-only/setter-only (no dedup), two independent pairs, pair interleaved with a private data field + method, named/static-mixed shapes.

**Commit `946372a598`** — README residual-ledger update recording the closure and naming the two remaining sub-shapes with their root cause and fix design.

### Bars (measured at the pushed tip)

| Bar | Result |
|---|---|
| Curated corpora (`compile-diff`) | **1711/1711 identical, divergent=0, endor-rejected=0, accept-disagree=0** ✓ |
| `statements/class` | 75 divergent (was 100), **endor-rejected=0, accept-disagree=0** ✓ (no new divergence/reject introduced) |
| `expressions/class` | 57 divergent, endor-rejected=0, accept-disagree=0 ✓ |
| `cargo test --workspace -- --test-threads=1` | **EXIT=0** ✓ |
| `#![forbid(unsafe_code)]` | intact ✓ |

### Not closed — sub-shapes 2 & 3 (honest remainder, ~30 files)

Both share **one scoper-structural root cause**: endor synthesizes the member-closure field-init function at *code* time, rather than binding the field initializers inside a real `instanceInit` **function scope** the way XS does. So the initializers' frame is not isolated and their private-brand reads do not resolve to captured retrieve-slots:

- **Nested-class private-member scope count** (`private-*-on-nested-class`, ~26 files): a nested class declaring private members leaks its closure slots into the enclosing frame, over-counting a program `RESERVE` (operand-only, `0x0d` vs `0x09`).
- **Field-initializer private-brand read index** (`privatefield{get,set}-typeerror-1`, `{get,set}-access-of-*-private-*`): a `this.#x` read in a field initializer codes `GET_PRIVATE` with the class-scope brand index instead of the field function's retrieve-slot (`get_private 05` vs `01`).

I **attempted a bounded low-risk shortcut** (isolating the initializer values' bind-time frame without a real field scope), measured it, and found it *exposed* new field-function `RESERVE`/index divergences (the value frame genuinely must be counted **in** the field function, not zeroed) — so I **reverted it cleanly**. The correct fix is unifying the member-closure field-init path with the plain-data-field `instanceInit` function scope (bind every instance initializer inside it; capture `symbolAccess`/`valueAccess`/`atAccess` as use-closure aliases). That is a single larger scoper+coder fold with real regression surface against the byte-clean class corpora — the same "interleaved captures / separate fold" the fix2 sibling deferred. It exceeds a safe one-invocation change, so I landed the clean slice and documented the fold rather than risk a half-migration. No silent mis-emit was introduced; the remaining files stay as already-attributed divergences.

### Follow-up
Unify the private/computed-member field-init path onto a real `instanceInit` function scope (extends the existing `class_field_init_inst` `fi` mechanism to private/computed members). Closing that fold resolves **both** residual Class β sub-shapes together and would also subsume the accessor-pair dedup naturally.
