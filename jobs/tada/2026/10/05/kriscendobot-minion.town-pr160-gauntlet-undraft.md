PR kriscendobot/minion.town#160 ("fix(claude): reach each guest through the upstream broker, never the root socket") is now marked ready for review. Before this stage it was OPEN and still a draft, so this stage was not a no-op. It is still OPEN with `isDraft:false`, at head `ae967c4b`.

**CI at that head:** all three checks pass ("Claude harness (amd64)", "Claude harness (arm64)" and "test").

**Advisory appellate pass:** I did not run the separate `claude -p` review the stage describes. Instead I read the core source diff myself (`claude-guest-bridge.ts`, `cli-launch.ts`, `root-host-socket.ts`). The test files were not reviewed. Nothing found should block the un-draft. Notes:
- **Broker lifecycle looks sound.** There is one broker per guest. A failed start and a closed connection each remove the entry, and the `brokers.get(id) === started` guard keeps a newer broker from being torn down by an older one. Removing a child closes its broker. The broker directory is swept once per process before the first broker starts.
- **`streamJsonArgv` stops the stream flags appearing twice.** It adds `--output-format stream-json` and `--verbose` only if they are missing, and fails if the harness asks for any other output format. That is an improvement.
- **Possible gap:** a regression test that a confined session cannot connect to a sibling guest's socket is explicitly deferred to #162. Guests share one unix user, so only tool confinement keeps them apart until that test exists.
- **Deploy risk:** the PR changes the pinned Endo commit from `1706e63` to `9174aad`. CI starts from an empty store, so it cannot catch a crash-loop when the new version migrates the production database. After this deploys, check the daemon over SSM (`NRestarts`, journal) per the minion.town pin-bump verification practice.

**Follow-ups:** the #162 sibling-socket test, and the post-deploy daemon check for the pin change.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr160-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (211149 cached reads)
- Output: 1642 tokens
- Cost: $0.42454179999999997
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
