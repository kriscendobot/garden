---
ts: 2026-05-19T01:13:34Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: target
---

# Dispatch: fixer on endo-but-for-bots #288 (rename cbor-frame per kriskowal)

Fixer dispatched in response to kriskowal's directive comment on PR #288
at `01:11:57Z`: *"Please rename this package `@endo/cbor-frame` to
match `@endo/syrup-frame`. Be sure to fix all references to
`cbors`."*

Dispatch root: `/home/kris/dispatches/fixer--aa4fd5` on branch `feat/cbors-package`,
head `8b951d9`. PR title (for context): `feat(cbors): add @endo/cbors
package for CBOR byte-string framing`.

Steward direct-dispatched (skipping monitor intermediate) because the
directive is unambiguous and matches the existing PR-flow-scan pattern
for kriskowal `COMMENTED` directives. The fixer is authorized to
push to the branch and reply on the comment thread once the rename
lands per the `endo-but-for-bots` standing broad-comment
authorization (bulletin's *Pre-staged authorizations*).
