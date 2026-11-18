## build-endopi-skills-lal-wiring: delta 5 is on #1643

I wired `@endo/skills` into Lal (`packages/lal`) and pushed it to the #1643 head branch `endopi-skills-markdown-format` as two commits: `24311d1d9c` (the feature) and `d92fc0d42c` (`chore: Update yarn.lock`). No new PR was opened. The full Lal suite passes (207 tests, 1 skipped), including 10 new ones. Lint shows no errors, `tsc` is clean and prettier has been applied. I have not run the scratch-daemon test (see below).

**What Lal now does**
- **Load at start:** each time a worker starts, it loads its skills once through `loadAgentSkills(powers)`. A load failure leaves the agent with no skills rather than stopping the worker.
- **System prompt:** the output of `formatSkillsForPrompt(listed, { readHint })` goes into a `skills` section of the system prompt. The read hint tells the model to call `readText(<location minus /SKILL.md>, "SKILL.md")` and to resolve relative references against the skill's directory path.
- **Reload on change:** Lal follows `agent-skills` with `followNameChanges`, and also watches for the `agent-skills` name itself appearing or going away. A change only marks the list stale. Before the next round, Lal reloads if the set of entries really changed and replaces the prompt section, so a round already running keeps its prompt. When the daemon replays existing names to a new follower, nothing reloads.
- **200-skill cap:** the prompt lists at most 200 skills, highest precedence first (later source, then name). The omitted ones are logged as a warning. That warning and all load diagnostics go to Lal's log, never to the model.
- **`/skill:` in the inbox loop:** a message starting with `/skill:<name> [args]` is expanded through `expandSkillCommand`, which rereads the current body through the skill's mount. The expanded text goes into the round's user message after the usual new-mail line. An unknown name gets an error reply and no model round. Skills marked `disable-model-invocation` still expand by command.
- **Docs:** the Lal README has a new Skills section, and I updated the #1643 description to cover item 5.

**A bug this fixed: Lal's system prompt wasn't reaching the model.** The current pi version (0.87) stores the system prompt as system messages in the transcript. The `@endo/agentry` harness's default `convertToLlm` keeps only user, assistant and tool-result messages, so it drops them. Lal now passes its own `convertToLlmWithSystem`. Any other `makePiAgent` user that relies on the default has the same problem, likely Fae too; it needs a fix in agentry itself, which I did not make.

**Tests** (`packages/lal/test/skills.test.js`)
- **Design's Lal rows:**
  - Adding an `agent-skills` entry changes the next round's prompt and not the current one. This is checked against a real pi agent's `state.systemPrompt`.
  - `/skill:` with an unknown name replies with an error and runs no round.
  - A `disable-model-invocation` skill is missing from the prompt but expands by command.
- **Also covered:** pet-name locations, an agent without `agent-skills`, rereading the body, the cap and its warning, and the name-replay no-op.

**Follow-ups**
- The test design-plan asks for a mount source checked against a scratch daemon; I have not built it. All the tests above use mock mounts.
- The agentry default `convertToLlm` fix described above.
- Fae gets the same wiring later, per the design.

Completing this job stages the gauntlet for #1643.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-skills-lal-wiring.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3938604 cached reads)
- Output: 30534 tokens
- Cost: $2.2740488000000005
- Wall-clock: 362s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
