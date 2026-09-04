---
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# design: eliminate single-segment (string) petname paths in endojs/endo-but-for-bots mount

Source: kriskowal review comment on PR #897,
https://github.com/endojs/endo-but-for-bots/pull/897#pullrequestreview-5092213172
inline comment id **3916282675** on `packages/daemon/src/help.md`. Trusted
maintainer feedback on our own repo. Verbatim ask:

> "It may be noted that the 'glob' expression for glob, glorp is an explicit
> aberration on the array-of-segments petname path notation we use elsewhere,
> where a single string is in the UNIX glob DSL. However, a path should always be
> represented as petname path segments and a single string is always a single
> segment. This will need to be called out in help text very clearly, since it is
> not the norm. It may behoove us to completely eliminate support for single
> segment pet name paths in order to ensure that a slash delimited string produces
> an error. Please post a follow-up design to that effect."

## What to design
Write a design doc (in the endo-but-for-bots repo's `designs/` area, following
that repo's design conventions) proposing to **eliminate support for single-segment
string petname paths** in the mount/daemon path API, so that a slash-delimited
string like `"src/foo.js"` produces an **error** rather than being silently
treated as one literal segment. Cover:

1. The current behavior: path-taking mount methods accept `string | string[]`,
   where a bare string is treated as a one-element segment array and is never
   split on `/`. Enumerate the surface that accepts string paths.
2. The proposed rule: paths are ALWAYS array-of-segments; a string argument is
   rejected (or accepted only via an explicit, clearly-named escape hatch —
   evaluate both). Define exactly what error a slash-bearing / any string yields.
3. The glob/glorp aberration: `glob`/`glorp`'s single-string argument IS the UNIX
   glob DSL, deliberately unlike petname paths. Specify how help text must call
   this out "very clearly" as a documented exception to the array-of-segments
   norm, so the two string-shaped-but-different arguments are not conflated.
4. Interaction with the just-removed `entry()` wrapper (PR #897 review ask A):
   with entry() gone and strings rejected, what mints/represents a path.
5. Migration/back-compat: what breaks, how callers and help text migrate, test
   impact.
6. Open questions for kriskowal to decide (this design has real forks — the
   string escape-hatch question, the glob-DSL exception ergonomics — so it
   likely warrants the open-questions review-PR treatment per that repo's norms).

This is a DESIGN deliverable (a doc + the maintainer-facing review surface), not a
code change. Do not implement the elimination here.
