---
slug: inline-import-jsdoc
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr721-review-56349e18
prs: [721]
---

Type references written as inline import() inside a JSDoc tag (@param/@returns/@type {import('./x.js').Y}) instead of a top-of-file @import { Y } from './x.js' tag plus a bare reference — a standing Endo house rule whose no-inline-import-jsdoc pre-push gate is documented but has no implementing probe script, so it never binds, and the typist backstop did not fire.
