---
source: designs/daemon-xs-worker-snapshot.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md
source_path: designs/daemon-xs-worker-snapshot.md
source_branch: llm
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
  - patterns
genre: §endo-but-for-bots-design
cycle: 178
lane: designs
status: current
title: §Append-only-callback-table (Decision 6)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> *New host functions are always appended. The signature
> changes when the table changes.*

§Stable-indices-across-suspend-resume: §the-snapshot's-
embedded-callback-indices-must-point-to-the-same-functions-
on-restore.

§Append-only-discipline: §new-functions-go-at-the-end;
§existing-indices-never-change.

§Within-a-single-binary: §same-binary-same-registration-
order = §identical-table = §signature-match.

§Cross-version: §signature-mismatch = §fxReadSnapshot-
fails-loudly. §No-silent-corruption.

§Sibling-to-cycle-175's-pin-on-first-install: §once-an-
index-is-assigned-it-cannot-change.
