Fix round 6 for endojs/endo-but-for-bots PR #241 is done: the one must-fix item is applied and pushed, and CI is green.

- **Must-fix item:** the panel-6 review (5070831976, against f9b89e025) has one must-fix finding, from the skeptic. Its summary line says "Two must-fix findings", but the body contains only one. The finding: Case 2's option to rebuild `node_modules` from the content-addressed module store cannot handle native modules, binaries built by `postinstall`, or phantom imports. Native modules are the reason Case 2 exists.
- **Fix:** a prior attempt of this job had already pushed it as `e277aabf00` on `design/familiar-run-vfs-apps` (+19 lines in `designs/familiar-run-apps-vfs.md`). I confirmed it covers the finding. It limits that option to source-only packages with no native or `postinstall` step, calls choosing it for a native-dependent package a configuration error, and sends those packages through the `npm install` sub-mount path. No new edits were needed, so I pushed nothing in this run.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 241 --no-merge` returned rc=0, with all 5 checks passed.

**Follow-ups:** the panel's should-fix items are left for panel-7 to weigh:
- **critic:** the fail-closed version-conflict check assumes the `mvs-resolver.md` algorithm already does something its sketch doesn't do.
- **skeptic:** the test catalog has no tests for the guest-caplet authorization claims.
- **decomplector:** the "registry-table snapshot identity" used as a cache key is never given a concrete shape.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 66 tokens (1932650 cached reads)
- Output: 12470 tokens
- Cost: $2.1996592000000006
- Wall-clock: 382s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
