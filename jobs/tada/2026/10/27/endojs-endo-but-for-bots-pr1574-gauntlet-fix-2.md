Fix round 2 for endojs/endo-but-for-bots#1574 is done: one follow-up commit is on the PR head and CI is green on it (30 checks, none failed, `ci-wait-merge` rc 0).

The job carried no pre-pass block, so I worked from the latest panel review (5662799805, "Must-fix before merge"). Commit `a67ddb75b6` was pushed with `safe-push-pr-head.sh` in advance mode, moving the head from `a4afa2b125` to `a67ddb75b6`. It changes `designs/api-key-agent-workbench.md` and `designs/README.md`.

**Must-fix items**
- **Admission atomicity (skeptic 1):** the design now says how admission stays atomic. The broker runs one in-vat queue per provider. Each admission, settlement, cancellation and grant-state write is one entry on it, and no entry waits on a remote call. Running totals per grant are kept as derived values, which also covers critic 4. W3 gains a counted test: 16 concurrent sibling requests against a budget that fits 5 admit exactly 5.
- **Settlement and period resets (skeptic 2, critic 5):** a turn admitted before a budget reset and settled after it is charged only to the closed period. A revoke cancels the in-flight turns of every descendant at the moment of the revoke. Those turns are charged under #1543's existing cancellation rule, not a new penalty. Revoking a child with nothing in flight costs nothing. Matching tests were added.
- **`askSubagent` result (ergonomist 5, critic 1, skeptic 6):** it now checks the child's status before sending. If the child is paused or revoked, it sends nothing and returns `{ status: 'not-sent', reason }`. The design states the remaining race: a pause that lands after the check releases the ask at Fae's ask timeout (at most 3600 s), not after 72 hours.
- **Fae limit labels (archivist 1):** corrected to match `packages/fae/SUBAGENTS.md` and `workload-limits.js`.

**Should-fix and comment items applied**
- **Control and endowment ownership:** the provider registry is the only committer for every control method, and the factory's `deleting` mark follows from it. The agent record's endowment list is the source of truth, and the guest's pet-store names are a copy rebuilt from it. `parentGrantId` is the canonical ancestry and `grantPath` an index of it.
- **API shape:**
  - `stop` is removed from `AgentSpawner`; a Fae adapter keeps it as `revoke`.
  - `resize` merges, keeping the recorded value of any field it leaves out.
  - `limits` is now the effective reading, and `blockedBy` no longer repeats `state`.
  - Endowments use one entry shape with a `source` field, and errors name the entry.
- **Clarified wording:**
  - The forbidden-endowment check is now described as catching only directly passed facets; the budget chain check is what bounds spend.
  - The design states how much work can still run after a pause.
  - Parent-vs-children starvation is now part of open question 2.
- **Citations and provenance:** glorp's history now cites commits `d117f74f12`, `8b9241f127` and `3aa902d003`, and the section references were corrected. The metadata now says the claims were checked by reading, not by running anything.
- **Edits and cuts:** the copyeditor's items (definitions at first use, `readOnly()` list consistency, numbered decisions, OQ5 title, W6 step 5, acronyms) and most pruner cuts. In the README I removed the "this pass adds" narration and broke the 3–3.5 week estimate down by phase.
- **PR body:** cut from about 580 to about 200 words, keeping the `garden-job` marker.

**Declined:** the pruner's suggestion to delete the Ownership map. Garden design convention needs it and the decomplector reviews against it, so I corrected its rows instead.

**Follow-ups:**
- The design now asks #1543's phase 2 to adopt this queue for admission. #1543's own text may need a matching note.
- Panel-3 is next; the driver re-posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2439975 cached reads)
- Output: 24243 tokens
- Cost: $1.8501109999999996
- Wall-clock: 729s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
