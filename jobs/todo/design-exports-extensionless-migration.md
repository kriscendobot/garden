---
role: designer
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-10T05:39:03Z -->

# Design: additive, two-pass migration to extensionless `exports` subpaths

**Repo:** endojs/endo-but-for-bots, base `llm`. Deliverable: a `designs/` doc that
a follow-up migration executes; the migration itself is expected to run as
orchestrated per-package tranches (below), not this job.

## Goal

Let consumers import a package's subpaths **without the `.js` extension** — e.g.
`import '@endo/marshal/foo'` instead of `import '@endo/marshal/foo.js'` — by
exposing extensionless subpath keys in each package's `package.json` `exports`.
Done **additively, in two passes, with zero compatibility break in the first
pass** (maintainer directive, 2026-07-10).

## The two passes (maintainer-specified shape)

**Pass 1 — additive `exports` keys (no compat break).** For every existing
`exports` subpath key ending in `.js`, ADD a sibling **extensionless** key that
maps to the SAME target, and KEEP the `.js` key. Example:

```jsonc
"exports": {
  "./foo.js": "./src/foo.js",   // retained
  "./foo":    "./src/foo.js"     // added (new)
}
```

Purely additive: every existing specifier keeps resolving; new extensionless
specifiers now also resolve. Ships as a **minor** bump per package.

**Pass 2 — drop `.js` from the corresponding import specifiers.** Update the
import specifiers across the monorepo to the extensionless form. Lands only after
pass 1 is fully merged (pass 2 is **blocked_on** pass 1 — the extensionless keys
must exist first).

**Changeset note (both passes).** Each affected package's changeset carries a
standing note: *"The `.js`-suffixed `exports` keys are retained for
compatibility; we reserve the right to remove them in the next major version."*

## Design questions the doc MUST resolve (why this is a design, not a codemod)

1. **Scope of "import specifiers" in pass 2 — load-bearing.** Node ESM `exports`
   govern only how **other** packages import this package's subpaths
   (`@endo/pkg/foo`). **Intra-package relative imports** (`import './foo.js'`
   inside the package) do NOT go through `exports`; they resolve on the
   filesystem and Node ESM **requires** the extension. So pass 2 may drop `.js`
   only from **cross-package bare-specifier subpath imports** that resolve via an
   exports map — NOT from internal relative imports (those must keep `.js`).
   Delineate precisely which specifiers are eligible, and confirm the package
   self-entry `"."` and deep-import conventions in this monorepo.

2. **Conditional exports, `.`, wildcards.** Handle object-form conditional
   exports (`{ "import", "types", "default" }`), the main `"."` entry,
   `"./package.json"`, and any subpath-pattern exports (`"./*": "./src/*.js"` /
   `"./*.js"`). Decide how the extensionless variant composes for patterns (e.g.
   add `"./*"` alongside `"./*.js"`) and the resolution/precedence implications.

3. **`types` condition parity.** TS consumers under `moduleResolution`
   node16/nodenext/bundler resolve `.d.ts` via the `types` condition. The
   extensionless keys must carry matching `types` so `import '@endo/pkg/foo'`
   type-resolves. Note the `moduleResolution`-mode interactions and whether any
   consumer tsconfig needs adjustment.

4. **Automated, idempotent, verifiable.** Both passes are scripted codemods
   (pass 1 over `package.json` `exports`; pass 2 over eligible specifiers),
   idempotent, with lint/check gates: every `.js` export key has an extensionless
   sibling; no eligible cross-package specifier still carries `.js`; no intra-
   package relative import was wrongly stripped.

5. **Verification.** Full monorepo build + `tsc` + `ava` green after EACH pass; a
   package imported both ways still resolves; `test262`/xs/hermes lanes unaffected.

## Execution recommendation

Given monorepo scale, run each pass as an **orchestration** over packages (per the
standing decompose-multi-part rule): pass-1 children add the keys, then a single
pass-2 orchestration (blocked_on pass 1) updates specifiers. Pass 1 must land and
be verified compat-safe before pass 2 begins.

## Cross-reference

The release-automation trigger that flags the eventual `.js`-key *removal*
opportunity on a planned major bump is a **separate, lower-priority plan**
(`release-automation-major-bump-exports-trigger`). It is meaningful only after
pass 1 lands the dual keys.

## Definition of done

A `designs/` doc specifying: the two-pass additive mechanism, the pass-2 specifier-
eligibility delineation (question 1), the conditional/wildcard/`types` handling
(2–3), the codemods + verification checks (4–5), the per-package changeset note,
and the orchestration decomposition — concrete enough to execute with no further
design decisions.
