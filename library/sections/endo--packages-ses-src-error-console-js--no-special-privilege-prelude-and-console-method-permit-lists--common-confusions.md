---
title: Common confusions
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

- **"Reference `globalThis.console` directly."** Would defeat the no-special-privilege axiom. The wrapping code receives `baseConsole` as a parameter; that parameter may be the realm's `console`, a captured AVA `t.log`, a remote daemon connection, or a no-op. The module must work regardless.
- **"The permit list is too restrictive."** It is *cross-platform-conservative*: methods documented across multiple standards are permitted. A method only in Chrome (e.g. `console.memory`) is omitted because it doesn't generalize. Users who need Chrome-specific behavior can reach for the ambient `console` outside SES.
- **"The TS-typed-vs-runtime mismatch is a bug."** It is a *runtime-truth-over-static-type* observation. The wrapping code follows the runtime behavior of `dirxml`/`group`/`groupCollapsed` (which accept `fmt?, ...args` in practice), regardless of how TypeScript types them. The comments document the discrepancy.
- **"`consoleOmittedProperties` being commented-out is dead code."** It is *aspirational documentation*. If the wrapping logic ever needs to differentiate *expected-but-omitted* from *surprising-extra*, this list becomes the runtime data. Until then, it lives as a comment for the maintainer's reference.
- **"`@@toStringTag` is just a JavaScript thing."** It is — and Chrome and Safari disagree on its value (Chrome: `"Object"`; Safari: `"Console"`). The omission is the canonical case where engines diverge on a sometimes-symbol property; SES omits to avoid the discrepancy.
- **"`internalDebugConsole = console` would just be code rot."** It is *deliberately preserved* as commented-out documentation that the debug-hook exists. A maintainer debugging the module can uncomment it temporarily. The line is not *expected* to run in production.
- **"We don't detect errors-in-arrays — that's a bug."** It is an *honest-known-limit* — the comment says *In theory we should do a deep inspection ... We currently do not detect these and may never*. The deep-inspection cost may be worse than the missed detection.
