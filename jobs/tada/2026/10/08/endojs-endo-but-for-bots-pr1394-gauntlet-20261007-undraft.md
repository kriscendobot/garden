**Gauntlet undraft stage: endojs/endo-but-for-bots PR #1394** ("feat(captp,ocapn): layer 5 — CapTP mints SturdyRefs and carries them over the wire")

**Result: nothing to do.** The PR was already ready for review, so I did not run `gh pr ready`.
- Before any action, the PR was open, `isDraft=false`, and its head was `75167825778c18a2276f9572c6665e4e5fe150e4`, the exact commit the panel passed.
- I checked again afterwards and got the same result: still open, not a draft, same head.

**Advisory second-opinion review** (a light `claude -p --model sonnet` pass over the 925-line diff; it does not block anything). It found nothing that clearly breaks, but raised these points to confirm later:
- **Possible leak:** an imported `s` slot might never send `CTP_DROP`, because `makeSturdyRefForSlot` skips `makeValueForSlot`. The reviewer could not see whether the finalizer still covers `s` slots.
- **Load from peers:** any peer holding an `s-N` slot can call `enliven()` over and over with no limit. On OCapN each call can open outbound sessions.
- **Error leak:** when the origin's `enliven` fails, its error (which can name the internal location) is sent back to the peer.
- **Loose routing check:** a target is sent down the SturdyRef path whenever its first character is `s`. A stale `s-N` target is a protocol failure that ends the connection.
- **Silent break for other code:** SturdyRefs are no longer `'tagged'` pass-style. Only the thixotrope test was updated, so other code in the monorepo that checks for `'ocapn-sturdyref'` should be searched for.
- **Unusable refs:** the top-level `makeSturdyRef` can still create refs with no client attached. These look like normal SturdyRefs but always fail when enlivened.

**Changes:** none to the garden repo, and none to the project beyond confirming the PR's state. No follow-up jobs were posted. The points above are worth a look if a reviewer wants them chased.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-gauntlet-20261007-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (162673 cached reads)
- Output: 1465 tokens
- Cost: $0.37721059999999995
- Wall-clock: 60s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
