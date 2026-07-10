---
role: builder
---

Build the `registry-capability` M3 design on endojs/endo-but-for-bots: implement the `EndoRegistry` daemon capability that brokers npm-style package resolution and tarball fetch against the content-addressed store, exposed on every host as the required `@registry` special name (mirroring `@node`), delivering a mergeable draft PR.
