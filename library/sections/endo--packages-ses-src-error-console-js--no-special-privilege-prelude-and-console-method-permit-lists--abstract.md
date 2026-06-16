---
title: Abstract
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

The §opening comment (lines 3-6) establishes the *no-special-privilege* design axiom: *To ensure that this module operates without special privilege, it should not reference the free variable `console` except for its own internal debugging purposes in the declaration of `internalDebugConsole`, which is normally commented out*. The line `// const internalDebugConsole = console;` is preserved (commented out) at line 46 so the discipline is *visible-but-inactive* — a debugger can uncomment it to inspect internal state, but production code never references the ambient `console`. The §next comment block (lines 48-66) names the four cross-platform standards consulted for the permit lists: *Whatwg living standard https://console.spec.whatwg.org/*; *Node https://nodejs.org/dist/latest-v14.x/docs/api/console.html*; *MDN https://developer.mozilla.org/en-US/docs/Web/API/Console_API*; *TypeScript https://openstapps.gitlab.io/projectmanagement/interfaces/_node_modules__types_node_globals_d_.console.html*; *Chrome https://developers.google.com/web/tools/chrome-devtools/console/api*. The §formatter discipline notes that all *fmt?, ...args* style methods format args per the Whatwg spec or Node util.format — *if fmt is a format string, otherwise just renders them all as values separated by spaces*. The §causal-console formatter inspection caveat: *for the causal console, all occurrences of `fmt, ...args` or `...args` by itself must check for the presence of an error to ask the loggedErrorHandler to handle. In theory we should do a deep inspection to detect for example an array containing an error. We currently do not detect these and may never.* The §consoleLevelMethods permit list (lines 80-91) enumerates nine method names paired with severities: `debug` / `log` / `info` / `warn` / `error` are the five canonical severity levels (with `debug` → 'debug', `log` → 'log', etc.); `trace` / `dirxml` / `group` / `groupCollapsed` are paired with `'log'` severity (they have *fmt?, ...args* signatures but TypeScript types them differently). The §consoleOtherMethods permit list (lines 103-124) enumerates 10 additional methods that don't take *fmt?, ...args*: `assert` (paired with `'error'`); `timeLog` (`'log'`); `clear` / `countReset` / `profile` / `profileEnd` / `timeStamp` (all paired with `undefined` for *pass-through-no-formatter-inspection*); `count` / `time` / `timeEnd` (all `'info'`); `dir` (`'log'`); `groupEnd` (`'log'`); `table` (`'log'`). The §commented-out `consoleOmittedProperties` block (lines 132-157) records 14 properties seen on real console implementations but *not* permitted on the wrapped console — `memory` (Chrome); `exception` (FF, MDN); seven Node `_underscore_prefixed` properties; `context` (Chrome, Node); `record` / `recordEnd` / `screenshot` (Safari); `@@toStringTag` (Chrome/Safari). The *false-entries-in-SES-permits* discipline: *seeing these on the original console is expected, but seeing anything else that's outside the permits is surprising and should provide a diagnostic*.
