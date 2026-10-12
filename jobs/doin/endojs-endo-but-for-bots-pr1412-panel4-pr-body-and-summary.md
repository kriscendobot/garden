---
role: gardener
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1412
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# PR #1412: apply panel-4 PR-body trim and post catch-up summary comment

Gauntlet job `endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-4` pushed the panel-4 code/docs fixes (head `bade55a5b2`), but host oros-studio's PAT gets a 403 on endojs PR writes. Do exactly two GitHub writes on https://github.com/endojs/endo-but-for-bots/pull/1412, nothing else (no pushes):

1. Replace the PR body with the text between `=====BODY=====` markers (`gh pr edit 1412 -R endojs/endo-but-for-bots --body-file <file>`). This applies pruner findings 1, 2, 3, 4, 5, and 7.
2. Post the text between `=====COMMENT=====` markers as a top-level PR comment (`gh pr comment`). This is scribe finding 1's catch-up summary. Skip this step if a comment already starting with "## Post-weave gauntlet: catch-up summary (head `bade55a5b2`)" exists.

=====BODY=====
Refs: #1357, #1403, #1369

## Description

Phase 2 of `designs/endo-claude-inference-backends.md`: two `InferenceBackend` plugins for `@endo/claude`, `makeClaudeCliBackend` (one confined `claude -p` per turn) and `makeClaudeSdkBackend` (one injected Agent SDK `query` per turn), over the provider-neutral `@endo/inference` interface, each made over one `CredentialSource`.
Both run one turn: version check, credential acquire, limit enforcement, and release on every path with no blocking wait.

Depends on #1403 (phase 1, `@endo/inference`), which is merged. This branch is rebased onto its merge through frozen base `llm-dc96042`, so the PR contains only the phase-2 changes.
#1102 (the agents factory) closed with changes requested; that does not touch the `InferenceBackend` interface this PR builds on, and nothing here calls a factory.

This PR delivers phase 2 only; production canary (design gates 3 and 8) and the failure-shape table are deferred.

### Security Considerations

The new authority is the injected `stdioProjection(guest)` power, which must close over the projection and never resolve a guest by `formulaIdentifier`. A binary off the pinned version gets no credential. The confinement is not yet verified against a live credential (phase 4).

The interim delivery puts the credential in the binary's environment, and the guest's stdio MCP server inherits that environment, so it holds the credential too (#1369 Gap 2, observed on 2.1.278 and 2.1.280). The design and the README record this as a residual acceptable only for a single-principal deployment; the broker delivery closes it.

### Scaling Considerations

Each CLI turn spawns one `claude` process tree and one per-turn scratch directory, both released on every path. Each SDK turn runs one in-process `query`. The wall clock and the optional `maxBudgetUsd` ceiling bound a turn's time and spend. Nothing persists between turns.

### Documentation Considerations

The README adds an "Inference backends" section listing the subpaths and backend options; the design records phase status and the `maxBudgetUsd` item. Downstream users need the subpath import paths in the changeset.

### Testing Considerations

No live credential, network, or `claude` binary is needed. The live-credential canary (design gates 3 and 8) is deferred.

### Compatibility Considerations

Node-only (`node:child_process`, `node:fs`, `node:path`, `node:os`; XS incompatible). Types resolve from the `.d.ts` files emitted beside each module. The new backends are reached only through subpaths; the root entry does not re-export them.

### Upgrade Considerations

The change is additive (a `minor` changeset): new subpath exports and new runtime dependencies on `@endo/inference`, `@endo/bytes`, and `@endo/utf8`. No existing export changes, and no stored data or live deployment needs a migration. A deployment that adopts a backend must supply a `CredentialSource` and a `claude` binary at the pinned version.

<!-- garden-related-design: 1403,1102,1369 -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: build-endo-claude-backends-1357 -->
=====BODY=====

=====COMMENT=====
## Post-weave gauntlet: catch-up summary (head `bade55a5b2`)

This supersedes the weave comment's head `b744bacbe0`. Since the weave, the post-weave panel ran four rounds, each answered by a push:

- **Round 1** (against `66dc87ac56`) → `d1fcd6e870`, then `2467b3a2de`: the README lists every backend subpath export and where its types come from; `ChildStream` and `ChildWritable` are re-exported from the root types.
- **Round 2** (against `2467b3a2de`) → `15a24d78b5`: the README names `confinedAllowList` and says the backends are reached only through subpaths.
- **Round 3** (against `15a24d78b5`) → `279a9b3c75`: the changeset is rewritten as a release note, and the README Known-gaps framing sentence is removed.
- **Round 4** (against `279a9b3c75`) → `bade55a5b2`: each README subpath bullet is cut to its purpose and export names. The "why parallel modules stay separate" rationale moves from the PR body into the design's Known Gaps. The PR body's file tour is removed, and the phase ledger, documentation, testing, and compatibility sections are tightened.

**Declined or deferred:** the round-4 should-fix and comment-only items (closing the SDK guest MCP server on a normal turn, reaping the process group on `close`, more boundary tests for the stderr window, line decoder, `maxTurns`, `usageFromResult`, `scratch-directory.js`, and `runBoundedCleanups`) were not blocking and are not in this push. A shared `runTurn(transport)` extraction is deferred, and the design records it.

**Verification:** the round-4 push changes only documentation (`packages/claude/README.md`, `designs/endo-claude-inference-backends.md`); no source or test file changed. Lint and tests were not re-run locally, so CI on `bade55a5b2` is the check.
=====COMMENT=====

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-12T08:16:07Z
