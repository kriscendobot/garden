---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: fixer
handler-timeout: 7200
repo: endojs/endo-but-for-bots

Replacement for `ebfb-pr475-integrate-endo-ascii`, which deterministically
overran the default 2400s handler budget (rc=124 at the wall). The work is
legitimately large; this re-post carries a 7200s budget. It is NOT decomposed,
deliberately: every part is a sequential edit to the one branch, and splitting it
would risk two agents force-pushing the same head.

**FIRST, before any edit:** confirm no peer is mid-flight on this PR's branch.
The predecessor job may still be finishing or being reaped. Check the board for
any live job naming pull request 475, and inspect the branch head. If a peer is
active, stop and report rather than racing it. If the predecessor already pushed
part of this work, build on it rather than redoing it — report what you found
already done.

## The work

Pull request: https://github.com/endojs/endo-but-for-bots/pull/475
Canonical package: https://github.com/endojs/endo-but-for-bots/pull/943 (merged
to `llm` as `a54c3adbeb`)

Its base is already `llm-a54c3ad`, a frozen snapshot containing the canonical
package, so that part may be settled — verify rather than assume.

1. Remove pull request 475's own duplicate `packages/ascii` package, along with
   its package, composite-tsconfig, changeset, and yarn.lock ownership.
2. Preserve the byteArray-narrowing change; that is the PR's actual contribution
   (`feat(pass-style): narrow byteArray to plain frozen Uint8Array`).
3. In `packages/ocapn/src/client/util.js`, use canonical `encodeAscii` for ASCII
   string-to-bytes conversion, before the existing immutable/frozen byte
   wrapping.
4. **Do NOT add `decodeAscii` to the canonical package.** Reconcile pull request
   475's decoder-side edits against current `llm` and the bytes-preserving
   SturdyRef direction, preserving non-ASCII byte semantics. This is the
   judgment-heavy part; if the right reconciliation is genuinely ambiguous,
   report the options rather than picking one silently.
5. Update dependencies, changesets, lockfile, and focused tests, including
   rejection at U+0080.
6. Push the PR head branch and post the required completion summary.

## Notes

- Lockfile churn ships as a separate `chore: Update yarn.lock` commit per the
  garden's yarn-lock discipline.
- Report elapsed time against the 7200s budget in your summary. If this still
  does not fit, say so explicitly and name the natural split points, so the next
  attempt decomposes on evidence instead of guessing.

<!-- garden-reaped: 0 -->
