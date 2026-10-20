# Fix round 2: kriscendobot/minion.town #201 (New Clip)

I applied the panel's must-fix items and pushed two follow-up commits to `feat/new-clip-inventory` (98fedc91 → 2a04ab51). CI is green on 2a04ab51: all 7 checks pass and `ci-wait-merge.sh` returned rc 0. The one open item: the maintainer still has to confirm the departure from #85 before merge.

The job had no pre-pass block, so I worked from the latest panel verdict (review 5580558623). Two seats asked for changes: **pruner** and **decomplector**.

**Commit 1a10944b**, comment cuts (pruner 1 and 3):
- **Restating comments removed:** five comments that only repeated the name they sat on, in `clips/new-clip/types.d.ts` (3), `clips/new-clip/main.js` (1) and `src/endo/gateway/new-clip.ts` (1).
- **Mint route doc trimmed:** the JSDoc for `POST /account/clips/new` in `src/auth/guest-self-endpoint.ts` no longer restates admission. It keeps what a caller needs: the same-origin refusal, no request body, and 404 when minting isn't configured.

**Commit 2a04ab51**, changes to `designs/new-clip.md` § 3:
- **Decomplector 1 (must-fix):** the section now links the maintainer's 2026-10-17 directive for this build: garden journal `jobs/plan/mt-beta-new-clip-inventory.md` at commit 98f8b48ec0c, the only record I found of the "closed-beta product pass". The directive asks for a "+" button that creates entries, so the clip has to be writable. It doesn't say anything about #85, which asked for a session nonce before a live backend can be reached. The design now says this departure waits for the maintainer's confirmation before merge.
- **Pruner 2:** the "One pet-name grammar" and "Fail closed" bullets are now short pointers to the code headers that already explain them.

`tsc --noEmit` passes locally.

**Needs the maintainer:**
- **#85 confirmation:** I asked them through the maintainer inbox (message 20261020T050937Z-479285) to reply "confirm" or "gate writes behind the nonce". I didn't remove the write methods: the directive asks for them, and removing them would gut the feature.
- **Possible simplification:** decomplector 2 (should-fix) suggests that if the departure stands, part of the whole-space quota code can go. That follows from the maintainer's answer, so I left it for a later round.

**Tooling issues met along the way:**
- `message-user.sh` failed under the default `GARDEN_MSG_COALESCE=1`, because no stable `GARDEN_MSG_ID` was set; I sent with `GARDEN_MSG_COALESCE=0`.
- `ci-wait-merge.sh` ran past its own deadline. My first wait (3600 s) was stopped at the 10-minute background limit, so I watched the checks with a bounded `gh pr checks` loop. Once all 7 passed, I re-ran the script to confirm rc 0.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-2a490c1d-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1957530 cached reads)
- Output: 10726 tokens
- Cost: $1.2106580000000002
- Wall-clock: 1699s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
