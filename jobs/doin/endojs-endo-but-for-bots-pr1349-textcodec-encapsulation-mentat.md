---
tier: mentat
dispatch: manual
---
---
role: builder
arc: endo-ocapn-background
handler-timeout: 14339
---
**Role: builder (mentat).** Consolidate https://github.com/endojs/endo-but-for-bots/pull/1349 ("test(ses): XS smoke check for hardened TextEncoder/TextDecoder", branch `build/hardened-text-codecs-shim`, base frozen `master-6ee3fda`) with the follow-up fix for **endojs/endo#3369** (https://github.com/endojs/endo/issues/3369). Then **demonstrate the bug, and then its fix, in the SES browser test suite**.

**Maintainer direction (kriskowal, liaison muster 2026-10-07).**
- #1349 is based on upstream `master` and is destined for upstream endojs/endo through a **boatman ferry**. Keep it ferry-shaped: a clean, upstream-ready stack on a frozen `master-<sha>` base, with changesets and no fork-only artifacts. Do **not** push to endojs/endo or comment there; the liaison stages the ferry after review.
- In some Chrome builds, `TextEncoder`/`TextDecoder` carry an intrinsic property that cannot be deleted. SES should **not tolerate** it. The likely remedy, possibly temporary, is a more invasive shim: **encapsulate the native constructors entirely**, so the permitted `TextEncoder`/`TextDecoder` intrinsics are SES-owned classes that delegate to captured natives and never expose the native constructor objects.

**What #3369 records** (read the whole thread, including the comments):
- On V8 before about Chrome 127, the WebIDL constructors have own `caller` and `arguments`, `{value: null, writable: false, configurable: false}`. The issue measured this on Chrome 126.0.6478.182 and found it absent on Chrome 154. Since ses 2.3.0 added the codecs to `universalPropertyNames`, `cauterizeProperty` fails to delete `arguments` and `lockdown()` throws.
- The reporter's "tolerate a null descriptor" fix is **withdrawn**: that descriptor is indistinguishable from a live sloppy-function slot.
- mhofman: "The repair would have to replace the class altogether."
- naugtur proposes endojs/endo#3371 (permit the bogus caller/arguments). That is the tolerance approach the maintainer does not want. Read it for context and explain in the PR why encapsulation is preferred.
- The maintainer described the affected Chrome as "recent". Establish which versions actually reproduce, and record the matrix you tested.

**Deliverables (on the #1349 branch, or a restacked successor if the base must move; follow frozen-base-branch if it does):**
1. **Reproduce in the browser test suite.** Add a SES browser test that fails before the fix on an affected engine: a real pre-127 Chromium if the browser harness can pin one; otherwise the synthetic reproduction (define a non-configurable `arguments` on the native constructor before `lockdown()`), as #3369 describes. Show the red run.
2. **The shim.** Replace the permitted `TextEncoder`/`TextDecoder` with SES-owned encapsulating classes. Preserve the hardened-codec semantics from `designs/hardened-text-codecs-shim.md` (`instanceof`, `encodeInto`, `TextDecoder` options and labels, the `encoding`/`fatal`/`ignoreBOM` getters, and frozen prototypes shared across compartments). The native constructors must be unreachable after lockdown.
3. **Show it fixed.** The new browser test passes, and the existing Node tests (items 1–5) and the #1349 XS smoke test still pass. Run the browser suite locally (local-verify) and in CI.
4. Update the design doc and add a changeset.
5. Put a verification section in the PR body: the repro before and after, the engines and versions tested, and the CI links.

**Done when:** #1349 holds the consolidated change with green CI, including the new browser test, and the PR body carries the evidence. Then report back so the liaison can request your review and stage the boatman ferry. Don't merge.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T21:04:13Z
