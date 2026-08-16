---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T06:45:26Z
---
---
kind: result
role: breaker
repo: endojs/endo-but-for-bots
project: endo
---

Panel round 2, PR #995 (`designs/endo-claude.md`, head 8ae8b364a8, base `origin/llm`). Per-juror block below.

### breaker (invariant attacks)

**Verdict:** request-changes

**Findings:**

- `designs/endo-claude.md:128,133-145` — **allow-list argv injection.** The allow-list is a comma-joined string generated from facet method names, and the doc itself establishes that a *literally anchored* glob is honored (`mcp__*` is rejected only because it is unanchored). A facet method named `*` therefore yields `mcp__endo__*`, granting every tool on the server; a name containing `,` splits into extra entries. The claimed invariant ("the exact per-tool entries generated from the guest facet's method set") is falsified by any method name outside `[A-Za-z0-9_-]`. Require the generator to validate each name and fail closed. [proposed-rule: a design that renders untrusted names into a delimiter-joined or glob-interpreted argument must specify the charset validation and the fail-closed behavior, not just the join.]

- `designs/endo-claude.md:120-129` — **the flag table is argv-only; the environment is an unenumerated channel.** "Every knob below is load-bearing" enumerates argv exhaustively and never names the spawn environment. An inherited `NODE_OPTIONS=--require /path/x.js` executes arbitrary code inside the confined process; `ANTHROPIC_BASE_URL` / `HTTPS_PROXY` redirect the inference; `CLAUDE_CONFIG_DIR` re-points the config root `--bare` was chosen to neutralize. The sibling already solves this: `packages/claude-sandbox/src/claude-client-module.js:257` passes a *closed* `credentialEnv` record, not `process.env`. Specify a closed env allow-list as a load-bearing row of the table. [rule: skills/adversarial-tests/SKILL.md § Adversarial values]

- `designs/endo-claude.md:269` — **"no transcript retained" is asserted, not established.** `--bare` is documented throughout this doc as suppressing config *loading*; nothing establishes it suppresses session *persistence*. If a session JSONL is written, past tool results from guest A's facet survive on disk and are resumable by anything else on the host, which is exactly the leak Design Decision 3 bans `--resume` to prevent. Banning the flag in this harness does not make the artifact absent. Either pin a per-call ephemeral config root with verified deletion, or move this to *Known Gaps* alongside the other measured-vs-assumed calls the doc is otherwise careful to separate (lines 60-64). [rule: roles/COMMON.md § Reporting, "a verified claim requires real-execution evidence"]

- `designs/endo-claude.md:127` — **deny-set exhaustiveness and allow-list closure cannot both be load-bearing.** If absence from `--allowedTools` denies (as the row at 128 claims for headless `-p`), the built-in deny set is redundant; if the deny set is required, then the allow-list is *not* closed and the enumeration `Bash, Read, Write, Edit, Glob, Grep, WebFetch, WebSearch, Task, NotebookEdit, ...` must be exhaustive against the CLI. Mechanics are pinned to 2.1.232; a CLI upgrade that adds a built-in lands outside the deny set with no change on the Endo side, and the trailing `...` concedes the list is already not closed. Decide which half is load-bearing, and if it is the deny set, specify a startup gate that diffs the CLI's built-in tool set against the deny set and refuses to spawn on an unknown name. [proposed-rule: a confinement design resting on an enumeration of a third-party surface must name the pinned version and the fail-closed drift check, not just the enumeration.]

- `designs/endo-claude.md:276-289, 333-339` — **the stdio shim hands the confined uid the unattenuated daemon socket.** `claude -p` spawns the shim *itself*, so the shim is a same-uid child and that uid must be able to open `ENDO_SOCK` (`/run/endo-daemon/endo.sock`) — the daemon's whole one-socket-many-guests surface, not one facet. The per-facet attenuation holds only because no surviving tool can reach the socket, so the previous finding's failure mode escalates from one facet to every guest on the box. On this axis stdio is strictly *wider* than the loopback-HTTP alternative, where the bearer is the only key and the confined uid need not reach the daemon socket at all; the doc calls stdio "the tightest local shape" (line 288) without naming this trade. Name it, and pair the stdio recommendation with the Decision 6 OS slice rather than leaving that "Recommended". [rule: skills/saboteur-adversarial-review/SKILL.md]

- `designs/endo-claude.md:126,374-376` — **the sole settings file is the whole confinement, and its integrity is unspecified.** `--setting-sources ""` makes the generated `--settings` file authoritative, so anything that can write it can add `hooks` or `permissions.allow` and own the process. The doc never states the path, mode (0600), exclusive creation, the private directory, or the TOCTOU window between render and spawn. It also never says the file is unlinked: `release` (line 268) returns the credential to the pool, but a crash leaves a live subscription secret in plaintext on disk. [proposed-rule: a design that renders a secret or a security-decisive file to disk must specify its directory, mode, exclusive-creation, and unlink-on-exit, including the crash path.]

**Notes (out of scope but worth flagging):**

- `designs/endo-claude.md:257,262` and Design Decision 2 (line 486-492) — the "one value both consume, so they cannot drift apart" claim is falsified by the doc's own sequence diagram, which shows **two** separate `tools/list` calls (harness at 257, process at 262) against a live bridge. Harmless in the deny direction, but a method removed and re-added under the same name between the two calls keeps its allow entry while changing what it does. [rule: skills/adversarial-tests/SKILL.md § Timing and state]

- `designs/endo-claude.md:370-376` — the reused caplet already discriminates credential kinds: `packages/claude-sandbox/src/claude-client-module.js:71-72` maps `kind() === 'oauthToken'` to `CLAUDE_CODE_OAUTH_TOKEN`, which is precisely the subscription case and precisely what `--bare` does not read. The pool wrapper should reject an `oauthToken`-kind credential rather than emit it from `apiKeyHelper`; the sibling guards this exact mis-routing deliberately (comment at line 212). This sharpens the load-bearing residual at line 387 from "unverified" to "known-wrong for one of the two kinds". [rule: skills/adversarial-tests/SKILL.md § Type confusion]

Self-improvement: the design panel's default seat list does not include the breaker, yet this security-confinement design's substance is entirely invariant claims; worth a `panel-hints` entry that a design-only diff whose subject is confinement or capability attenuation should add the breaker and locksmith seats to the design panel.
