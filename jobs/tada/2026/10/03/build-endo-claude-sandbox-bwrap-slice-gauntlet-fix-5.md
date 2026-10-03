Fix round 5 for endojs/endo-but-for-bots PR #1408 is complete and CI is green. A previous worker on this job had already pushed both fixes the panel asked for, so I checked them and made no new commits.

**What the panel-5 review required** (head `3d02782072`, verdict must-fix):
1. **changeset-auditor:** the new bwrap-slice sentences in `.changeset/add-endo-claude.md` were single lines of 150–213 columns and needed wrapping.
2. **surfacer:** `packages/claude/README.md` § The `bwrap` slice did not name the newly exported functions, constants and type.

**Commits that address them** (both pushed 2026-10-02T03:15Z, before I claimed the job):
- `6593276ca` "chore(claude): wrap the bwrap slice changeset and note its grant and …". In the project worktree at head `d266f8a841`, no line in the changeset is over 100 columns. Going by its title, this commit also covers the packager seat's should-fix (the changeset now notes the package-directory-only grant and that nested user namespaces are disabled). I only checked the line lengths, not that wording.
- `d266f8a84` "docs(claude): document the exported bwrap slice building blocks". The README now says these are importable from `@endo/claude`: `makeBwrapSpawn`, `assembleBwrapArgv`, `resolveSystemMounts`, `SYSTEM_DIRECTORIES`, `SYSTEM_ETC_ENTRIES`, `DEFAULT_SCRATCH_HOME` and the `SliceMount` type.

**CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1408 --no-merge` returned rc 0, with 35 checks and 0 failed, on head `d266f8a841`.

**Next:** the gauntlet driver re-posts the panel as panel-6. The panel's comment-only items are still open and are not blocking: the assessor flagged unreachable defensive throws and an unused `unsandboxedLaunch` in `confined-turn.js`, and the prover noted there is no dedicated test for the `--bwrap` CLI flag.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 68 tokens (2283897 cached reads)
- Output: 10854 tokens
- Cost: $2.7717224
- Wall-clock: 3870s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
