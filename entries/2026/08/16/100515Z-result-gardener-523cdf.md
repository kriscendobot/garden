---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T10:05:16Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 995
seat: spec-keeper
panel: gauntlet-panel-6
---

Panel seat spec-keeper, PR endojs/endo-but-for-bots#995 (design-only:
`designs/endo-claude.md` + `designs/README.md`, diff base `origin/llm`; the
local `llm` ref in the review worktree was 7 commits stale, which inflates a
`llm...HEAD` diff to ~211KB of unrelated stat).

### spec-keeper

**Verdict:** request-changes

**Findings:**

- `designs/endo-claude.md:1068` -- DD8 declares the seven-case tagged taxonomy
  normative and says a launched inference "never rejects", then specifies
  `M.call(...).returns(M.promise())`, which enforces neither. `M.promise()`
  checks `passStyleOf === 'promise'` and is duck-typed for any thenable
  (`packages/patterns/src/type-from-pattern.ts:175-179`), so a rejected promise,
  or one fulfilling to `undefined`, passes. This repo's own guard for an async
  method is `M.callWhen` (`docs/message-passing.md:539-563`). Specify
  `M.callWhen(M.string(), M.splitRecord({}, {model: M.string(), cancelled:
  M.promise()})).returns(InferResultShape)` with `InferResultShape = M.or(...)`
  over the seven cases, or say plainly that the taxonomy is code-enforced and the
  guard does not check it. As written, "property tests exercise the guard as
  universally quantified claims" (line 1091) rests on a guard that asserts almost
  nothing, and the argument guards are left entirely unspecified.
  [rule: roles/jurors/spec-keeper/AGENT.md § Operating norms, *Exo guard/type alignment*]

- `designs/endo-claude.md:948-951` -- the spawn-refusal set asserts five flags
  plus the pinned CLI version, but not that the DD6 slice is active, even though
  DD6 and the Architecture prose both name the slice, not the flags, as the
  boundary ("Scrubbing... is defense-in-depth only, not the boundary"; the slice
  is "required, not merely recommended"). The design fails closed on its belt and
  open on its boundary. Platform corollary: `whereEndoSock`
  (`packages/where/index.js:92`) resolves a live path on macOS and a Windows named
  pipe, where no podman slice exists, so on those hosts the stated boundary is
  absent while the socket is not. Make slice-active a refusal condition.
  [proposed-rule: a design that names one layer authoritative must place that
  layer's presence in the same fail-closed check as its defense-in-depth layers.]

- `designs/endo-claude.md:289-338` -- no primordial-preservation rule, in a design
  whose entire security surface is string handling on values crossing a trust
  boundary (catalog names, prompt, options). `name.includes('__')`, the
  comma/space join, and `/^[0-9a-f]{64}$/.test(id)` all dispatch through the
  value's own lookup; a Remotable, a `String` wrapper, or a record carrying its
  own `test` reaches attacker code or coerces surprisingly. The repo's standing
  idiom is captured `Reflect.apply` (`packages/pass-style/src/passStyle-helpers.js:18,66`).
  State it: assert `typeof === 'string'` first, then captured application. (The
  regex itself is correct in JS: per ECMA-262 22.2.2.6
  https://tc39.es/ecma262/#sec-assertion `$` without `m` admits no trailing
  newline, unlike Python; worth an inline note so a reader does not "fix" it.)
  [rule: roles/jurors/spec-keeper/AGENT.md § Operating norms, *Primordial preservation*]

**Notes (out of scope but worth flagging):**

- `designs/endo-claude.md:1072` -- `{type: 'facet-threw', method, error}`.
  `Error.prototype.stack` is not in ECMA-262 (Stage 1 proposal-error-stacks,
  https://github.com/tc39/proposal-error-stacks), and SES error taming plus
  marshal's error encoding decide what survives the CapTP hop. Say what the
  `error` field carries (name/message) and forbid tests asserting stack or
  `toString` format, or the taxonomy is engine- and taming-defined.
  [rule: roles/jurors/spec-keeper/AGENT.md § Operating norms, *Brittle-test resistance*]

- Claims checked and confirmed: `evaluate`/`define` are real Lal tool names
  (`packages/lal/tool-dispatch.js:449,479`); `readText`/`writeText` (`:381,389`)
  are `executeTool` switch cases rather than facet own-methods, so the design's
  rejection of a `__getMethodNames__()` membership test
  (`packages/pass-style/src/make-far.js:142`) is correct;
  `CREDENTIAL_KINDS = harden(['apiKey','oauthToken'])`
  (`claude-credentials-factory.js:126`); the `materialise()` / `outstanding.delete`
  behavior (`:242`); the `mcp.js` stub and its exports-test pin
  (`packages/agent-tools/test/exports.test.js:250`); `fast-check ^4.9.0` in
  `@endo/agentry`.

- Scope note: this is a design-only PR, whose default panel is the seven design
  seats. Reviewed against the code-panel spec lens as dispatched; all three
  findings would become code defects at build time, not prose taste.

Self-improvement: the dispatch named a base ref (`llm`) that was stale in the
review worktree, so the prescribed `git diff llm...HEAD` returned ~211KB of
unrelated diffstat instead of the PR's two files. Worth encoding in
`skills/panel-review/SKILL.md` (or the panel script's seat prompt): a seat should
compare `git rev-parse <base>` against `origin/<base>` before diffing and prefer
the remote-tracking ref, the same normalization
`3e7ffb1e13 fix(panel): normalize a bare local base branch to its remote-tracking tip`
already applied on the panel's own side but which the per-seat prompt still emits
bare.
