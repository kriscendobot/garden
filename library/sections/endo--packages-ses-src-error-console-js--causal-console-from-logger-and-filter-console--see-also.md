---
title: See also
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "417-541 (defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole)"
topics: [hardened-javascript, errors, testing]
status: current
parent: endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console
---

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the broader error-handling surface.
- [[testing]] (topic) — the AVA adapter pattern in this section is testing-infrastructure.
- `endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists` — the first section in this source: the permit lists this section's `consoleMethodPermits` filter and `consoleLevelMethods` / `consoleOtherMethods` consume.
- `endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering` — the second section: the makeCausalConsole core that this section's `defineCausalConsoleFromLogger` invokes.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the track-turns module that feeds causal annotations into this section's pipeline.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — the *getStackString* capability the causal console renders.
- `endo--pkg-ses-ava-readme--*` — the `@endo/ses-ava` AVA-integration package that consumes `defineCausalConsoleFromLogger`.
