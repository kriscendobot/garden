Work complete. Completion report follows.

---

## Completion report: review directive on endojs/endo-but-for-bots#475

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer resolution). Did the work.

**Review enumeration.** The Review URL's trailing number is a *comment* id, not a review id. The actual review (`4954925589`, by erights) has an **empty body** and exactly **one** inline comment — id `3799112565` on `packages/bytes/src/genuine-uint8-array.js`, a reply in the thread rooted at `3496724676`. That single comment is the whole unit of work. Treated as untrusted data; the ask itself is legitimate.

**The directive (two asks).** Because `@endo/bytes` depends on `@endo/immutable-arraybuffer` **not** replacing the `%TypedArray%.prototype` integer-indexed getter, (1) make that non-replacement part of the package's specification, and (2) duplicate the test that catches an accidental "fix" into `@endo/immutable-arraybuffer`.

**Research finding.** The anchored file `genuine-uint8-array.js` (with the `[Symbol.toStringTag]`-getter brand check) no longer exists on the branch — `@endo/bytes` moved to detecting immutability via the `.immutable` accessor and copying before indexing; `@endo/pass-style` relies on the emulated wrapper carrying *no* own integer-indexed properties. The load-bearing invariant is the same in the current mechanism: an emulated wrapper answers `view[i]` with `undefined` because the shim installs no integer-indexed read accessor on `%TypedArray%.prototype`. I specified and pinned against that current mechanism.

**Changes (commit `3c91d67cfd`, pushed to `feat/narrow-bytearray-to-uint8`):**
- `packages/immutable-arraybuffer/README.md` — new spec section *"Integer-indexed reads on emulated freezable views (a specified fidelity loss)"*: documents the non-replacement, the client dependency, and a do-not-"fix" warning.
- `packages/immutable-arraybuffer/test/shim-typedarray.test.js` — the duplicated guard: pins `view[i] === undefined` and zero own indexed properties on a fresh emulated wrapper (fails first if the getter is added).
- `packages/bytes/test/main.test.js` — client-side mirror: `compareBytes` over emulated wrappers, a −/+/0 triple that would collapse to all-equal if it ever read `wrapper[i]` directly.

**Verification.** Ran the new assertions directly against the real shim and `compareBytes` source (all pass); `prettier --check` clean on all three files. Full `ava`/`eslint` left to CI — the local worktree install is incomplete (unrelated native-build + hardlink `EMLINK` env gap, per the known local-test-shim caveats), so those runners can't execute here. Syntax-checked both test files with `node --check`.

**Communication.** Threaded reply on the inline comment (https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3799200144) and a top-level summary (https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5320887101), each citing SHA `3c91d67cfd`.

**Follow-ups.** None required. No changeset (docs/test-only, no published API change). CI runs the full suites.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-review-6c57250a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 125 tokens (6690666 cached reads)
- Output: 48644 tokens
- Cost: $5.874686999999999 (1 engagement(s) unpriced)
- Wall-clock: 717s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
