## Completion report: `backfill-endo-claude-design-from-minion-town-production`

**Result:** I opened draft PR **endojs/endo-but-for-bots#1357**. It adds the design `designs/endo-claude-inference-backends.md` and updates `designs/README.md` with a summary row, a dependency-graph node and edge, an M3 milestone row and an estimate row. The PR's base is a frozen snapshot of `llm` at 47f6965 (`llm-47f6965`), and the head branch is `design/endo-claude-inference-backends`. The PR stays draft and I did not post a gauntlet.

**The main finding: there is almost no production evidence.** I inspected the minion.town production host read-only over SSM on 2026-09-28:
- `ENDO_CLAUDE_ENABLED` is not set, and no `ANTHROPIC_*` or `CLAUDE_*` variables are set either.
- Neither prototype backend is deployed. The two drafts are kriscendobot/minion.town#105 (Claude CLI) and #106 (Agent SDK).
- The service log since 2026-09-18 has no lines about Claude inference.
- The pinned Claude Code binary is deployed at version 2.1.268.

So production has run zero inference turns on either path. The only real model run is one Agent SDK turn on a development host, using a claude.ai login and an in-memory guest. The Agent SDK track has been on hold since 2026-09-23, waiting for an Anthropic API key. The design states all of this up front. I went ahead anyway because the maintainer promoted this job with go-ahead, and I made "should this wait for a real comparison run?" an explicit open question.

**Evidence I read:**
- The orchestration's final report, both child reports, and #105 and #106 with their gap-report design docs.
- Merged minion.town PRs #87, #96, #99, #103, #119 and #122, and draft #120.
- The Codex prototypes #115 and #116, which reuse the same backend interface. They show the interface works for providers other than Claude.
- The existing `endo-claude.md` and `hosted-agent-broker-oauth.md` in endo-but-for-bots.
- `claude --help` on CLI version 2.1.280.

**What the design settles:**
- **CLI vs Agent SDK:** they are one engine with two front ends. The SDK starts the same pinned binary, so the confinement is the same either way. They differ in how the guest's tools are delivered (in-process for the SDK, loopback or stdio for the CLI) and in dependency weight. Endo ships both behind one interface, and the first production canary picks the default.
- **The shared backend interface:** `InferenceBackend` with a tagged `InferResult` that never rejects. The guest's facet is the authority; the formula id is only a label for audit and joining records. `infer` is the building block the agent factory calls.
- **Credentials:** confined runs use an API key injected by a broker, so the confined process never holds it. The owner's own Claude subscription falls outside the Endo contract, for three reasons: `--bare` never reads OAuth, the SDK is for the paid API, and `hosted-agent-broker-oauth` found no vendor-supported way for a third party to broker a subscription.
- **Permissions:** use `dontAsk` rather than `bypassPermissions`, and re-diff the `--help` flag set on every binary bump.
- **Packaging:** a thin `@endo/claude` core with no sandbox dependency, so minion.town can depend on it instead of keeping its own diverging copies.
- **Also included:** a table of observed vs merely documented behavior, an ownership map, and five verification gates. The live positive and negative confinement tests are required before either backend is treated as a security boundary.

**Open questions for the maintainer (listed in the design and the PR body):**
1. May the owner keep using their own subscription outside the confined path?
2. May a single-operator deployment skip the OS sandbox? That would relax Decision 6 of `endo-claude.md`.
3. Where should the provider-neutral interface live? I recommend a small `@endo/inference` package.
4. Should this design wait for the CLI-vs-SDK comparison run?

**Follow-ups and notes:**
- #106 pins SDK 0.3.236, which bundles Claude Code 2.1.236. Production now runs 2.1.268, so reviving that track needs a new pin.
- Checking my job inbox failed both times: the journal clone timed out after 45 seconds (rc=124/75). There may be a connectivity or clone-bloat problem on this host, and any messages sent to this job went unread.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/backfill-endo-claude-design-from-minion-town-production.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (5127707 cached reads)
- Output: 34520 tokens
- Cost: $2.9440453999999994
- Wall-clock: 644s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
