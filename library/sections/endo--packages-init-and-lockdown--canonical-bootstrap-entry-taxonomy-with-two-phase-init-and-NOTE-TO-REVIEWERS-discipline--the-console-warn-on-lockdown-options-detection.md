---
source: packages/init + packages/lockdown (entry-point files)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/init
source_path: packages/init/*.js, packages/lockdown/*.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - getting-started
genre: §endo-source-comment-fragment §canonical-bootstrap-pattern
cycle: 183
lane: chat
status: current
title: §The-§console-warn-on-LOCKDOWN_OPTIONS-detection
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

```js
console.warn(
  `'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`,
);
```

§Why-warn-instead-of-silent: the LOCKDOWN_OPTIONS pathway
violates ocap discipline (§init-module-feature-tests-global-
state-for-a-passed-parameter). §The-warning-makes-the-violation-
visible.

§Compare-to-cycle-167-where/index.js' §ENDO_SOCK-override-as-
§last-resort-user-override — both expose user-controllable
configuration that bypasses normal discipline. §where/index.js
takes the override silently; lockdown warns. §The-difference:
ENDO_SOCK affects a daemon socket path (recoverable); LOCKDOWN_
OPTIONS affects the entire SES security boundary (security-
critical).

§The-warning-shape: §package-name + §sniff-source + §variable-
name. §All-three-pieces-help-the-reader trace where the
configuration came from.
