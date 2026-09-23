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
title: §Two-init-paths (the bootstrap branch)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

```ts
type InitVerb = "init" | "restore"
```

§Worker-startup-branches-on-init-verb:
- `"init"`: §normal-bootstrap (XS shared cluster, register
  worker I/O host functions, eval host aliases, bootstrap
  SES, install base64, eval program).
- `"restore"`: §stream-restore-from-CAS-file; §skip-the-
  bootstrap-steps; §only-re-establish-the-context-pointer.

§The-snapshot-already-contains-all-globals after step 9 of
the cycle 176 bootstrap sequence. §Restored-machines-skip-
steps-4-and-6-through-9.

§Same-entry-point-two-code-paths. §Sibling-to-cycle-159's
§debug-flag-as-one-new-verb pattern: §encode-the-mode-in-
the-init-envelope.
