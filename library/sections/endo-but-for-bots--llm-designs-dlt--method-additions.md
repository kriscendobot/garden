---
title: Method additions — existing signatures unchanged, new methods for hints
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, agent-conventions]
status: current
kind: index
section_count: 3
---

The strict invariant is: **no existing method signatures change.**
Every current method continues to take and return what it does today;
two methods get richer return-value content (extra fields the caller
may ignore); two new methods are added for the hint-bearing paths.

Sections:

- [Low-level (`locator.js`, `formula-identifier.js`)](endo-but-for-bots--llm-designs-dlt--method-additions--low-level-locator-js-formula-identifier-js.md)
- [High-level (`NameHub`, `EndoAgent`, `EndoHost`)](endo-but-for-bots--llm-designs-dlt--method-additions--high-level-namehub-endoagent-endohost.md)
- [Invitation methods (`EndoHost`)](endo-but-for-bots--llm-designs-dlt--method-additions--invitation-methods-endohost.md)
