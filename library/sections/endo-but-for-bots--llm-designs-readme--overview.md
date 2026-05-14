---
title: Overview (Last updated 2026-05-11 + recently-added designs)
source: designs/README.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 510630411ebc26a6d9327928b4d71e5155802ea4
source_date: 2026-05-09
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, agent-conventions]
status: current
notes: The list of recently-added designs is itself a useful change-log surface. Several of them bridge directly into library material from cycles 38-40 (trust-on-first-bind, retention-path-notation, cli-http-client) or are queued (hardened-url-shim, filesystem-watchers). The "Last updated" date is the canonical freshness signal.
---

> Abstract: The frame for the design corpus. **Last updated 2026-05-11**. The overview names recently-added designs as a change log: `daemon-make-archive` (2026-04-23), `filesystem-watchers` (2026-05-07), `endo-posix-sandbox` (2026-05-07; mirrors `PLAN/endo_posix_sandbox.md` for roadmap calibration), `exo-zip-package` (2026-05-08; PR #128 reshape blocker), `trust-on-first-bind` (2026-05-08; shared capability-policy adapter; addendum to PR #144 HttpClient), `break-dev-dependency-cycles` (2026-05-11; PR #121 follow-up; synthetic test-package factoring), `cli-http-client` (2026-05-09; PR #144 design revision under `endo http` subcommand tree), `endo-gateway` (2026-05-10; per-host system-service HTTP virtual host for OCapN; closes issue #173, unblocks PR #134), `retention-path-notation` (2026-05-10; PR #151 row-format unblocker; sibling of `daemon-retention-paths`), `cli-store-verb-text-modes` (2026-05-08; PR #128 reshape blocker), `unhandled-rejection-display` (2026-05-10; closes issue #171), `cli-edit-verb` (2026-05-08; sibling of PR #153; hashline patches for AI agents).

# Endo Design Documents

*Last updated: 2026-05-11*

*See also: `daemon-make-archive` (added 2026-04-23), `filesystem-watchers` (added 2026-05-07), `endo-posix-sandbox` (added 2026-05-07; mirrors `PLAN/endo_posix_sandbox.md` for roadmap calibration), `exo-zip-package` (added 2026-05-08; PR #128 reshape blocker), `trust-on-first-bind` (added 2026-05-08; shared capability-policy adapter referenced by HTTP client and browser controller designs; addendum to PR #144 HttpClient), `break-dev-dependency-cycles` (added 2026-05-11; synthetic test-package factoring to retire the workspace devDep SCC; follow-up to PR #121), `cli-http-client` (added 2026-05-09; PR #144 design revision under `endo http` subcommand tree), `endo-gateway` (added 2026-05-10; per-host system-service HTTP virtual host for OCapN, lifts hosting out of per-user Daemon; closes issue #173, unblocks PR #134), `retention-path-notation` (added 2026-05-10; PR #151 row-format unblocker; sibling of `daemon-retention-paths`), `cli-store-verb-text-modes` (added 2026-05-08; reshape blocker for PR #128), `unhandled-rejection-display` (added 2026-05-10; closes issue #171), `cli-edit-verb` (added 2026-05-08; sibling of PR #153 `cli-store-verb-text-modes`; hashline patches for AI agents).*

Source: [designs/README.md](https://github.com/endojs/endo-but-for-bots/blob/510630411ebc26a6d9327928b4d71e5155802ea4/designs/README.md) at commit `51063041` on branch `llm`.
