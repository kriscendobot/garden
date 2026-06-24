---
title: See also
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "159-415 (makeLoggingConsoleKit + pumpLogToConsole + makeCausalConsole + logError + ErrorInfo)"
topics: [hardened-javascript, errors]
status: current
parent: endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering
---

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the broader SES error-handling surface.
- `endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists` — the first section in this source: the no-special-privilege axiom + permit lists this section uses.
- `endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console` — the third section: AVA t.log adapter + filter console.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the track-turns module that *produces* the notes this section renders via `takeNoteLogArgsArray`. Track-turns annotates; this console renders the annotations.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns` (cycle 93) — the `getStackString` capability this section calls comes from there. The two cycles together describe the full *stack-attenuation-plus-rendering* pipeline.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation; this console handles errors that pass-style validates.
