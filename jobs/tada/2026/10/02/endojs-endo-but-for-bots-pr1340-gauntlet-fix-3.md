## Gauntlet fix round 3: endojs/endo-but-for-bots PR #1340

I applied the panel-3 fixes to `designs/agent-confined-application-makers.md` in one commit. It was pushed to `design/agent-confined-application-makers` with `safe-push-pr-head.sh`, moving the head from `7fa9ac097d` to `5d8b95b412`. CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 28 of 28 checks passing and none failed.

The fixes come from panel review 5386564848. Must-fix items:
- **novice:** Added a vocabulary paragraph near the top defining host/guest, facet, name hub, formula/incarnation/reincarnation, what "confined" guarantees, and what "makers" are.
- **skeptic, mount `canonical`:** `makeTreeReadPowers` now takes an optional `canonical(segments)` hook and defaults to the identity. For mounts, the daemon supplies the hook from the host-private `getEntryPhysicalPath`. The design now says plainly that `MountInterface` exposes no physical path and that this wiring is new Phase 2 work.
- **skeptic, tests:** Added Yarn `nodeLinker: pnpm` (the linker this repository uses, with in-root `node_modules/.store`) to the layout test matrix. Also added a positive end-to-end `node-modules-with-map` test through `captureFromMap`.
- **decomplector:** The formula now records only the requested layout (the caller's value, or `'detect'`), which is fixed when the formula is created. The detected layout is treated as a live per-incarnation fact that the inspector and result text report. Added a matching test.
- **copyeditor:** Replaced `→` with ASCII `->` in the ownership-map table.
- **pruner:** Merged Decisions 5 and 6 into one "considered and rejected: capture once at formulation" decision, and updated the cross-reference. I left the PR-body template sections alone, because the panel's own binding override says to keep every template heading.

Should-fix items, also applied:
- **critic, worker entry point:** The "one worker entry point" claim now covers only the new layouts. The existing `'archive'` layout, where a Node worker still packs the tree itself, is stated as out of scope and left as a follow-up.
- **critic, guest helper:** The guest now gets a shared helper split out of the host's `prepareMakeCaplet` in Phase 4, instead of reaching the host-private closure. The ownership map and phase list are updated to match.
- **ergonomist:** The layout table now says the `'archive'` layout is a tree laid out like an archive, not the blob that `makeArchive` takes.
- **pedant:** Inline repository paths are now relative (`../packages/daemon/src/...`).

Follow-up: moving the Node worker's `'archive'` layout onto daemon-side capture is named in the design but not posted as a job. Per the job instructions I did not re-run the panel; the driver will post panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (935432 cached reads)
- Output: 8332 tokens
- Cost: $0.8867744000000001
- Wall-clock: 770s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
