---
handed-off: build-endopi-skills-lal-wiring
deliverable-complete: false
---
I reworked draft PR #1643 for the revised design (#1672) and pushed it. Five of the design's six "Delta from #1643" items are done (1–4 and 6). The fifth, wiring the skills into Lal, is not built: I posted it as a new job, `build-endopi-skills-lal-wiring`.

**Done (commit `e6e5a33d86`, plus a separate `chore: Update yarn.lock` commit):**
- **Setup script (item 1).** `endo-skills-setup <agent> [--no-cross-harness]` mounts each skill folder that exists, read-only, as `<agent>/agent-skills/<NN>-<label>`. The number prefix keeps the precedence order. A rerun replaces only the entries the script wrote before and leaves the rest alone.
- **Skills from mounts (item 2).** The new `@endo/skills/mount.js` loads the skills an agent holds under `agent-skills`. Their locations are pet-name paths like `agent-skills/03-agents-user/x/SKILL.md`, which the model can read with `readText`.
- **Prompt wording (item 3).** `formatSkillsForPrompt(skills, { readHint })` lets a host word its own reading instructions. The old filesystem wording is now only the default.
- **Validation (item 4).** The validator now matches the design's rules table. A `compatibility` field over 500 characters, a non-boolean `disable-model-invocation`, non-string `metadata` values and unsupported YAML lines all produce warnings. Names with doubled or edge hyphens already warned.
- **Design doc (item 6).** The design doc's "Implementation notes" section now points to #1672. The package README, the changeset and the PR description are updated, and the PR now carries this job's marker.
- **Tests.** I added `validate`, `mount` and `setup` test files. All 36 package tests pass locally, the type check is clean, eslint reports no errors and prettier passes.

**CI on #1643:** lint passes and the full test matrix is still running. Three checks fail, all apparently unrelated to this change:
- `test-xs`: the same failure as before this rework, also seen on sibling #1640.
- `sandbox-drivers`: a bwrap test timed out, with "process group survived bounded cleanup".
- `zizmor`: it exited with code 13, and this PR doesn't touch any workflow files.

**Not done:** wiring into Lal (item 5) is posted as `build-endopi-skills-lal-wiring`. That job covers:
- loading the skills when the agent starts;
- following name changes on `agent-skills`, with a change taking effect at the next round;
- the 200-skill cap;
- `/skill:` expansion in the inbox loop, where an unknown name gets an error reply and runs no model round;
- the design's Lal tests.

**Other follow-ups:**
- The shared folder walker (`listConventionalDirectories`) should live in whichever of #1643 and #1640 merges first, and the other should import it.
- The skill-registry bridge (Phase 4) is still waiting on `endoclaw-skill-registry`.
- The design's one open question is still the maintainer's: whether the Claude Code and Codex skill folders are scanned by default. The build follows the design's recommendation: they are, and `--no-cross-harness` turns them off.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-skills-markdown-format.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4116012 cached reads)
- Output: 29505 tokens
- Cost: $2.2723824000000006
- Wall-clock: 1048s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
