I've fleshed out the `endopi-skills-markdown-format` design and opened it for review as draft PR **endojs/endo-but-for-bots#1672**. The PR is based on the frozen snapshot `llm-0368767` and changes only two files: `designs/endopi-skills-markdown-format.md` and its row in `designs/README.md`.

**Starting point.** A builder had already implemented the format library in draft #1643 (a new `@endo/skills` package), but it isn't connected to the agent (Lal) yet. Lal runs confined and can't read the disk, and the design never said how skill files would reach it. The sibling prompt-templates design (draft #1671) solved the same problem with read-only mounts, so I used that approach here.

**What the design now settles:**
- **Frontmatter rules:** a table of each key (the agentskills.io keys plus Pi's `disable-model-invocation`) saying which problems are warnings and which are errors. Skills written for other harnesses load with warnings, as in Pi. It also defines the subset of YAML that gets parsed and a 1 MiB file cap.
- **How skills reach Lal:** a new pet name, `agent-skills`, names a directory of read-only mounts. It isn't called `skills` because the existing skill-registry design already uses that name. A Node setup script, `endo-skills-setup`, creates the mounts using the directory walker shared with #1671, and running it is the user's grant. The design fixes which directories it scans and in what order, which answers the old question of where project-local skills live.
- **System prompt:** the skill list is built once each time the agent starts and rebuilt when entries are added or removed. Rebuilding every round was rejected because it defeats prompt caching. Skill locations are paths the model can pass straight to `readText`, and the list is capped at 200 skills.
- **`/skill:name`:** expanded in Lal's inbox loop from the current file. An unknown name gets an error reply and no model run, and the transcript records the expanded text as an ordinary user message.
- **Authority:** `allowed-tools` is advisory only. Enforcing it would mean checking tool names at call time, which is the kind of allowlist this codebase avoids. A skill that comes with real capabilities belongs to the registry work later. Lal has no shell, so helper scripts in a skill are never run, only read.
- **For reviewers and the builder:** an ownership map, a security note, a test plan, and a "Delta from #1643" list of changes that PR needs.

The sequence diagram passed a parse check.

**Left open for the maintainer:** one question, whether the setup script should scan `~/.claude/skills` and `~/.codex/skills` by default. I recommend yes, with a `--no-cross-harness` flag to opt out.

## Follow-ups
- The build is the rework of draft #1643 according to the design's "Delta from #1643" list (setup script, mount-backed skill source, configurable prompt wording, checking the validator against the rules table, and wiring into Lal). The existing build job `endopi-skills-markdown-format-build` owns that PR.
- The shared directory walker should live in whichever of #1643 or #1640 merges first, and the other should import it.
- The bridge to the skill registry (Phase 4) waits on `endoclaw-skill-registry`.

<!-- garden-design-build-handoff: successor=build-endopi-skills-markdown-format state=recheck:endojs-endo-but-for-bots-pr1672-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1672 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endopi-skills-markdown-format.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2009133 cached reads)
- Output: 16861 tokens
- Cost: $1.4487106
- Wall-clock: 411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
