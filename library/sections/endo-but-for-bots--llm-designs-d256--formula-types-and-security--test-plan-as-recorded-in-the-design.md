---
title: Test plan (as recorded in the design)
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-d256--formula-types-and-security
---

1. **Unit tests for crypto functions**: `randomHex256()` returns
   64-char hex; `makeSha256()` produces correct digests;
   `generateEd25519Keypair()` returns valid keypairs.
2. **Validation tests**: `isValidNumber()` accepts 64-char hex,
   rejects 128-char; `parseId()` correctly parses new format;
   `formatId()` produces valid identifiers.
3. **Integration tests**: fresh daemon starts with 256-bit
   identifiers; formula storage uses new path format; content
   addressing uses SHA-256; locators parse correctly; keypair JSON
   files appear in test state directories; agents have `@keypair` in
   their special names.
4. **Cross-package tests**: CLI commands handle new identifier
   format; chat displays identifiers correctly.
