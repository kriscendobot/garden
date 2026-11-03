I built the `endopi-skills-markdown-format` design as a new `@endo/skills` package and opened draft PR endojs/endo-but-for-bots#1643. Lint passes and the package's own 17 tests pass locally; `test-xs` fails, though not because of this change; the full test suite was still running when I stopped watching.

**What the package does:**
- **Reading a skill.** It reads a skill's `SKILL.md` and its header fields. Like Pi, it is lenient: a skill with no description is skipped, and any other rule break (name format, name not matching its folder, field too long) only produces a warning.
- **Finding skills.** It scans the Claude Code and Codex skill folders, then Pi's and `.agents` folders in the home directory, then the project's `.agents/skills`, `.claude/skills` and `.pi/skills`. When two folders define the same skill name, the project one wins and a warning is reported. An option turns off the Claude Code and Codex folders.
- **System prompt.** It renders a short list of each skill's name, description and file location, and leaves out skills marked as not for the model.
- **`/skill:<name>`.** It expands that message into the skill's full text, followed by any arguments.

The design doc is now marked "In Progress" (also in the `designs/README.md` index). A new "Implementation notes" section records how the build answers the design's open questions: all three project skill folders are scanned, project folders take precedence, `allowed-tools` is read but not enforced, there is no cache, and it reads a small subset of YAML without a YAML library. There is also a package README and a changeset.

**Checks and CI:**
- Locally in `packages/skills`: the type check is clean, eslint reports no errors and prettier passes.
- **CI:** lint passed.
- **`test-xs` fails.** It's a `@endo/hardened262` `intrinsic-metadata.js` failure on the sesNode leg. Sibling PR #1640, on the same base, fails the same way.
- **Full test matrix:** it was still running when I stopped watching after about 30 minutes. The automatic follow-up review chain will pick it up.

**PR base:** the PR targets the frozen snapshot `llm-48d6f3e`, which is the current tip of `llm`.

**Not built yet:**
- **Daemon-formula bridge** (phase 4): this waits on `endoclaw-skill-registry`.
- **Wiring into Lal:** Lal's system prompt and `/skill:` handling don't use the package yet. Lal first needs a way to reach the skill folders, like the read-only folder access Chat's prompt templates get in #1640.
- **Shared folder walker:** `@endo/prompt-templates` (#1640) and `@endo/skills` each have their own folder-scanning code. It could move into one shared module once both have landed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-skills-markdown-format-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3371831 cached reads)
- Output: 31950 tokens
- Cost: $2.0986862000000004
- Wall-clock: 2713s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
