## Completion report: `design-endopi-jsonl-transcript-format`

I revised the JSONL transcript design and opened it for review as draft PR https://github.com/endojs/endo-but-for-bots/pull/1669. The PR is against the frozen base `llm-0368767`; the head branch is `design/endopi-jsonl-transcript-format` and the commit is `eabd104dbd`. The diff is one file, `designs/endopi-jsonl-transcript-format.md`.

**Why it needed revising**
- The format library is already merged as `@endo/jsonl-transcript` (#669), but nothing uses it.
- The maintainer's 2026-07-15 review on #669 asked how Chat, Familiar and Gateway integrate, and nobody had answered.
- The old design assumed a Lal reply-chain graph and a writer that computes paths under `$ENDO_STATE`. Lal now runs on a PiAgent that keeps a plain list of messages, so both assumptions are out of date.

**What the design now says**
- **Dependency.** The agent provider takes `@endo/jsonl-transcript` as a dependency: Lal first, then Fae. The format library does not change.
- **Where transcripts live.** Each agent gets a daemon scratch mount, made with the existing `provideScratchMount` and named `transcripts-for-<agent>`. This adds no new formula type and no gateway endpoint. The files still sit on disk, so `cat` and `jq` work on them.
- **Writing.** The agent's own startup code writes to that mount through the writer interface the library already accepts. The model's tools run as a separate worker guest that cannot look the mount up, which is the same rule Floot follows for its private storage.
- **Restart.** On restart the agent reads its newest session file and picks up the conversation from it.
- **Reading.**
  - Chat and the Familiar reach transcripts through the gateway, and the CLI by name. All of them get only the read-only view.
  - The gateway itself does not change.
  - An agent can read its own past sessions as memory only if it is explicitly granted read access.
- **Ownership map.** The design includes an ownership map with its four ownership questions answered. Its one diagram passed the mermaid parser.
- **Build phases.** Lal wiring, then the `endo session` CLI, then Fae and the Familiar, then a Chat viewer, then compaction.
- **#692.** The design records it as superseded, because it duplicates #669.

**Questions left for the maintainer** (in the design's Open questions section)
1. Should agents also get an optional mount at Pi's own `~/.pi` sessions directory?
2. Should agents be able to read their own transcripts by default? The design suggests no.
3. Should there be one transcripts mount per agent, or one per worker?

## Follow-ups
- **Build:** `build-endopi-jsonl-transcript-format`, the Lal wiring in phase 2 of the design. The completion handoff should post it after the design review passes. I did not post it myself.
- **Budget estimate:** the whole build spans several jobs (phases 2–5), but I did not file the budget estimate the designer role asks for. Whoever posts the build should file one.
- **#692:** it should be closed as superseded. I left it open for the maintainer.

<!-- garden-design-build-handoff: successor=build-endopi-jsonl-transcript-format state=existing pr=https://github.com/endojs/endo-but-for-bots/pull/1669 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endopi-jsonl-transcript-format.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3372742 cached reads)
- Output: 22316 tokens
- Cost: $1.9299244000000002
- Wall-clock: 458s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
