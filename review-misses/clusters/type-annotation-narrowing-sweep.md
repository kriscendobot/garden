---
slug: type-annotation-narrowing-sweep
category: type-error
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-662af34e
prs: [475]
---

A value-type narrowing tightens the runtime shape but leaves consuming functions' JSDoc type annotations at the pre-narrowing wider union (type-correct, so tsc and the typist pass), and the maintainer must ask why the wider arm remains.
