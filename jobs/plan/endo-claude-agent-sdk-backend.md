---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-08-31T22:26:45Z
---

---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 14339
dispatch: automatic
---

# Build: a `paid`-tier Agent SDK backend behind `@endo/claude`'s existing seams

Repo: `endojs/endo-but-for-bots`. Base: `llm`. Child 3 of 3 in
`endo-claude-agent-sdk-track`. Follows the design and probe children — read both
completion reports first; if the probe found the SDK cannot preserve the
`mcp__<server>__<tool>` surface under a denied built-in set, **stop and report
that** rather than building around it.

## What to build

An alternative inference backend that swaps the confined `claude -p` spawn for an
Agent SDK `query()`, sitting behind the dependency-injection seams PR
[#1015](https://github.com/endojs/endo-but-for-bots/pull/1015) already established
in `packages/claude/harness.js` (the spawn seam, the broker seam, the pool seam).

- The CLI path must keep working unchanged and stay the default. This is an
  additional backend, not a migration.
- Credentials: the SDK is **metered only** (`ANTHROPIC_API_KEY` and the
  cloud-provider paths; subscription/claude.ai login is not permitted for third
  party products without prior Anthropic approval). So this backend rides the
  `apiKey` credential kind that `@endo/claude-sandbox`'s `ClaudeCredentials`
  already admits — it does **not** need the `subscription` kind #1015 added, and
  must not be wired to it.
- Preserve every confinement invariant the CLI path enforces, expressed in SDK
  terms: the pinned pre-pruned tool catalog driving both the allow-list and the
  server-side dispatch check; a constructed env allowlist rather than
  inherited-minus-one; no session resume; the fail-closed empty-catalog error.
  The SDK equivalents are `settingSources: []`, `strictMcpConfig: true`, an
  explicit `tools`/`allowedTools` list, plus the residual closers the probe
  confirmed (`CLAUDE_CONFIG_DIR`, `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`).
- Carry over the argv-equivalent **refusal predicate**: the CLI path refuses to
  spawn unless all five flags are present with the right values. Build the
  analogous options-refusal check so a misconfigured SDK call cannot run at all.
  Do not let the SDK's friendlier API erode the fail-closed posture.

## Definition of done

- Property tests in the shape of #1015's (`fast-check`) for the refusal predicate,
  the env allowlist over a hostile parent env, and the allow-list round-trip.
- Full local verify green per [local-verify](skills/local-verify/SKILL.md);
  changesets per [changeset-discipline](skills/changeset-discipline/SKILL.md).
- Draft PR against `llm` stating plainly which tier it serves (`paid`) and that it
  is not a subscription path.

## Out of scope

Do not touch minion.town. Do not alter the CLI backend's behavior. Do not remove
the `subscription` credential kind.
