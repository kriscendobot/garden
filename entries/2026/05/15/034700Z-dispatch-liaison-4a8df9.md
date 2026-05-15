---
ts: 2026-05-15T03:47:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 138
    role: source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/138#pullrequestreview-3438488467
---

# Dispatch: builder attempts #138's tentative design (OCapN/Daemon integration) to reveal gaps

Dispatch root: `dispatches/builder--4a8df9/`. Project worktree on `endojs/endo-but-for-bots@design/ocapn-daemon-integration` (current head `4562c9f3e` — the design PR's branch).

Maintainer directive (2026-05-15, on #138): *"Please dispatch a builder to attempt to implement this tentative design, in order to reveal gaps. This kind of feedback has been a pretty common so please ask the gardener to create a skill and give a verb to the liaison for invoking it. Post that to the bulletin."*

The companion gardener dispatch (`gardener--c9ded6`) encodes the skill + verb in parallel.

## Goal

**Reveal gaps**, not ship polished code. This is a tentative design (528 lines, `designs/ocapn-daemon-integration.md`); the implementation attempt's value is the inventory of ambiguities, contradictions, and under-specified seams it surfaces. The PR should be DRAFT and exists primarily as the artifact the maintainer reviews to judge whether the design needs revision.

## Pre-flight gaps the liaison surfaces upfront

1. **Base branch conflict.** #118 (the parent issue) says "design document, for implementation on the llm branch" — implementation on llm. The builder role's general rule (encoded 2026-05-14, on llm in `roles/builder/AGENT.md`): "implementations are based on master." Today's directive does not name a base. **Default to branching off `design/ocapn-daemon-integration` (stacked on #138)** so the design file is present in the worktree; surface the base-branch question as gap #1 in the gaps report.

2. **Dependencies live on llm, not master.** The design's dependency graph names `onoise`, `onet`, `dnet` (the consolidated #111/#112/#113 stack). Those PRs target llm. A master-base implementation would lack its prereqs; an llm-base implementation has them. This reinforces gap #1's implicit answer.

## Task

1. **Read design fully:** `designs/ocapn-daemon-integration.md` on the dispatch's project worktree (head `4562c9f3e`). Note every place the design says "TBD", "future", "open question", or hand-waves a mechanism.

2. **Read the dependencies on llm:**
   - `packages/ocapn-noise-network/` (or wherever the consolidated #111/#112/#113 lands once it merges)
   - `packages/daemon/src/transport-types.js` and `daemon-node-powers.js`
   - The current `@nets` formula and `provideNets` host method (whichever package)
   - `packages/cli/src/cli.js` for the existing `endo nets` verb

3. **Attempt the skeleton** in `packages/daemon/` (and a new package if the design names one — re-read the design's "Affected Packages" section):
   - The `Transports` exo interface (`provideTransports`, `connect`, `listen`, `disconnect`, `shutdown`)
   - The host-side proxy that mediates between the per-agent `Transports` and the daemon's netlayer registry
   - The agent pet-store entry `@transports` (parallel to `@nets`)
   - The `endo transports` CLI verb
   - The per-agent Ed25519 keypair materialization (deferred-task params on the `Transports` formula)
   - The four-field `options` record (`allowedSchemes`, `signingKeys`, `listenPolicy`, `outboundPolicy`)

4. **Stop at every ambiguity. Do not guess.** When the design hand-waves a mechanism, write a numbered gap entry in your journal scratchpad with:
   - Where the design touches it (file/line)
   - What the design says (verbatim quote)
   - What you would need to know to write the implementation
   - Candidate resolutions (with trade-offs)

   Likely gaps (start here, find more):
   - **Cross-agent loopback distinguisher** (assessor's note): how does the proxy decide a `Locator` resolves to a local sibling vs a remote daemon? Design § "Capability sharing across agents" hand-waves.
   - **Listener policy enumeration site:** where does `'none' | 'request' | 'allow'` get validated? At the host wrapping site, the exo body, or the netlayer?
   - **Listening-port allocator policy** (breaker note, Open Question 2): per-agent quota vs OS ephemeral pool.
   - **Restart failure mode** (breaker note): the proxy survives a malformed `Transports` formula on restart how?
   - **`connect()`'s `Locator | string` discrimination** (Open Question 4 + saboteur note): parser failure modes, malformed scheme prefixes, embedded null bytes.
   - **Transport-hint policy DSL** (Open Question 5, locksmith note): suffix-match allowlist is the named minimum; failure mode?
   - **Asynchronous disconnect race** (breaker note): per-handle revocation when the netlayer pools connections.
   - **`@nets` migration shim semantics:** Coexistence-test § says "the new caller prefers `@transports`" but the design doesn't say what happens to a caller that requests both.
   - **Per-agent signing key persistence** vs daemon restart (Open Questions, design lines 253-258): the design names the path but doesn't specify the failure mode when persisted params are corrupt.

5. **Open as DRAFT PR** against `design/ocapn-daemon-integration` (the design branch — this is a stacked PR; #138 must merge first). Branch: `feat/ocapn-daemon-integration` or similar. Title: `feat(daemon,ocapn): per-agent @transports — gap-revealing prototype of #138's design`. Body MUST include:
   - Link to design PR #138
   - **`## Gaps surfaced`** section: numbered list, each gap with the four fields above
   - **`## Skeleton implemented`** section: what compiled / passed tests / typechecks
   - **`## Skeleton not implemented`** section: what was abandoned at first ambiguity
   - **`## Recommendations to design author`** section: which gaps need design revision vs implementation-time choice

6. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

7. **Conventional-commit messages** (`feat(daemon,ocapn): ...`). Separate `chore: Update yarn.lock` per `skills/yarn-lock-separate-commit/SKILL.md`.

## Per-action authorization

Standing on endo-but-for-bots: push to a new branch, open draft PR. READ-ONLY on endojs/endo.

## Out of scope

- No edits to the design at #138 itself; the maintainer revises the design based on this report.
- No un-draft. The PR stays draft until maintainer reads it.
- No upstream ferry.
- No comment on #138 (the implementation PR is the response).

## Report

≤ 600 words: implementation PR URL + head SHA, count of gaps surfaced + one-line each, count of skeleton-implemented packages/exos, count of skeleton-abandoned items, one-line `Self-improvement: ...`. The liaison adds a bulletin row pointing the maintainer at the implementation PR's "Gaps surfaced" section.
