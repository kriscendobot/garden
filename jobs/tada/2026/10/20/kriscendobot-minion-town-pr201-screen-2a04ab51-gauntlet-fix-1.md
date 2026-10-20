# Gauntlet FIX round 1: kriscendobot/minion.town#201 (New Clip)

I applied the panel's code and wording must-fix items and CI is green. The PR still should not merge: the decomplector's one real must-fix needs a maintainer ruling, and that ruling has not come in.

**Head:** `2a04ab51` → `63d054cc207`, pushed with `safe-push-pr-head.sh` as two follow-up commits.

**Source of the must-fix list:** there was no pre-pass block. I used the latest verdict, review 5583781709. It was rebuilt from durable record `38c153590c4d` for head `2a04ab51` and its items are cut short, so I took the full wording from the original panel review for the same head (#pullrequestreview-5582108243). The items came from the archivist, the decomplector and the pruner.

## What changed
1. **`refactor(auth)` — one `Sec-Fetch-Site` check** (decomplector, should-fix 2).
   - The check now lives in one place, `isCrossSiteRequest` in the new `src/auth/fetch-metadata.ts`. Both the Claude-account POST and `POST /account/clips/new` use it.
   - Behavior change: the New Clip route now accepts `Sec-Fetch-Site: none`, matching the older route. `none` means the user started the request, so it is not cross-site. I updated `test/new-clip.test.ts` to match, and the property tests in `test/claude-account-endpoint.test.ts` now import from the new module.
2. **`docs(new-clip)` — wording fixes from the archivist and the pruner.**
   - **`new-clip.ts` header:** removed `Far` from the list of worker endowments. Neither source string uses it, and I couldn't check the endo worker file, so the header now lists only what the sources use and names the daemon test suite that runs them.
   - **`measure` comment:** reflowed so the sentence no longer breaks mid-clause.
   - **Design doc (`designs/new-clip.md`):** § 4 now says the server loads the front at boot (`createApp` in `src/http.ts`). § 2 and § 3 point at the `new-clip.ts` header and the `mintNewClip` doc comment instead of restating them. § 3's wording changed from "not same-origin" to "cross-site". The section on the interim departure from #85 is kept.
   - **`shell.js`:** cut the comment on `NEW_CLIP_MINT_TIMEOUT_MS` down to the re-enable behavior.

`tsc --noEmit` is clean. The three affected test files pass locally (61 tests). `ci-wait-merge.sh --no-merge` returned 0: 2 of 2 Actions runs green.

## Not done
- **Decomplector must-fix 1 (the URL-holder-writable clip power against the #85 direction):** this is a decision for the maintainer, not a code fix. As the juror asked, I did not touch the quota or queue code. The maintainer was already asked twice:
  - inbox `20261020T050937Z-479285` (fix-2 of the `2a490c1d` gauntlet);
  - `msg-…2a490c1d-gauntlet-fix-3-5ac7df1f6ed1`, which offers options (a) accept the departure, (b) "not yet", or (c) wait for #88.

  No reply has come back, so I didn't send a third message. **Merge should stay held until the maintainer rules.**
- **Left alone:** pruner item 3 and the purist's should-fixes, because the resumed must-fix list doesn't include them. The purist's were: the form and app-type lists exist in two places, and `makeApp` validates a `type` it never uses.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-2a04ab51-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2629038 cached reads)
- Output: 14384 tokens
- Cost: $1.4783275999999999
- Wall-clock: 1894s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
