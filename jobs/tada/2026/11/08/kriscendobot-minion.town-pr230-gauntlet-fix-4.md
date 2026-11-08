Fix round 4 for kriscendobot/minion.town#230 is pushed, and CI is green: `ci-wait-merge.sh --no-merge` returned rc 0 with 3 checks and 0 failures.

**Input.** No pre-pass block came with this job, so I worked from the latest panel verdict on the PR (review 5815915213, *Must-fix before merge*, from the skeptic, copyeditor and novice jurors). I applied all five must-fix items and several should-fix items to `designs/clip-governor-column.md`.

**Pushed.** One follow-up commit, `d0a7eac`, on `design/clip-governor-column` (`742cfb7..d0a7eac`), pushed with `safe-push-pr-head.sh` in advance mode.

**Must-fix items:**
- **Skeptic 1 (leaked locator now reaches destructive methods):**
  - §3.2 now re-checks the locator-only door against every method the facet gains (`clone`, `destroy` with its cascade, `select`, `setView`, `endow`), with a table by rung.
  - The gate holds only while every leak path reaches someone who already acts as the owner. If a rung adds a leak path that reaches anyone else, the subject check comes back before that rung ships.
  - Every rung from 2 on now has an exit-criterion line re-checking this. §3.3's "no escalation" bullet is qualified to match.
  - A new unit test covers a locator leaked to another signed-in user, which the design accepts on purpose.
- **Skeptic 2 (clone invariant):** "a clone never amplifies" now applies only to rung 2's plain Clone. Rung 3's Replace explicitly breaks it, and rung 3 keeps the weaker rule: at most the owner's own authority.
- **Copyeditor 1 (are plan names matched or resolved?):** §6 now says names are matched against the source's entries only to pick a slot, and are never looked up anywhere to get a reference. Keep copies the source's own reference, and only a `from` handle carries authority.
- **Novice 1 and 2 (opening too dense, terms used before defined):** added an "In plain terms" opening and a glossary covering CapTP, facet, powerbox, locator, door, swissnum, bearer test, and the rubric rows and overrides. The glossary is checked against the garden's `api-transport-rubric` skill. "Grounded against" moved to an appendix.

**Should-fix items also done:**
- The cross-browser premises are marked as assumptions until a real-browser run passes them.
- A stuck destroy cascade is now shown to the owner: a `stuck` field in `list()` and a persistent notice with a Retry button. The "stops serving" exit criterion is met only once the cascade has finished.
- It now says that a `destroy` on a stuck subtree tries once more before rejecting with `destroy-incomplete`.
- One list of REST routes is used in both places, and it says the WebSocket upgrade is not REST.
- The rung 2 note on governor-mediated entries now says it takes effect at rung 9.

**Not done:** skeptic 5 (whether the owner's select should take priority over the governor's) changes a design decision, so I left it for the maintainer. I also left the remaining comment-only and lower-priority novice items, including the diagram and the worked flow.

**Environment issues:**
- `ensure-project-worktree.sh` failed with a read-only file system error under the monk sandbox, even though `7fd074b62d5` was meant to fix that. I used the known workaround and cloned the branch into `$TMPDIR`.
- CI sat queued with nothing running from 01:22 to about 01:53Z, the known ci.minion.town runner stall, then completed on its own.
- My first `ci-wait-merge` run went to the background and was killed at its time limit. I polled in the foreground, then re-ran `ci-wait-merge` to get rc 0.

**Next:** the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr230-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1459242 cached reads)
- Output: 12563 tokens
- Cost: $1.2686123999999999
- Wall-clock: 2039s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
