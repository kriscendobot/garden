---
title: See also
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "1-157 (prelude + consoleLevelMethods + consoleOtherMethods + consoleOmittedProperties commented block)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The module's opening discipline: *to ensure that this module
  operates without special privilege, it should not reference the
  free variable `console` except for its own internal debugging
  purposes in the declaration of `internalDebugConsole`, which is
  normally commented out*. This is the *no-special-privilege* design
  axiom that lets the module be loaded into hardened compartments
  without inheriting any ambient logging authority. The permit lists
  enumerate the console methods this module knows how to wrap, paired
  with log severities sourced from cross-platform agreement (Whatwg
  spec + Node + MDN + TypeScript + Chrome). The
  consoleOmittedProperties commented block records the *false-entries*
  discipline: properties expected on the original console but not
  permitted on the wrapped console — *seeing these on the original
  console is expected, but seeing anything else that's outside the
  permits is surprising and should provide a diagnostic*.
parent: endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists
---

- [[hardened-javascript]] (topic) — the SES substrate; this module is one of SES's internal taming surfaces.
- [[errors]] (topic) — the broader SES error-handling system this module's *causal console* is part of.
- `endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering` — the next section: the makeLoggingConsoleKit + makeCausalConsole core including logError + extractErrorArgs + makeNoteCallback.
- `endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console` — the third section: defineCausalConsoleFromLogger (AVA t.log adapter) + filterConsole + indentAfterAllSeps kludge.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-console feeder; track-turns produces causal annotations that this console renders.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — the V8-specific stack-attenuation work; the *getStackString* this console calls comes from there.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation surface; this console handles errors that pass-style declares valid.
