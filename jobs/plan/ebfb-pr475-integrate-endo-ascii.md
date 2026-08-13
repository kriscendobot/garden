---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/943
priority: high
roadmap: @endo/ascii adoption
role: fixer
posted_by: designer
posted_at: 2026-08-13T18:49:53Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots
Pull request: https://github.com/endojs/endo-but-for-bots/pull/475
Canonical package: https://github.com/endojs/endo-but-for-bots/pull/943

After the canonical encode-only @endo/ascii lands on llm, reconstruct or rebase pull request 475 onto a frozen llm snapshot that contains it. Remove pull request 475 own duplicate packages/ascii package and its package, composite-tsconfig, changeset, and yarn.lock ownership. Preserve the byteArray-narrowing change. In packages/ocapn/src/client/util.js, use canonical encodeAscii for ASCII string-to-bytes conversion before the existing immutable/frozen byte wrapping. Do not add decodeAscii to the canonical package: reconcile pull request 475 decoder-side edits against current llm and the bytes-preserving SturdyRef direction, preserving non-ASCII byte semantics. Update dependencies, changesets, lockfile, and focused tests, including rejection at U+0080. Push the pull request head branch and post the required completion summary.
