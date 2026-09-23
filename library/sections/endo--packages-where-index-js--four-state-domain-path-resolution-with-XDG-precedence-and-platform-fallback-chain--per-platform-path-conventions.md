---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_path: packages/where/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
  - getting-started
genre: §endo-source-comment-fragment
cycle: 167
lane: chat
status: current
title: §Per-platform path conventions
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

| Platform | State | Cache | Socket |
|----------|-------|-------|--------|
| **POSIX (default)** | `~/.local/state/endo` | `~/.cache/endo` | `${TMPDIR}/endo-${USER}/${protocol}.sock` |
| **macOS** | `~/Library/Application Support/Endo` | `~/Library/Caches/Endo` | `~/Library/Application Support/Endo/${protocol}.sock` |
| **Windows** | `${LOCALAPPDATA}\Endo` | `${LOCALAPPDATA}\Endo` | `\\?\pipe\${USER}-Endo\${protocol}.pipe` |

§Three-naming-conventions for the directory itself:

- POSIX: §lowercase-with-dot-prefix-convention (`endo`,
  hidden dir).
- macOS: §CapitalE-with-space (`Endo`, visible in Library
  hierarchy).
- Windows: §CapitalE-backslash-path (`Endo`, visible).

§Match-the-platform's-aesthetic — §dot-hidden-on-POSIX,
§visible-named-on-macOS-and-Windows.

§Why-not-uniform-naming: §when-in-Rome. POSIX users expect
`~/.local`; macOS users expect `~/Library`; Windows users
expect `%LOCALAPPDATA%`. Forcing one convention everywhere
would §violate-platform-mental-models.
