Done. Work is complete, verified, pushed, and the summary comment is posted.

---

## Completion report

**Job:** `build-ebfb-bytearray-uint8array-view-restrictive` — build the restrictive view-based `byteArray` per design #572 / decision #573.

**Vehicle:** Carried the in-flight #475 branch `feat/narrow-bytearray-to-uint8` forward (per job direction, not a parallel branch). Pushed as a clean fast-forward; new head **`d980cbeaa`**.

**What I did (3 commits on top of `1dbb32ebc`):**

1. **`170696339` `feat(pass-style)` — restrictive whole-buffer span (#573 Decision 3).** Added the guard the prototype lacked: `passStyleOf`'s byteArray detection now requires `byteOffset === 0 && length === buffer.byteLength`, rejecting sub-views and closing the data-reachability hazard. `frozenBytes` already produces whole-buffer-spanning views, so it's unaffected. Added 4 tests (whole-buffer accept, non-zero-offset reject, short-prefix reject, `frozenBytes`-re-slices-a-subview).
2. **`529271702` `feat(marshal)` — byteArray-through-codecs fold-in from the closed #57** (commit `1ad194110`). capdata / smallcaps / encode-passable / marshal-justin now serialize a byteArray (each previously threw "not yet implemented"), via the hex helpers over `frozenBytes`/`thawnBytes`, with **byte-for-byte-identical wire forms**. Included #57's `marshal/test/byteArray.test.js` (13 tests) proving wire stability + shortlex/`compareRank` agreement. Resolved one `rankOrder.js` conflict by keeping the branch's existing genuine-`Uint8Array` read (`.slice(0)` + `compareBytes`, the form #572 names) over #57's older `.at()` loop.
3. **`d980cbeaa` `chore: Update yarn.lock`** — separate commit, for marshal's new `@endo/hex` dep.

**Verification (local):** ava — pass-style 59 passed, marshal 92 passed/1 skipped; eslint clean on both packages; tsc shows only pre-existing errors (confirmed identical on the unmodified base `1dbb32ebc`, so branch drift, not introduced here).

**Scope honored:** did not touch upstream `endojs/endo#3226`, did not revive the bare-buffer premise of #429/#57, did not unify helper naming (deferred to kriskowal), kept the permissive sub-view form out (tracked at #573).

**Communication:** posted a top-level summary comment on #475 ([issuecomment-4844412592](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4844412592)) naming the head SHA, the changes, and verification, tagging @erights. Inbox was empty and the live thread carried no reversing instruction at push time.

**Follow-ups / notes:**
- #475 remains DRAFT + CHANGES_REQUESTED and carries a large amount of accumulated scope beyond #572's narrow design (a new `@endo/utf8` package, `@endo/ascii`, `@endo/bytes` re-homing, test262-runner work — 139 files vs master). This build deliberately did **only** the #572/#573-scoped data-model work; the broader review backlog on #475 is separate and unaddressed by this job.
- Helper-naming unification (`frozenBytes`/`thawnBytes` vs hex helpers) is explicitly deferred to @kriskowal.

**Self-improvement:** nothing this time.
