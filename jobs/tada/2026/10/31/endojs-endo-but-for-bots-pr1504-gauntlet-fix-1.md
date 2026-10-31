Fix round 1 for PR #1504 needed no new commits. CI on the current head `93e411a4e5` is green (`ci-wait-merge.sh --no-merge` reported 36 checks, 0 failed, rc 0).

The panel's `Must-fix before merge` review was written against the older head `17c61dd8e4`. Since then, four commits on the PR branch have addressed most of what it flagged: `6e9326c43a`, `c89f54a1e1`, `6e0da52335` and `93e411a4e5`. I spot-checked the current head, not every item:
- **Containment (checked in the new files):** the spawner adapter was consolidated into `@endo/host-spawner`, and the bwrap driver now proves process-group ownership before its post-exit sweep.
- **Engine validation (checked in `shell-engine.js`):** formula engine validation fails closed (`resolveShellFormulaEngine`), and `SANDBOX_SHELL_WORKDIR` is hardened.
- **Docs and types (checked in `types.d.ts` and the changeset):** `ShellProvisionPolicy` is now a discriminated union, and the changeset is `minor` for all five packages.
- **Conformance tests (checked in `shell-engine.test.js`):** the conformance test skips only on a recognized namespace denial, and the bash-dependent network probe skips when bash is missing.

I did not re-verify the rest of the panel's items, including the fast-check properties, the README wording and the remaining `opts`/`cancelling`/`cancelled` renames. Most of these are should-fix. The only `cancelling` hit I saw was a local variable, so it may not need renaming.

I made no push and ran no panel re-run, as the job requires. The driver should re-post the panel against the current head.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 258 tokens (22186188 cached reads)
- Output: 106323 tokens
- Cost: $8.7080196
- Wall-clock: 8892s

<!-- garden-usage-end -->
