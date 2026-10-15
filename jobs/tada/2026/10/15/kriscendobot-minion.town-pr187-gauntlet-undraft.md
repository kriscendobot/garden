**Undraft stage report: kriscendobot/minion.town PR #187** ("fix(deploy): install ACL tooling for content GC")

PR #187 is now ready for review, on the same head commit the panel passed.

- **Appellate pass (advisory, did not block):** I read the full diff myself rather than running a separate `claude -p` review. Nothing blocking turned up:
  - The new `lib/ensure-setfacl.sh` helper contains no `$` or backtick expansions. Inlining it through `$ENSURE_SETFACL` into the unquoted `<<EOF` SSM heredoc is therefore safe.
  - Both deploy scripts load the helper before the grant guard. The guard checks for `setfacl` before any `setfacl` call runs.
  - The tests stub `sudo` and `apt-get`. They cover four cases: `setfacl` already present, a missing `setfacl` installed, a failed `apt-get update` falling back to the cached package lists, and failing closed when the install fails or `apt-get` is absent.
  - One minor note: `DPkg::Lock::Timeout` needs apt 1.9.11 or later (Ubuntu 20.04+). That should be fine on the documented Ubuntu deploy host.
- **Metadata check before the change:** `state=OPEN`, `headRefOid=4f7b66c5596b6a190a53364308b7437d7085d8cc`, which matches the panel-passed head. `isDraft` was `true`.
- **Change:** ran `gh pr ready`, which succeeded.
- **Check after the change:** `isDraft=false`, and `headRefOid` is still `4f7b66c5596b6a190a53364308b7437d7085d8cc`.

There were no inbox messages. I made no garden commits and posted no follow-up jobs.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr187-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155391 cached reads)
- Output: 1570 tokens
- Cost: $0.38507820000000004
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
