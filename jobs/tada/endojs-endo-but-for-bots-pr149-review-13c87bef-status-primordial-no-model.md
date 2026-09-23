Disposition: **2. Partially honored.**

Fresh refs:

- `origin/llm`: [`a54c3adbebf18fd837770d467433e480de498e8d`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d)
- Pull-request head: [`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3)
- The histories have no merge base.

The PR feature is implemented by [`ad2cfd7ebc9b8146d0f2bc293287a27a0931970a`](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a): Genie selects primordial mode when no model exists, starts its loop without constructing PiAgent or heartbeat agents, dispatches `primordial` prompts, and replies with `/help` and `/model list` guidance. Evidence: [boot and activation split](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1399-L1617), [boot precedence](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1705-L1718), [primordial dispatcher](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/loop/run.js#L60-L199), [operator reply](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/index.js#L125-L208), and [automaton tests](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/test/primordial/automaton.test.js#L82-L132).

Current `origin/llm` already honors the no-model startup and setup-guidance portions in Lal. [`setup.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/lal/setup.js#L27-L74) launches the Lal controller before model discovery and leaves an operator form when no model is available. [`agent.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/lal/agent.js#L151-L234) sends that form and follows inbox messages without constructing a model or heartbeat.

Exact remaining gap: Lal's no-model manager handles only form-value replies; ordinary inbound messages are ignored. A worker is created only after form submission, and [`spawnWorkerLoop`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/lal/agent.js#L61-L128) resolves the model and constructs PiAgent before starting [`runInboxLoop`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/lal/inbox-loop.js#L36-L157). Lal should add a pre-model ordinary-message dispatch path that points the operator to its existing configuration form. The full Genie `/model` catalog, plaintext persistence, and environment-stamping scheme should not be ported.

History worth retaining as a compact Lal follow-up is the acceptance intent from [TADA 93](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/TADA/93_genie_primordial_boot.md), [TADA 94](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/TADA/94_genie_primordial_automaton.md), and [TADA 98](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/TADA/98_genie_primordial_tests.md): boot without an LLM, answer every settled ordinary message, preserve setup-special dispatch, and test that no model agent is constructed. The broader [Phase 2 plan](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/TADA/92_genie_primordial.md) is Genie-specific history and need not migrate wholesale.

All three board discovery reports were read from freshly fetched `origin/journal2` and corroborated against the fetched refs. No tracked files, commits, branches, pushes, or GitHub state were changed. Runtime tests were not run; this disposition is based on source and history inspection.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-primordial-no-model.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 309s

<!-- garden-usage-end -->
