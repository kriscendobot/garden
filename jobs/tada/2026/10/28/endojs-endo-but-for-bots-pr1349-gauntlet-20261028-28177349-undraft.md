Undraft stage report for endojs/endo-but-for-bots#1349 ("fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors"): the PR was already out of draft, so this stage did nothing.

**Metadata gate:** `gh pr view` shows the PR is OPEN, its head is `2262b4bafa9f06177b311869b91c71d4fcd2ac96` (the exact head the panel passed) and `isDraft` is false. I did not run `gh pr ready`. A second fetch afterwards still showed `isDraft=false` and the same head.

**Advisory appellate pass (does not block):** I ran a light `claude -p` (sonnet) review over the PR diff. It found nothing blocking. Points worth a maintainer's look:
- **Prototype change before lockdown:** the host prototype's `constructor` is repointed before lockdown. After that, code that saved the native constructor earlier gets false from `instance.constructor === saved`.
- **No rollback on failure:** if `repairIntrinsics` throws after `tameTextCodecs()`, the realm is left half-tamed. Nothing rolls this back, and no test checks that a retry behaves the same.
- **Narrow detection:** affected hosts are detected only by a non-configurable own `caller`/`arguments` property on the codec constructors.
- **Native-code disguise:** the PR should confirm that the new constructor is explicitly marked so `String(TextEncoder)` shows `[native code]` rather than the closure source.
- **XS side effects:** `ShimStartCompartment` is still exported and still reads the untamed globals at import time. `Compartment` is now built twice during `repairIntrinsics`, which could split private state between the two copies.
- **Hidden parameter:** `repairIntrinsics` takes an extra parameter that hands out the new constructor. Check that no entry point passes it through.
- **Minor:** `{ cause }` is ignored on older engines, and same-origin iframes are separate realms whose codecs are not tamed.

**Follow-ups:** none required. The points above are optional reading for the maintainer's review.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-28177349-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176926 cached reads)
- Output: 1314 tokens
- Cost: $0.41338520000000006
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
