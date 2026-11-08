PR #230 (kriscendobot/minion.town, "design(shell): the governor column, a ladder of increments") is now out of draft, at the same head commit the panel passed.

**Advisory appellate pass:** I ran a light `claude -p` (sonnet) review over the diff, which is the single file `designs/clip-governor-column.md`. It is advisory only and did not gate the un-draft. It flagged ten possible gaps the panel may have missed:
1. **Entry handles after a reconnect:** §3.1, §3.6 and §4.2 say a handle survives a socket drop with the same locator. CapTP exports die with their connection, which undercuts the main reason given for the locator.
2. **`destroy-incomplete` vs §3.7:** §3.7 says a method rejects only when it committed nothing, but `destroy-incomplete` is raised after some state has already committed.
3. **When `destroy` resolves:** the doc doesn't say whether `destroy` waits for the background cascade (§8.1) or what its returned list means if it doesn't.
4. **Missing open questions:** several unresolved items are not listed under `## Open questions`: capability revocation "not verified" (§5), whether `unpublish` closes connections "not verified" (§7), and §14 reopening the locator decision.
5. **Unlisted authority exception:** the agent's "may ask the model" capability (§17) is an exception to "no implicit authority" that §2 and §12 don't mention.
6. **Route count:** §3.2 counts the WebSocket upgrade as one of "three REST entry points", which conflicts with §15 and the §1 table.
7. **Undefined terms:**
   - how `hash` relates to the base32 id label
   - the full shape of `ClipSummary`
   - the shape of the `setView` argument
   - where the Replace picker gets its options
8. **Eject:** after an eject, it isn't specified which column governs the one now to its right.
9. **Rung order:** rung 4's exit criterion depends on retry and tombstone rules defined only in rung 5 (§8.1).
10. **References and assumptions:**
   - `api-transport-rubric` is not in the skills inventory, and its rows and overrides are never defined.
   - #231 is cited but missing from the appendix.
   - The relative design links resolve only if those files sit in the same `designs/` directory.
   - Browser behavior (SameSite, `Origin: null`) is stated as fact in §3.3, though §3.6 admits it is untested.

These would need a fixer job or a maintainer read if anyone wants them addressed.

**Un-draft gate:**
- **Before:** the PR was open, still a draft, at head `448b3479573d5ecbe768dc9648d9574dcefbcf54`, which matches the panel-passed commit.
- **Action:** ran `gh pr ready`, which succeeded.
- **After:** `isDraft=false`, and the head still equals `448b3479…`.

No garden repo changes or commits.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr230-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (242486 cached reads)
- Output: 1867 tokens
- Cost: $0.45594119999999994
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
