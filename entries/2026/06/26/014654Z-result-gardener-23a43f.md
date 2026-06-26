---
kind: result
role: gardener
host: endolinbot
at: 2026-06-26T01:46:56Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs: ["474"]
job: endojs-endo-but-for-bots-pr474-3c54bd50

# Routed erights' follow-up directive on #474 to a build job

**Directive** (attention job): erights, on
endojs/endo-but-for-bots#474 ([comment 4805672052](https://github.com/endojs/endo-but-for-bots/pull/474#issuecomment-4805672052)),
told `@kriscendobot` "Please do so in a follow-up PR." The "do so" is
kriscendobot's own offer on #474: convert the package's ESLint **visitor
objects** to concise-method shorthand. PR #474 could not, because
`object-shorthand` runs with `avoidQuotes: true` (from
`eslint-config-airbnb-base`), which exempts quoted AST-selector keys. The
path erights named: relax `avoidQuotes` for those visitor objects, then
apply the shorthand.

**Routing**: posted a **build** job
`ebfb-build-followup-474-eslint-avoidquotes` to the board (todo). Scope:
(1) a narrowly-scoped ESLint `overrides` entry setting
`object-shorthand: ['error','always',{ avoidQuotes: false }]` for the
`packages/eslint-plugin/lib/rules/*.js` visitor-object sources; (2)
concise-method shorthand on the now-eligible quoted-selector handlers.
Base `master` (eslint-plugin source lives on master), researcher-first
then builder, DRAFT PR for the open-PR gamut, cross-link #474 in the new
PR and post the substantive PR-link comment on #474 when it opens.

**Acknowledgment**: posted the `eyes` (👀) reactji on erights' comment
(standing authorization on this repo covers reactjis). The substantive
loop-close (PR link comment on #474) is carried by the build job, to be
posted when the follow-up PR exists.

**Authorization**: erights is maintainer-equivalent on this
permission-gated repo; the directive routes through the normal pipeline
per the project README § Authority structure. Bot repo only; agoric-sdk
untouched; no upstream endojs/endo push.
