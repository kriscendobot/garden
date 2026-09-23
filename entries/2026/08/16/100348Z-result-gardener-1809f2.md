---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T10:03:50Z
---
---
ts: 2026-08-16T00:00:00Z
kind: result
role: wire-watcher
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: judge
---

# wire-watcher, PR #995 (`designs/endo-claude.md`, `designs/README.md`)

Diff base `origin/llm` (the worktree's local `llm` ref is stale at `228c48ae`; against it the diff falsely shows 3483 files).

**Verdict: request-changes**

## Findings

**1. must-fix. DD7 stores the spawn's secrets inside the very directory DD6 must hide.** `designs/endo-claude.md:1056` places the per-spawn `--settings` and `--mcp-config` files under `whereEndoEphemeralState(...)`, which returns `$XDG_RUNTIME_DIR/endo` (`packages/where/index.js:77`) or `$TMPDIR/endo-<user>` (`:83`). `whereEndoSock` returns `$XDG_RUNTIME_DIR/endo/captp0.sock` (`:103`) / `$TMPDIR/endo-<user>/captp0.sock` (`:110`) - the live daemon socket is a sibling entry in that same directory. DD6 (`:1039`) rests the whole structural boundary on "the slice's filesystem-namespace isolation is what keeps the daemon socket path out of reach", yet the child must read both files by absolute path from inside the slice. Any mount that satisfies DD7 exposes the socket DD6 hides, and the design nowhere requires the placement to be a distinct subtree. Name an isolation-safe location (a per-spawn directory outside the ephemeral-state tree, or fd-passing so no in-slice path exists) and state the mount contract. [proposed-rule: a design that rests confinement on filesystem-namespace isolation must show the paths it *does* mount in are disjoint from the paths it claims are unreachable.]

**2. must-fix. The five-flag spawn refusal is presence-only, but two of the five carry their confinement in their value.** DD1 (`:947`) refuses to spawn unless "all five appear in the argv", and its parenthetical (`:956`) explicitly classes `--tools ""` and `--setting-sources ""` as flag-*presence* assertions rather than value-carrying ones. Their entire property is that the value is empty: `--tools Bash` and `--setting-sources user` both satisfy presence and both re-open the surface. The design already names the exact attack (`:245`): a token swallowed into `--tools`'s variadic value run "silently re-populates the empty built-in set" - which a presence-only assert cannot detect. This is the `"alg": "none"` shape: the field is checked for existence, not for its safe value. Require the asserted *value* (empty string) for both, and fold them into the argv-run invariant at `:264` rather than the presence set. [rule: skills/adversarial-tests/SKILL.md, trust-bypass category]

**3. should-fix. The normative prune rules dropped the shape check they were meant to subsume.** `:289` says names are validated "by *membership*, not merely by shape", and `:296` correctly argues a bare charset check is insufficient - but the three enumerated rules at `:311`-`:338` then carry membership, `__`/dunder/code-eval pruning, and null-prototype keying, and no charset or glob rejection at all. A catalog name of `*` passes all three and renders `mcp__endo__*`, an *anchored* glob the design itself says is honored (`:293`); a name containing a comma or space passes all three and splits into extra allow entries, the exact hazard `:292` raises. The boundary still holds (the bridge dispatches only pinned names), so this degrades the belt rather than breaching the boundary - but the rewrite lost a rule it had. Restore the charset/glob rejection as a fourth normative prune rule.

**4. should-fix. The version pin is checked on a different read than the one that executes.** `:529` and DD1 `:951` assert `claude --version` equals 2.1.232, then spawn `claude`. Those are two independent PATH resolutions of a name, so the pin binds the binary that answered `--version`, not the binary that runs the guest's prompt - and the whole confinement is a measurement of one build's flag semantics. Resolve once to an absolute path (or a content hash) and spawn *that* path, so the checked artifact and the executed artifact are the same bytes. [proposed-rule: an integrity check on an executable pins the resolved artifact, never a name re-resolved at exec time.]

**5. should-fix. Single-shot `materialise()` versus a helper the CLI may re-invoke.** DD5 (`:1023`) maps the credential to `IssuedCredential.materialise()`, which is single-shot and throws on a second call (`packages/claude-sandbox/src/claude-credentials-factory.js:231`, `:242`). `apiKeyHelper` is a command Claude Code executes and may run more than once per process (it carries a refresh TTL). The design nowhere pins how many times the helper runs, so a mid-stream re-invocation throws and ends the inference as `nonzero-exit`/`parse-error` with no diagnosis. State the invariant: either the helper materialises once and caches for the spawn's lifetime, or the caplet extension of DD5 grants a TTL-bounded credential rather than a single-shot one. Add it to the live test at `:1112` (call the helper twice, assert the spawn survives).

## Notes

Positives worth keeping: pruning at snapshot construction so boundary and belt derive from one value (`:304`), the harness-owned broker holding the un-inherited fd (`:555`), the argv-element-equality (not substring) prompt invariant (`:265`), and the explicit refusal to let an empty post-prune catalog count as a confinement pass (`:981`).

Self-improvement: the seat repeatedly finds that a panel round which *rewrites* a validation rule into a stronger one (here membership-plus-prune replacing a shape check) silently drops a clause the weaker rule carried. Worth a line in `skills/panel-review/SKILL.md` or `skills/adversarial-tests/SKILL.md`: when a round replaces a check, diff the old check's clauses against the new one's and confirm each is either carried or explicitly retired. Sending as a message to liaison.
