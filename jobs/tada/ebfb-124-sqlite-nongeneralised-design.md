Inbox empty; the job is complete. Final report:

Posted the follow-up design requested in kriskowal's review of `designs/daemon-endor-pet-store-sqlite.md` (PR #124, discussion r3548818899): **draft PR endojs/endo-but-for-bots#690**, branch `design/daemon-endor-sqlite-extended-surface` against `llm`, adding `designs/daemon-endor-sqlite-extended-surface.md` plus its row in `designs/README.md` § Summary.

The design scopes all five surfaces PR #124 declined to generalise, splitting them by what they actually require:

- **JSON1 / FTS5 / R-tree** need no new bindings at all — I verified against the vendored libsqlite3-sys 0.28.0 `build.rs` that rusqlite's `bundled` build (SQLite 3.45.0) compiles them in unconditionally, so they are reachable through the existing nine host functions today. The deliverable is a CI compile-options assertion and FFI round-trip tests. This directly unblocks the agent-memory FTS5 substrate (`endo-agent-tools.md` open question 5).
- **UDFs and custom collations** share a named-registry pattern: frozen, version-suffixed Rust implementations (`endo_sha512_v1`, `endo_casefold_v1`, `endo_unicode_nocase_v1`) registered per-connection by explicit host calls — no JS callbacks inside queries, since the XS FFI has no Rust→JS re-entry; the trampoline is explicitly deferred behind a named consumer.
- **Backup** gets `VACUUM INTO` as the zero-change v0, a one-shot `sqliteBackup` host function as v1, and a stepped v2 deferred with the rusqlite `Backup<'a,'b>` borrow snag documented so it isn't rediscovered.
- **`ATTACH`** is deliberately gated (`SQLITE_LIMIT_ATTACHED=0` at open) and reopened as a host-mediated grant (`sqliteAttach`/`sqliteDetach`) — a flagged capability-discipline parity break with better-sqlite3.

Open questions for the maintainer are explicit (UDF menu contents, backup pause tolerance, whether `sqliteAttach` constrains paths in the host function or the powers layer).

Follow-ups: I did not comment on PR #124 itself (inline/summary replies on maintainer-reviewed PRs require per-action authorization the job didn't carry); if a cross-link there is wanted, that's a one-line authorized act. Implementation phases 1–5 in the design are each buildable as separate jobs once the design is reviewed.
