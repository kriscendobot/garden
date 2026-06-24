---
ts: 2026-05-20T03:45:00Z
kind: result
role: fixer
to: liaison
dispatch_id: c8c025
dispatch_root: /home/kris/dispatches/fixer--c8c025
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 74
    role: target
  - repo: endojs/endo
    pr: 3241
    role: source
refs:
  - entries/2026/05/20/043800Z-dispatch-liaison-c8c025.md
---

# Result: fixer applies two boneskull review-comments from endo#3241 to mirror #74

Two inline review comments from boneskull on upstream endojs/endo#3241 mirrored into our PR #74 on branch `design/audit-module-source-visitors`.

## Files edited

- `packages/module-source/src/transform-source.js`: JSDoc `@param {object}` and `@returns {object}` rewritten to the named types `{File}` and `{NodePath}` per `discussion_r3203607994`. File carries `@ts-nocheck`; change is documentation-precision.
- `packages/module-source/test/module-source.test.js`: at both invocations of the `t.notRegex` regression assertion (the two `invisible joiner character ... is reserved` tests), the explanatory `//` comment above each call was removed and the rationale folded into `t.notRegex`'s custom-message argument per `discussion_r3203619122`.

## SHAs

- Pre-fix head: `e9631f5759a1469541cc47d3c8f5f70707479bea`.
- Fix commit: `cb73507827eaa6ec8173909155156ea732839279` (`fix(module-source): apply boneskull review comments from endo#3241 (#74)`).
- New head: `cb73507827eaa6ec8173909155156ea732839279`.
- Force-with-lease push against the dispatch's named lease `e9631f575` landed cleanly.

## Thread-reply URLs on #74

The mirror PR #74 carries no inline review-comment threads of its own (`GET /pulls/74/comments` returns `[]`); the boneskull threads live only on upstream endo#3241. Per `skills/pr-review-thread-replies/SKILL.md` § Pitfalls ("Inline comments visible in the browser but not in REST"), the fallback is a single top-level comment mapping each upstream anchor to its outcome on the mirror side. Posted at:

- https://github.com/endojs/endo-but-for-bots/pull/74#issuecomment-4494298528 (id `4494298528`). Cites both upstream `r3203607994` and `r3203619122` discussion URLs, names the addressing SHA `cb73507827`, and lists the local-validation triple.

No comments posted upstream on `endojs/endo#3241` (READ-ONLY per dispatch).

## Local validation

In `packages/module-source/`:

- `yarn lint:eslint`: clean.
- `yarn lint:types`: clean.
- `yarn test`: 53 pass (full suite, including the two regression tests whose assertion message was changed).

Pre-push-gates ran before commit; its `yarn format` and `yarn lint --fix` auto-fix stages mutated two files outside scope (`packages/evasive-transform/src/index.js` whitespace and `packages/ses/src/compartment.js` JSDoc annotation). Both were reverted before staging; the commit carries only the two intended edits. Probe findings (`no-inline-import-jsdoc` in evasive-transform, `security-md-hash-uniform`) are pre-existing and out of scope for this dispatch.

Self-improvement: the pre-push gates' auto-fix stages cross the whole tree, not just the dispatch's diff; a fixer with a narrow target needs to restore unrelated paths after the gate runs. `skills/pre-push-gates/SKILL.md` § Pitfalls would benefit from a "Scope discipline" note: the gate's auto-fixers are tree-wide by design, so a fixer with a narrow target reverts unrelated mutations before staging. Routing as a `message: fixer → liaison` in this dispatch's parent context is overkill for a one-line skill addendum; surfacing here instead.
