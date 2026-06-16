---
title: Test coverage matrix
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances
---

| Test | What it validates |
|---|---|
| Right-click home shows Edit not Delete | Context-menu scope system |
| Right-click regular space shows both | Scope system for delible spaces |
| Edit home modal omits Name field | `showName: false` behavior |
| Change home icon/scheme stores correctly | Store at `['spaces', '0']` with enforced name/path |
| Home loads stored icon/scheme on refresh | Merge from stored config |

The matrix is **one row per design invariant** — every constraint
in the design has a corresponding test, and every test maps back to
one constraint. The 1:1 mapping is the testing-discipline
counterpart of the modeline-completeness invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] —
*every property has a visible affordance for verification*.
