I un-drafted kriscendobot/minion.town#206 ("fix(deploy): chunk and stage landing assets with digest-checked install"). It is now ready for review at head `6701f6802e617ed8373cddbcd1d1bd5744975883`, the same head the panel passed.

**Advisory appellate pass (did not gate the un-draft):** a light `claude -p` review of the whole diff found no significant correctness or safety issues. It read the diff but did not run the tests. It checked:
- **Chunking:** each chunk decodes on its own, and a retried run starts clean.
- **Digest check:** a bad chunk fails `sha256sum -c` before the `mv`, so the live file is untouched.
- **Isolation:** each run stages into its own directory, so overlapping deploys can't mix chunks.
- **Quoting:** no path for a filename to inject commands into the root shell.
- **Cleanup:** the reconcile glob and the one-day stage-directory prune are both safe.

Minor notes, not blockers:
- The `mv` is only atomic if `www-stage` and `www` are on the same filesystem. They are sibling directories, so this is almost certainly true, but a comment saying so would help.
- A failed run leaves its stage directory behind for up to a day, until a later reconcile prunes it. The PR documents this.
- Putting assets before HTML still only makes each file atomic, so a run that fails partway leaves a mixed tree. The PR documents this too.

**Un-draft gate:**
- **Before:** state was OPEN, head matched `6701f680…`, and the PR was still a draft, so I ran `gh pr ready`.
- **After:** `isDraft` is false and the head is still `6701f680…`.

No follow-ups needed. My inbox had no messages.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr206-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (173792 cached reads)
- Output: 1298 tokens
- Cost: $0.4012464
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
