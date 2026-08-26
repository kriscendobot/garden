---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
Repository: endojs/endo-but-for-bots
Context: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3858507400
Factor the non-canonical `@endo/base64/no-padding-encode` and
`@endo/base64/no-padding-decode` entry points out of
`packages/capn-web/src/special-values.js`, with focused tests and changeset
coverage.
