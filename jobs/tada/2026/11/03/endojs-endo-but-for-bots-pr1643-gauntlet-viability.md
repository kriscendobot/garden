**Viability report: endojs/endo-but-for-bots#1643**

The PR is OPEN, not merged, and still a draft. It was opened 2026-11-03T02:12Z and has no reviews or comments yet. Its head is `e97d478e0f` and its base is the frozen `llm-48d6f3e`. It adds a new `@endo/skills` package that implements the `endopi-skills-markdown-format` design (M10). The package covers `SKILL.md` frontmatter parsing, discovery across several tools' skill directories, the `<available_skills>` system-prompt listing, and the `/skill:` command.

Deciding question: Does live `llm` still lack a SKILL.md parse/discover/prompt implementation, with the `endopi-skills-markdown-format` design still unimplemented, so that this PR is the only one delivering it?

Evidence:
- **No code on `llm`:** `packages/skills` does not exist on `llm` (404). The only skill-related paths in the tree are the `.claude/skills/endo` content and `packages/fae/endo-skill.js`. Neither is a SKILL.md loader.
- **Design still open:** `designs/endopi-skills-markdown-format.md` on `llm` is still "Status: Proposed". The PR moves it to In Progress.
- **No competing PR or commit:**
  - Searching PRs for "skills" in the title finds only #1643 and #1639.
  - #1639 (`endo install`, the package manifest work) complements this PR rather than replacing it. It only copies skills into `.agents/skills/<name>/`, which is one of the directories #1643 scans. It does not parse skills, list them in the prompt, or expand `/skill:`.
- **No newer history covers it:** the `llm` commits since 2026-11-01 are only dependabot bumps and test fixes.
- **Premise still holds:** the parent `endoclaw-skill-registry` design still covers only the daemon side, and the PR's deferred bridge to it is called out explicitly. The need for an on-disk skill format remains.

Both claims hold: the PR has not been superseded, and the need behind it still exists. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1643-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (182422 cached reads)
- Output: 1572 tokens
- Cost: $0.4451164
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
