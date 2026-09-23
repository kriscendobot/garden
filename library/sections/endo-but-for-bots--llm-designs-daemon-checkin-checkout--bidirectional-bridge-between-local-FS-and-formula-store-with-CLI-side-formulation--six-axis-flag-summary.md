---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
title: §Six-axis-flag-summary
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

| Flag | Short | Commands | Description |
|------|-------|----------|-------------|
| `--name <name>` | `-n` | `checkin` | Pet name for the root |
| `--as <agent>` | `-a` | both | Agent to act as |
| `--zip` | `-z` | both | Interpret/produce zip |
| `--stdin` | | `checkin` | Read zip from stdin |
| `--stdout` | | `checkout` | Write zip to stdout |

§Flag-orthogonality-where-possible. §-z-is-the-input-output-
mode-flag; §--stdin/--stdout-require-z; §-n-is-checkin-only.

§Short-aliases-follow-existing-conventions (-n, -a, -z) —
matches `endo store`, `endo run`, etc.
