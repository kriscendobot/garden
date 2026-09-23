Inbox empty. No code change was warranted — this was an "attention" directive routing to a maintainer question, which I answered on-thread.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #475 — erights asked whether `@endo/bytes`' exported `compareBytes` (a bytewise-lexicographic compare over genuine `Uint8Array`s) could be switched to shortlex, to match the shortlex decision for `rankCompare`/`encode-passable` and lower system-wide cognitive overhead.

**What I did:** Investigated rather than blindly changing. Findings:
- `compareBytes` is **new in this very PR** (`packages/bytes/src/compare.js`; not on master) — so this is the "outstanding PR" erights had in mind.
- There **is** a concrete reason for bytewise-lexicographic: `compareBytes` is the OCapN/Syrup **wire-interop primitive**, and three spec-mandated consumers require octet/bytewise ordering — Syrup dictionary keys ("bytewise sorted order", read-side-validated), OcapnStruct fields (same), and OCapN session-id derivation (peer IDs sorted "based on their octets"). On unequal-length inputs shortlex ≠ lexicographic, so switching would diverge from the wire spec and break interop with other OCapN implementations.
- The marshal `byteArray` rank path is **unaffected either way**: `rankOrder.js` does its own shortlex length pre-check and only delegates the equal-length tie-break to `compareBytes`, where the two orderings coincide — so `encode-passable`/`compareRank` stay shortlex regardless.

**Routing/outcome:** Posted a grounded inline reply on erights' thread (https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3503095938) confirming shortlex stays for rank/encode-passable, explaining the OCapN wire reason `compareBytes` must remain bytewise, and offering two overhead-reducing paths that don't break interop: (1) keep but rename/document it as the bytewise/octet OCapN primitive, or (2) relocate it out of `@endo/bytes` into the OCapN/Syrup layer. Deferred the choice to erights/kriskowal/gibson042 (all @-mentioned), offering to land either in this PR.

**No commits/pushes** — switching semantics would break Syrup/OCapN interop, and the keep-vs-relocate choice is a maintainer design decision, not a mechanical fix. PR-scoped comms went via the PR thread, not the maintainer inbox.

**Follow-up:** If maintainers pick a path, a builder/fixer job on PR #475 would carry it out (doc/rename, or move the compare into the OCapN layer + repoint its consumers).
