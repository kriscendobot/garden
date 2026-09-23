---
title: Connection to the wider library
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

This section is the **canonical worked example of *operating-without-special-privilege at the SES-internal-module level***. Three threads:

1. **The no-special-privilege design axiom** generalizes to any SES-internal module that wraps a host capability. The module *receives* the capability as an argument; it does not *find* one via ambient lookup.

2. **The four-standard permit-list lineage** is the canonical *cross-platform-consensus* discipline for engine API surfaces. Methods documented across Whatwg + Node + MDN + TypeScript + Chrome are permitted; methods documented in only one are omitted.

3. **The false-entries-in-SES-permits discipline** is the *expected-vs-surprising* trichotomy for property allowlists. *Permitted* / *expected-but-omitted* / *surprising* — three categories let the system differentiate routine omission from anomaly.
