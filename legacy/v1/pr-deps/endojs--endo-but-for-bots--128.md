---
repo: endojs/endo-but-for-bots
number: 128
blocked_by:
  - repo: endojs/endo-but-for-bots
    number: 160
    reason: "exo-zip / exo-unzip name pair pick lands the verb names #128 must adopt"
---

# endojs/endo-but-for-bots#128: feat(cli) assorted CLI additions

## Why this dependency

PR #128 introduces a suite of new `endo` CLI verbs including a `zip checkin` / `zip checkout` pair. The exact verb names for the zip pair are the live question on PR #160, where the maintainer is selecting between competing name pairs (`exo-zip` / `exo-unzip` and alternatives). Until #160 lands the chosen pair, #128 cannot finalize its verb names without risking a rename round after the fact.

## Source

The dependency was first surfaced inline in the bulletin by the steward at
[`entries/2026/05/13/035237Z-message-steward-dc1809.md`](../entries/2026/05/13/035237Z-message-steward-dc1809.md)
(annotating the #128 row with `depends on #160`). This dependency file graduates that duct-tape annotation to a registry entry so the journalist's topological sort can place #160 above #128 within the Milestone 3 bin without the journalist needing to parse free-text annotations.

The triggering maintainer directive lives at
[endojs/endo-but-for-bots#128#issuecomment-4437042173](https://github.com/endojs/endo-but-for-bots/pull/128#issuecomment-4437042173)
(kriskowal, 2026-05-13): *"Please make a note for the journalist that this change will next need attention after the exo-zip and exo-unzip packages are merged."*

## Lifecycle expectation

This entry retires (or gets edited to remove the `blocked_by` row) when #160 merges. The file itself stays as historical context per `journal/pr-deps/README.md` § Lifecycle.
