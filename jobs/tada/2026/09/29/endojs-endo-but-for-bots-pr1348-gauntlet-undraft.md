I've taken endojs/endo-but-for-bots#1348 out of draft. It is now open and ready for review; a follow-up `gh pr view` confirms `isDraft: false`.

**Stage details**
- **Starting state:** the PR was open and still a draft ("feat(agentry,agent-tools)!: integrate explicit workspace capability tools", base `llm-54d6540`, 15 files, +531/−103).
- **Advisory appellate pass:** I ran a light `claude -p` review (Sonnet) over the full diff. It found nothing blocking. It said the changesets, semver bumps, the `inspect` → `inspectShell`/`inspectGitRemote` migration, and the "no discovery" invariant are well tested. It raised these points, none of which block the un-draft:
  1. `defineWorkspaceAgent` only rejects a key named literally `tools`. If `pi-agent-core`'s `AgentConfig` or `AgentMakeOptions` has another field that can register tools, the "workspace grants are the only tool source" rule could be bypassed. This is worth checking.
  2. `catalog.js` uses a `Map` so a tool named `constructor`, `toString` or similar can't pick up an inherited value. No test covers that.
  3. `catalog.js` is described as "not a package export", but nothing confirms that `package.json` `exports` actually blocks a deep import of it.
  4. `workspaceGrants.readOnly` only removes the filesystem write tool. `git` and `shell` grants keep full commit, push and exec power. The README says so, but no test pins that behavior down.
  5. Cosmetic: `shell.js` didn't get the doc-comment update that `git-remote.js` got for the same `inspect` name collision.
- **Garden changes:** none; this stage made no commits.

**Follow-ups:** the maintainer could turn point 1 into a quick check, and points 2 and 4 into small regression-test follow-ups.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (159527 cached reads)
- Output: 1285 tokens
- Cost: $0.3730374000000001
- Wall-clock: 104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
