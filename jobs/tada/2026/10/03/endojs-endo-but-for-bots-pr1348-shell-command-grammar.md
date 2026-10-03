# Completion report — endojs-endo-but-for-bots-pr1348-shell-command-grammar

**Done.** PR #1348's Shell capability was reworked per kriskowal's directive (comment 5942897069): the `allowedCommands` command-name allowlist is replaced by **passable command grammars** that constrain the argument language, with first-class narrowing-only **attenuation**. Five follow-up commits pushed to `build/daemon-agent-tools-explicit-harness` (`cb763267fc..6d9e2ee2b4`), CI fully green on the new head (18 pass / 0 fail / 15 path-skipped), and a summary comment replying to the directive posted: https://github.com/endojs/endo-but-for-bots/pull/1348#issuecomment-5965228415

## What changed

- **Design first** (`designs/daemon-agent-tools.md`): new § Command grammars (element vocabulary: literals, typed `string`/`path` slots, option unions with prefix flags, optional/repeatable flag-value groups, variadic rest; frontier-set matching; usage rendering; attenuation by delegation), with § The honest boundary, Design Decisions 4–5, and the construction example updated. The honest residue is stated plainly: the grammar bounds what can be *asked for*; the started child's OS authority still awaits the Phase 2c sandbox engine.
- **`@endo/exo-shell`**: new `command-grammar.js` (validator/normalizer, O(elements×tokens) memo-free frontier-set matcher, deterministic usage renderer). `ShellPolicy.commands` replaces `allowedCommands`; `exec` matches the full argv before any spawn; slot values can never read as option tokens and `path` slots are lexically worktree-confined (no absolute, no `..`). New `Shell.attenuate(commands, { timeoutMs? })` chains facets that delegate to their parent — intersection by conjunction, so a derived shell can only narrow and no grammar-inclusion proof is needed. `inspect()` returns `{ commands, usage, timeoutMs, maxOutputBytes }` behind a still-closed returns-guard.
- **`@endo/daemon`**: `provideShell` validates grammars before the formula persists and loudly rejects the retired `allowedCommands` key; a persisted pre-grammar shell formula refuses to reincarnate (no widening-free translation exists) with a re-provision instruction.
- **`@endo/agent-tools`**: `makeShellTool(shellCap, { commands })` embeds rendered usage lines in the `exec` tool description and pre-matches argvs tool-side; `attenuate` is granter-facing and deliberately not a tool; code-mode declarations regenerated (recursive attenuate renders as `Promise<typeof shell>`).
- **Tests** include the directive's adversarial case at both layers: a `find <root:path> -name <pattern>` grammar rejects `find … -exec sh -c …`, absolute roots, and `..` traversal, with no spawn. Breaking changeset covers all three packages; both READMEs rewritten.

## Verification

exo-shell 23/23, daemon shell composition 8/8, agent-tools 254 passing, agentry workspace-agent 6/6 (harness work intact); tsc clean for exo-shell, daemon, agent-tools; repo-wide prettier clean (a first CI lint red was my unformatted new files — fixed in the fifth commit); full PR CI settled green. The one local agent-tools red (`git-flow` cherry-pick "repository identity changed") reproduces **without** my changes — pre-existing/environmental, and green in CI.

## Follow-ups (not owed by this job)

- The genie-style `rejectPatterns`/`rejectFlags` advisory veto is now largely redundant with grammars; could be retired in a later slice.
- The bot's earlier review note stands: `makeWorkspaceTools({ readOnly: true, shell })` still accepts both flags silently.
- The PR body predates this rework; the maintainer-facing delta is in the summary comment and changeset.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1348 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `cb763267fc9604c2b984203420c85679a628ac8a`; this job presented `6d9e2ee2b47baa07bced78832e903b49bf4c379b`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-shell-command-grammar.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 224 tokens (19885552 cached reads)
- Output: 113312 tokens
- Cost: $30.294932
- Wall-clock: 5791s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
