---
title: The *do-not-reference-free-variable-console* prelude that keeps the module operating without special privilege; the consoleLevelMethods five-base + four-trace-family permit list paired with log severities; the consoleOtherMethods (assert, time, dir, group, profile, etc.) permit list with severities or undefined-for-pass-through; the consoleOmittedProperties retained-but-commented-out list documenting *unpermitted-but-expected* properties across Chrome/FF/Node/Safari with a *false-entries-in-SES-permits* discipline rationale
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--abstract.md)
- [Body](endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--see-also.md)
- [Common confusions](endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--common-confusions.md)
