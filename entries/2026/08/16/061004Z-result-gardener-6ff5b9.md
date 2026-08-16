---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T06:10:05Z
---
---
kind: result
role: skeptic
repo: endojs/endo-but-for-bots
project: endo
---

Design-panel skeptic seat on endojs/endo-but-for-bots PR #995 (`designs/endo-claude.md`, base `origin/llm`, head 35678ab2d0).

### skeptic

**Verdict:** request-changes

**Findings:**

- **`--bare` and subscription OAuth are mutually exclusive, so the design's two load-bearing decisions cancel each other.** Decision 1 (designs/endo-claude.md:337) makes `--bare` mandatory ("the harness refuses to spawn without `--bare` in the argv"); Decision 5 (:354) and *Pooling* (:294-302) make the whole value a *subscription* injected as `CLAUDE_CODE_OAUTH_TOKEN`. Verified on Claude Code 2.1.232: `--bare`'s own help says "Anthropic auth is strictly ANTHROPIC_API_KEY or apiKeyHelper via --settings (OAuth and keychain are never read)". Ran it: with only `CLAUDE_CODE_OAUTH_TOKEN` set, `claude --bare -p` exits "Not logged in - Please run /login", while the identical call *without* `--bare` reaches the API ("401 OAuth access token is invalid"), and `--bare` plus `ANTHROPIC_API_KEY` also reaches it ("Invalid API key"). The premise at :38-40 (a Max/Pro plan, "not a metered API key") is therefore unreachable under the flag the design calls "the single most important". must-fix: keep one, or name `apiKeyHelper` as the sole escape and accept metered billing. [rule: roles/COMMON.md § Reporting, a "verified" claim requires real-execution evidence]

- **`--strict-mcp-config` takes no argument; the literal argv silently loses the entire tool surface.** :66, :109, :317 and :323 all write `--strict-mcp-config cfg.json` and gloss it as "path to a generated config". Real help: "Only use MCP servers from --mcp-config, ignoring all other MCP configurations", a boolean with no `<arg>` placeholder (value-taking options all show one, `--mcp-config <configs...>`). The design never names `--mcp-config`, the flag that actually loads the file. The path binds to the `[prompt]` positional instead, so the process starts with zero MCP servers and confinement "passes" by exposing nothing. must-fix.

- **"a deny-by-default permission mode" (:111) does not exist**, and `--disallowedTools "*"` is unverified. Real `--permission-mode` choices: acceptEdits, auto, bypassPermissions, manual, dontAsk, plan. By the design's own argument at :117 (unanchored wildcards are silently skipped with a warning), a lone `*` needs verifying before it can be called the baseline. should-fix.

- **The test catalog cannot catch the class of error above.** The whole plan is one line, :318, "dependency-injected unit tests (no live claude, no daemon)". A mocked spawn only asserts the harness emits the argv the author believed in, which is exactly how the three findings above survive to implementation. No negative confinement test is named either. should-fix. [proposed-rule: a design whose substance is confinement must name at least one live-execution test against the real confined surface, not only dependency-injected unit tests.]

**Notes (out of scope but worth flagging):**

- designs/README.md:463, "Current totals ... This supersedes the counts in the historical summaries above", still reads 150 designs. The PR synced only the superseded historical sentence (151 to 152), so the preamble's "totals synced" (README:8) is not true of the authoritative line. [proposed-rule: adding a design row updates the authoritative "Current totals" paragraph, not only the superseded historical tally.]
- Estimate row README:1454 puts a Milestone 6 entry inside the milestone-3 block of an otherwise milestone-ordered table.

Self-improvement: the seat's verified-claim discipline paid off by being run against the CLI rather than the docs. The design said its mechanics "were verified against the current Claude Code CLI documentation"; three of five flag claims did not survive `claude --help` plus four one-line spawns. Worth encoding in `roles/jurors/skeptic/AGENT.md`: when a design's premise is an external tool's flag semantics and that tool is installed on the host, run it. Documentation-grounding is the weaker evidence.
