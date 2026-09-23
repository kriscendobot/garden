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
title: §Envelope-protocol (four verbs)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

| Verb | Direction | Payload | Purpose |
|------|-----------|---------|---------|
| `"suspend"` | supervisor → worker | CAS dir path (UTF-8) | Tell worker to quiesce + snapshot |
| `"suspended"` | worker → supervisor | SHA-256 hex (UTF-8) | Worker confirms snapshot written |
| `"suspend-error"` | worker → supervisor | error message (UTF-8) | Worker cannot suspend |
| `"restore"` | supervisor → new worker | CAS file path (UTF-8) | Init verb for resume |

§Four-control-verbs-cover-the-protocol. §All-payloads-are-
UTF-8-text-paths-or-hashes — §no-binary-bytes-on-the-
envelope-bus (snapshot bytes flow through filesystem, not
envelopes).

§The-byte-stream-bypasses-the-envelope-bus. §Big-data-
through-filesystem; §small-coordination-through-envelopes.
