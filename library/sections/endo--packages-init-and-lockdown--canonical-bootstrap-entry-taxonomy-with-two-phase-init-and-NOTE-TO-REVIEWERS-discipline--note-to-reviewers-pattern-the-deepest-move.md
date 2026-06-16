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
title: §NOTE-TO-REVIEWERS-pattern (the deepest move)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

§The-most-distinctive-comment-discipline in this package is the
§NOTE-TO-REVIEWERS pattern, appearing repeatedly in `commit-
debug.js` and the default-path branch of `pre.js`:

```js
// NOTE TO REVIEWERS: If you see the following line commented out,
// this may be a development accident that should be fixed before merging.
//
errorTaming: 'unsafe',
```

```js
// NOTE TO REVIEWERS: If you see the following line *not* commented out,
// this may be a development accident that MUST be fixed before merging.
//
// errorTaming: 'unsafe',
```

§The-pattern-comes-in-two-polarities:

1. **§Polarity-positive** (in `commit-debug.js`): "If you see
   the following line **commented out**, this may be a
   development accident." — the option is **expected** to be
   set.
2. **§Polarity-negative** (in `pre.js` default branch): "If you
   see the following line **not** commented out, this may be a
   development accident." — the option is expected to be
   **commented out**.

§The-two-polarities are §opposite-defaults for the same
parameter (errorTaming) in two contexts:

- `commit-debug.js` — debug mode; expects `errorTaming:
  'unsafe'` set.
- `pre.js` default — production-fallback; expects
  `errorTaming: 'unsafe'` **un**set.

§A-reviewer-can-search-for-"NOTE TO REVIEWERS" and §mechanically-
check that the polarity matches the file's purpose. §The-
comment-is-grep-friendly + §self-documenting.

§Compare-to-cycle-181-base64's §don't-over-validate-by-default-
with-RFC-citation: that comment closed the §future-contributor-
hole (a reviewer might add a check thinking it was missing
hardening). §This-comment-closes-the-§development-accident-
hole (a reviewer might miss that a debug-option was left set in
a production file).

§Both-are §code-comment-as-vocabulary-instruction patterns, but
they target different review failure modes. §The-NOTE-TO-
REVIEWERS-pattern is §belt-and-suspenders-against-merge-time-
mistakes.

§Five-options-with-NOTE-TO-REVIEWERS-pattern in `commit-debug.js`:
errorTaming + stackFiltering + overrideTaming + consoleTaming +
(implicit) one other. §Each-has-the-polarity-comment block
naming the development accident.
