---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# Relay PR-write steps for endojs/endo-but-for-bots PR #1392 (parcel WeakMap brand fix)

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1392.
Predecessor job `endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand` already pushed the code fix
(head 5f9bc1533d9dbfecbe026b6eff8ef67030509bea) for kriskowal's review
https://github.com/endojs/endo-but-for-bots/pull/1392#pullrequestreview-5610163704, but host
oros-studio's PAT gets 403 on every PR write. Do ONLY these write steps, from an endolin host. No code changes.

Head guard: first confirm the PR head is still 5f9bc1533d9dbfecbe026b6eff8ef67030509bea, or that 5f9bc1533 is an ancestor of the head. If not, adapt the SHAs cited in the bodies below.

1. Replace the PR body with the BODY block below (`gh pr edit 1392 -R endojs/endo-but-for-bots --body-file <file>`). Keep the leading garden-job marker line exactly as it is.
2. Reply on inline comment 4345265068 with REPLY-84 (`gh api repos/endojs/endo-but-for-bots/pulls/1392/comments/4345265068/replies -f body=@<file>`, or `--input` JSON).
3. Reply on inline comment 4345270943 with REPLY-1.
4. Post SUMMARY as a top-level PR comment.
5. Watch CI on the head in the foreground, bounded to about 60 minutes. If it is green, re-request review from kriskowal with
   `echo '{"reviewers":["kriskowal"]}' | gh api repos/endojs/endo-but-for-bots/pulls/1392/requested_reviewers --input -`.
   If it is red because of this change, do not re-request. Post a shepherd job and report it.

===== BODY =====
<!-- garden-job: ebfb-sturdyref-layer3-pass-style-20260930 -->
Refs: #695, #774, #1391, https://github.com/kriscendobot/garden/issues/47

## Description

The pass-style recognition step of the Parcel stack, stacked on the SES accommodation (#1391). `passStyleOf` now returns the new pass style `'parcel'` for a Parcel, admitted like a presence: object identity, no data. This answers the change request on #695 that these are a new kind of passable, not remotables.

Recognition is a brand check. Every Parcel is a key in the `@endo/parcel` shim's private WeakMap from each parcel to its internal slots (location and open hook), and `Parcel.isParcel` asks that WeakMap. `isParcelObject` tests that the candidate is an object and then calls the `isParcel` it captured from `globalThis.Parcel` when the module evaluated. It never inspects the candidate's shape, so an object with the same prototype, frozen and empty, that the constructor did not make is not a Parcel. Pass-style reaches the WeakMap only through the global because the shim does not depend on pass-style (`designs/parcel.md`). `passStyleOf` asks only after every other pass style has declined a value.

### Security Considerations

Recognition never opens a Parcel. Recognition is local in this layer: the generic marshal rejects a Parcel in either body format, so no Parcel, and no authority to open one, crosses a marshal boundary yet. Recognition trusts the realm's `globalThis.Parcel` as installed before `harden` exists, as every other module trusts the realm's intrinsics. That global is read through descriptors, so an accessor is never invoked, and its `isParcel` is captured once, so replacing the global later cannot change an answer `passStyleOf` has memoized. The cases that need a fresh realm run in a fresh Node process (`packages/pass-style/test/parcel-pre-shim.test.js`), since every AVA profile has already installed a non-configurable `Parcel`.

### Scaling Considerations

None.

### Documentation Considerations

The pass-style README lists the new pass style in its own dormant-capability category, and both READMEs say a Parcel cannot yet cross a vat boundary.

### Testing Considerations

The affected packages' tests, lint, and type tests pass locally and in CI. These packages have no XS harness, so the new tests run on Node only.

### Compatibility Considerations

`PassStyle` and `Passable` widen, so exhaustive `PassStyle` consumers must handle or exclude `'parcel'`, and `Pattern` and `Matcher` no longer admit nested errors or Parcels; the changeset says so. `@endo/spaces-util` gains a `'parcel'` render case but is private, so it has no changeset. `@endo/parcel` is a devDependency only, so no dependency cycle forms.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)




===== REPLY-84 =====
Addressed in 4a034b968a6e2ca799c9f2879a99874ebd873e16. `isParcelObject` now tests that the candidate is an object and then calls `Parcel.isParcel`, which is `has` on the shim's private `details` WeakMap from each parcel to `{ location, openHook }`. The prototype, descriptor, frozenness, and own-key checks are gone. So are the reentrancy guard and the per-call exception handling, which existed only for an untrusted `isParcel`.

Guards I kept, and why:

- `globalThis.Parcel` and its `isParcel` are read through property descriptors, so an accessor installed before the shim is never invoked. The shim and SES lockdown both reject an accessor there.
- A `Parcel` global that is not a function, or an `isParcel` that is not a function, means nothing is a Parcel. Without this check, an unrelated global would make every `passStyleOf` throw.
- `isParcel` is captured once, when the module evaluates, so replacing the global later cannot change an answer `passStyleOf` has memoized. That is also the only time to read it, because the shim refuses to install once pass-style's own `@endo/harden` import exists.

`packages/pass-style/test/parcel.test.js` asserts that an object with a Parcel's prototype, frozen and empty, is not a Parcel. The pre-shim fixture checks the same against the real shim. Recognition no longer needs a frozen constructor, so the Parcel tests in pass-style, marshal, and patterns now also run in the shims-only profile (5f9bc1533d9dbfecbe026b6eff8ef67030509bea).
===== REPLY-1 =====
In 4a034b968a6e2ca799c9f2879a99874ebd873e16 the private state is the WeakMap that `@endo/parcel` already holds: `details` in `packages/parcel/src/parcel-shim.js`, mapping each parcel to `{ location, openHook }`. This module brand-checks through `Parcel.isParcel`, which is `has` on that WeakMap.

I left the WeakMap in the shim instead of moving it here because `designs/parcel.md` puts the shim below pass-style. The shim does not depend on pass-style, and pass-style reaches the shim only through `globalThis.Parcel`.

Question: did you want the WeakMap to live in `@endo/pass-style` itself? That would invert the layering: either the shim imports its table from pass-style, or pass-style takes over Parcel construction. I have not made that change without your direction.
===== SUMMARY =====
Addressed the review in https://github.com/endojs/endo-but-for-bots/pull/1392#pullrequestreview-5610163704. Head is now 5f9bc1533d9dbfecbe026b6eff8ef67030509bea.

- 4a034b968a6e2ca799c9f2879a99874ebd873e16 `fix(pass-style)`: Parcel recognition is now a brand check. It tests for an object, then calls the `Parcel.isParcel` captured from `globalThis` (the shim's WeakMap `has`). The shape validation is deleted. The pre-shim fixture went from 24 scenarios to 4: absent global, accessor global never invoked, real shim with a same-shape impostor rejected, and a captured-once check that a replaced global does not change. There is a new assertion that a same-prototype, frozen, empty impostor is not a Parcel.
- 5f9bc1533d9dbfecbe026b6eff8ef67030509bea `test(marshal,patterns)`: the shims-only skip is gone. A Parcel is passable before lockdown now that no frozen constructor is required.
- The PR description's Description and Security Considerations sections now describe the brand check instead of the shape checks.

Open question on the line-1 thread: should the WeakMap live in pass-style itself? Doing that would invert the layering in `designs/parcel.md`.

Verification: `yarn test` for pass-style, marshal, and patterns passes in every ses-ava profile. Three unrelated marshal/patterns files exited non-zero under host load and passed when rerun. `yarn lint` shows 0 errors, and prettier and the pre-push probes pass. The one probe failure is the `spell-out-identifiers` flag on fast-check's `numRuns` option, which this PR already had and which is that library's API name.
===== END =====

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T13:46:09Z
