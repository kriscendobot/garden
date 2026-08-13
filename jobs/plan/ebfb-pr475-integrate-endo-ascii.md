---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-08-13T21:13:03Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-13T21:13:03Z
---

---
role: fixer
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-08-13T20:26:14Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots
Pull request: https://github.com/endojs/endo-but-for-bots/pull/475
Canonical package: https://github.com/endojs/endo-but-for-bots/pull/943

After the canonical encode-only @endo/ascii lands on llm, reconstruct or rebase pull request 475 onto a frozen llm snapshot that contains it. Remove pull request 475 own duplicate packages/ascii package and its package, composite-tsconfig, changeset, and yarn.lock ownership. Preserve the byteArray-narrowing change. In packages/ocapn/src/client/util.js, use canonical encodeAscii for ASCII string-to-bytes conversion before the existing immutable/frozen byte wrapping. Do not add decodeAscii to the canonical package: reconcile pull request 475 decoder-side edits against current llm and the bytes-preserving SturdyRef direction, preserving non-ASCII byte semantics. Update dependencies, changesets, lockfile, and focused tests, including rejection at U+0080. Push the pull request head branch and post the required completion summary.

<!-- garden-deadline-overrun: 1 -->

<!-- garden-annotation: key=62a118a08cfc by=producer at=2026-08-13T21:14:25Z -->

SUPERSEDED — do NOT promote. Replaced by job 'ebfb-pr475-integrate-endo-ascii-r2' (posted 2026-08-13T21:09Z), which carries the same instructions plus handler-timeout: 7200. This job doomed on shape (a), a genuine wall-clock overrun at 2401s: the work does not fit one 2400s claim. It was deliberately NOT decomposed, because every part is a sequential edit to the same PR branch and splitting would put two agents on the same head with force-pushes. Promoting this copy would re-run the work under the same 2400s budget and overrun again, and could race r2 on the branch. Remove it rather than promoting.
