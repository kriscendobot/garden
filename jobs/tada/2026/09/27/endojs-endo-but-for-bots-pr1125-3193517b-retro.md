I recorded this retro as a **miss** in a new cluster. The cluster has one miss from one PR, so it is below the dispatch floor and I posted no improvement job.

**Idempotency:** no record existed yet for `endojs-endo-but-for-bots-pr1125-3193517b` in `review-misses/misses/` or `review-misses/dismissed/`. The prior attempt had recorded nothing, so this was a fresh run.

**What I checked (read directly, not taken from the primary's report):**
- **The comment:** kriskowal replied in the retention-pin thread on `manager.js`. Paraphrased: invite already takes a result name that holds on to the invitation while it is pending, and replaces itself with the acceptor's handle on accept. The implication is that the extra guest pin is redundant.
- **The thread:** the earlier mentat adversarial review (`retention-pin-adversarial-5201186153`, reply r4009312397) had concluded "the pin must exist" and recommended no code change.
- **The primary job (tada 2026-09-15):** it traced the pin. On accept, the code minted a separate local guest and pinned it under `@pins/guest-*`. That guest was only needed for synchronized pet stores, which commit `d0ce26b327` removed. Nothing named or exported it after that, so each accept pinned a formula chain nothing else could reach. The fix, commit `546dc5dbdb` ("use invitation result names as connection roots"), removed the mint and the pin.
- **The fix exists:** #1125 was closed and split into #1304, #1306 and #1305, all merged into `llm`. `llm`'s `manager.js` no longer contains `guestPinName`.

**Why it counts as a miss:** the pin was already on `llm` before #1125, but #1125 added a collision-proof encoding for its key.
- Six panel rounds hardened that key and never asked what the retained guest was still used for.
- The maintainer then asked a targeted adversarial review why the pin needed to exist, and it defended the leftover code.
- This isn't evaluator-gaming: the change didn't alter what any check measures.

**Record:** `review-misses/misses/endojs-endo-but-for-bots-pr1125-3193517b.md`
- Category `correctness-bug`, severity minor.
- `missed_by`: the breaker/saboteur code-panel seats and the adversarial-review job.
- New cluster `vestigial-mechanism-unquestioned`. Its pattern: a PR extends or polishes an internal mechanism whose last user an earlier refactor removed, or whose job an existing mechanism already does, and review hardens it without asking what still uses it.

**Threshold:** the cluster has 1 miss from 1 PR, so it stays open with no dispatch. The severity bypass doesn't apply: no existing rule required asking what uses a mechanism before hardening it. `roles/COMMON.md`'s rule about checking for an existing equivalent covers only public surfaces.

**Follow-ups:** none now. If two more misses of this shape arrive, from at least one other PR, they would trigger a `review-improve-vestigial-mechanism-unquestioned` job. A likely fix would be a breaker/decomplector check along the lines of "when changing a retention or mint path, name its current consumer."
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-3193517b-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 26 tokens (849103 cached reads)
- Output: 7079 tokens
- Cost: $0.8950965999999999
- Wall-clock: 96s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
