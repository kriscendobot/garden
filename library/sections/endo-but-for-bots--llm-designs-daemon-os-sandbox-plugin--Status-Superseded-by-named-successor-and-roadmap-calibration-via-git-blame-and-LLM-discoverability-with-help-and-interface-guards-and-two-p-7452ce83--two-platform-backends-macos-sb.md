---
title: §Two-platform-backends (macOS SBPL + Linux bwrap+seccomp)
source-slug: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin
section-id: Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-os-sandbox-plugin.md
authors: [Kris Kowal (prompted), Joshua T Corbin (revised)]
repo: endojs/endo-but-for-bots
path: designs/daemon-os-sandbox-plugin.md
total-lines: 544
status: Superseded by endo-posix-sandbox (2026-05-07)
ingest-cycle: 228
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
---

§Two-named-backends with §a-table-mapping-endowments-to-platform-rules per backend:

```
| Endowment | SBPL rules |
|---|---|
| `fs[].mode === 'read'` | `(allow file-read* (subpath "<path>"))` |
| `fs[].mode === 'read-write'` | `(allow file-read* file-write* (subpath "<path>"))` |
| `net.allowOutbound` | `(allow network-outbound)` with SBPL ip/port filters |
| ... |

| Endowment | bwrap flags |
|---|---|
| `fs[].mode === 'read'` | `--ro-bind <path> <mountAt>` |
| `fs[].mode === 'read-write'` | `--bind <path> <mountAt>` |
| `net.allowOutbound \|\| net.allowInbound` | `--share-net` (default is `--unshare-net`) |
| ... |
```

§Borrowable-pattern: §endowment-to-platform-rule-mapping-table-per-backend. §The-mapping-IS-the-implementation-contract — §the-table-defines-what-the-platform-backend-must-emit.

§Sibling to cycle 226 endoclaw-cluster's §uniform-shape-with-pluggable-fields — cycle 226 is a §uniform-handler-interface; cycle 228 is a §uniform-mapping-table-per-backend.
