# Gauntlet FIX round 2: kriscendobot/minion.town#201 (New Clip)

I fixed the pruner's comment and doc padding and pushed it, and CI is green. The PR still should not merge: the decomplector's one real must-fix needs the maintainer's ruling, and no ruling has come in. Nothing arrived in my inbox during the run.

**Head:** `63d054cc207` → `43fc8277278`, one follow-up commit pushed with `safe-push-pr-head.sh`.

**Source:** no pre-pass block appeared, so I used the latest panel verdict (2026-10-20T11:22Z, `Must-fix before merge`). Two seats asked for changes: the pruner and the decomplector.

## What changed
Commit `docs(new-clip): cut the header's layout recap and restated comments` (pruner items 1–4):
- **`src/endo/gateway/new-clip.ts` header:**
  - Removed the space-layout recap; it now points at `designs/new-clip.md` § 2.
  - Kept the one-id metamorphosis reason and the authority paragraph. The design doc points at the header for that reason, so it has to stay.
  - The `NEW_CLIP_MAX_DIRECTORY_ENTRIES` doc comment no longer repeats the constant's name.
- **`clips/new-clip/types.d.ts`:** deleted the header line that only repeated the file name.
- **`dev/new-clip-browser-demo.mjs`:** dropped the Playwright note that the workflow comment already says.
- **`designs/new-clip.md` § 2:** now says `metamorphose` needs an existing `inventory` directory (an archivist comment).

**PR body:** the Authority paragraph now names the #85 departure and the move behind the #88 nonce, and says the departure needs the maintainer's sign-off before merge (an integrator should-fix).

**Checks:**
- `tsc --noEmit` is clean and `test/new-clip.test.ts` passes (19 tests).
- CI: the first `ci-wait-merge.sh` run was cut off by the session's 10-minute limit on background commands, at about 20 of its 60 minutes, still pending. I reran it in the foreground with a 560-second deadline. It returned 0: 2 of 2 Actions runs green on `43fc827`.

## Not done
- **Decomplector must-fix 1 (anyone with the URL can write through the clip power, against the #85 direction):** this needs a maintainer decision, not a code fix. The juror asked us to wait for that decision, not to keep hardening the code. The maintainer has already been asked twice, with options (a) accept, (b) not yet, (c) wait for #88:
  - `20261020T050937Z-479285`
  - `msg-…2a490c1d-gauntlet-fix-3-5ac7df1f6ed1`

  I didn't send a third message. **The merge should stay held until the maintainer rules.**
- **Left alone:**
  - Pruner item 5 is marked "acknowledge" and is the maintainer's call.
  - Decomplector should-fix 2 (the quota machinery) depends on the ruling.
  - Decomplector comment 3 is advisory only.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-2a04ab51-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2012306 cached reads)
- Output: 9035 tokens
- Cost: $1.1842252
- Wall-clock: 2305s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
