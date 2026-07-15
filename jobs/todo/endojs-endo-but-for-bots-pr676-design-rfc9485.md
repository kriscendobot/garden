# Design revision for PR #676

Amend the existing draft design PR #676 on `design/conservative-regexp-subset` against `llm`. Do not open a replacement PR.

A maintainer-directed pivot requires the design to use the RFC 9485 safe-subset direction associated with Endo issue 3079: fully parse each regexp, validate that its syntax is in the safe subset, and, when the JavaScript implementation is present, delegate matching to the underlying JavaScript regexp engine. Treat the JavaScript implementation as a ponyfill and as the foundation for extensive shared tests that remain fixed for a native Rust implementation. Design an import/build condition such as `-C endor` that omits the JavaScript implementation from the import graph.

Read `designs/CLAUDE.md`, preserve project conventions, cite the relevant RFC sections, and record unresolved design choices as questions. Commit and push the amended existing branch. Post the authorized top-level completion summary to PR #676 with the addressing SHA and real verification evidence.

This is plain design work, not web-frontend work.
