---
title: The *do-not-reference-free-variable-console* prelude that keeps the module operating without special privilege; the consoleLevelMethods five-base + four-trace-family permit list paired with concrete log severities; the new consoleSpecialMethods (assert, timeLog) list split out because their `...args` sits in a different argument position; the consoleOtherMethods (clear, time, dir, group, profile, etc.) pass-through permit list now with every severity concretized to a level; the consoleOmittedProperties retained-but-commented-out list documenting *unpermitted-but-expected* properties across Chrome/FF/Node/Safari with a *false-entries-in-SES-permits* discipline rationale; the new exported sanitizeFormatData that strips whatwg `%c` CSS-styling specifiers (and their consumed argument) from a `[fmt, ...args]` cluster with careful `%%`-escape and unknown-specifier handling
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: 1b978bfbec82786398c61b004019f83cafef3527
source_date: 2026-06-17
source_authors: [Mark S. Miller]
source_lines: "1-277 (prelude + consoleLevelMethods + consoleSpecialMethods + consoleOtherMethods + consoleOmittedProperties commented block + sanitizeFormatData)"
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

  Refreshed 2026-06-27 (file-commit e02b0f66 → 1b978bfb): assert +
  timeLog moved out of consoleOtherMethods into the new exported
  consoleSpecialMethods (their `fmt?, ...args` is real but sits after a
  leading value/label, so they need bespoke wrappers); every
  previously-`undefined` severity was concretized (clear, countReset,
  profile, profileEnd, timeStamp → info) and the permit-list element
  type narrowed from `LogSeverity | undefined` to `LogSeverity`;
  consoleMethodPermits now spreads three lists (level + special +
  other); and a new exported sanitizeFormatData was added at the end of
  the prelude to strip whatwg `%c` specifiers before args reach the
  base console.
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
