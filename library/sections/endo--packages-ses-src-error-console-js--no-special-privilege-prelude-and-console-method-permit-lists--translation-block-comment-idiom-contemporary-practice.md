---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `// const internalDebugConsole = console;` (commented out) | The visible-but-inactive debug-hook pattern; production never references; debugging can uncomment. |
| `consoleLevelMethods` + `consoleOtherMethods` permit lists | The standard *enumerate-what-we-support* permit-list discipline. |
| `(fmt?, ...args)` style detection | Cross-platform sprintf-ish formatter behavior; first arg may be format string. |
| `we currently do not detect these and may never` | Honest-known-limit; no commitment to fix; documented for future maintainers. |
| `false-entries-in-SES-permits` (in consoleOmittedProperties) | Three-category allowlist: permitted, expected-but-omitted, surprising. |
| `defineName` for arrow-function naming | Explicit `name` property setting; supports tooling that uses `.name` for stack traces. |
