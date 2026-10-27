PR #1349 was already out of draft at the panel-approved head, so I didn't run `gh pr ready`: this stage was a no-op.

**Metadata checks** (`gh pr view --json isDraft,state,headRefOid`):
- **Before any mutation:** state OPEN, headRefOid `b43f86c0d3470b01603643fc538397cbeebbf366`, isDraft false. The head matches the commit the panel passed.
- **Final re-check:** isDraft false and headRefOid still `b43f86c0d3470b01603643fc538397cbeebbf366`.

**Advisory appellate pass** (does not block the un-draft): a light `claude -p` review of the full PR diff, without access to the repo source. It found nothing blocking. Points worth a later look, items 1 and 3 first:
1. **Repeat lockdown on XS:** `src-xs/lockdown-shim.js` now throws a `TypeError` if the `repairIntrinsics` callback never fires. If a repeated `lockdown()` with the same options returns early (the reviewer didn't confirm that path exists), a legitimate second call would throw on XS.
2. **Host changes aren't rolled back:** `tameTextCodecs` swaps the global codec constructors before the rest of `repairIntrinsics` can fail. If repair then fails, the host stays changed and nothing restores the originals.
3. **Detection checks only an own `arguments` property:** a host with only an own `caller`, or with accessor-style restricted properties, wouldn't be tamed, and lockdown would fail with the original #3369 symptom. Checking `caller` too would be cheap.
4. **Frozen codec prototype:** if a polyfill or another library froze the prototype before lockdown, `lockdown()` fails hard. The error message blames a second copy of SES, which is probably the wrong cause, and leaving the constructor in place would be a softer failure.
5. **Fidelity gaps in the replacement constructor:** the diff doesn't show the codec constructors registered with `markVirtualizedNativeFunction`, so they may stringify as source instead of `[native code]`.

No garden or project files changed, and no follow-up jobs were posted.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-conditional-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176583 cached reads)
- Output: 1417 tokens
- Cost: $0.41298460000000004
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
