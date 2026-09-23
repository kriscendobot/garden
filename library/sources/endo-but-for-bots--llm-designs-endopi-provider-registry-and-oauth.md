---
source: designs/endopi-provider-registry-and-oauth.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: d77f3277b5b63cfec07f164270b3927a37194819
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Seventh endopi-* design ingest (after cycles 112 + 117 + 121 +
  122 + 124 + 126). 181-line *Proposed (partially satisfied)*
  design (Parent: endopi.md) closes the §Multi-provider LLM API
  gap from cycle 121's family keystone — *subscription auth is
  pi's highest-leverage feature for end users*.

  Same *partially-satisfied* lifecycle pattern as cycle 124's
  iterative-compaction. Cycle 121's §What Genie's existence tells
  us already said: *Genie ships pi-ai's full registry by
  transitive dependency; M1's scope reduces to (a) consolidating
  onto one registry surface (Genie's vs Lal's) and (b) the OAuth
  and cross-provider-handoff work that pi-ai does not provide*.

  Six-axis scope-satisfaction enumeration:
    Phase 1 (registry shape) — *partially via Genie*
    Phase 2 (API-key providers, 30+) — *available via Genie today*
    Phase 3 (OAuth: Claude subscription) — **genuinely missing**;
        highest-leverage
    Phase 4 (OAuth: ChatGPT Plus + Copilot) — **genuinely missing**
    Phase 5 (cross-provider handoff) — missing; *Genie inherits
        the registry but doesn't exercise mid-session switching*
    Phase 6 (image input) — *inherits from pi-ai per provider*

  §Headline-has-moved discipline: *The original "30+ providers"
  framing is no longer the headline*. The design's role shifts to
  *picking which substrate-already-exists-via-Genie pieces to
  harmonise into Lal vs leave to Genie's embedding path*.

  ProviderInterface declared as `M.interface` with apiStyle (5
  options: openai/anthropic/google/bedrock/custom) + authShape (4
  options: apiKey/oauth/vertex/none) discriminators. Six methods:
  name / apiStyle / authShape / listModels / complete / stream.

  §Subscription OAuth: *authorization-code-with-PKCE*. The §dual-
  redirect-URI discipline: Familiar pane (Electron build, cycle
  109's `localhttp://` protocol) OR local 127.0.0.1 HTTP listener
  (daemon-only build, cycle 111's gateway-migration). The
  §encrypted-at-rest credential discipline: *credentials stored
  encrypted at rest in the same store as the formula graph;
  encryption key derived from host's passphrase or hardware key
  per existing daemon pattern*.

  §Out of scope §Pi-compatible OAuth credential file declined —
  *Pi stores OAuth tokens under ~/.pi/agent/auth/; Endo's store
  lives in the formula graph*; *we do not import Pi's auth file
  shape because the secrets boundary is different (the Endo store
  is encrypted; Pi's may or may not be)*. The §don't-adopt-Pi's-
  weaker-storage discipline — unlike cycle 117's adoption of
  Pi's JSONL transcript format, OAuth tokens are sensitive enough
  that Endo's encrypted store is mandatory.

  Three §Open questions:
    (1) **Lal vs Genie consolidation** — three options: (a) Lal
        consolidates onto Genie's pi-ai dependency, retiring
        packages/lal/providers/; (b) Lal and Genie coexist with
        separate registries; (c) registry lives in shared
        @endo/ai package both depend on; recommend *deferring to
        the maintainer after the OAuth flow's package-placement
        is settled*.
    (2) **Package placement** — @endo/lal vs @endo/lal-ai mirror
        of Pi's split.
    (3) **Subscription auth attack-surface widening** —
        subscription tokens are *account-level, not workspace-
        level* (API keys); §recommendation *UI confirmation step
        on first use + documentation that subscription tokens
        are equivalent to logging in on the web*.

  Single most structurally interesting move: the §account-level-
  vs-workspace-level distinction names the actual threat shape of
  subscription tokens *equivalent to logging in on the web*. The
  *broader-blast-radius* warning is the third Open question's
  most consequential framing.

  Six-phase implementation plan with phases 1+2 *partially
  satisfied via Genie*; phases 3+4 (OAuth) genuinely missing core
  of remaining work; phases 5+6 plumbing on top of registry.

  Five Pi citations file-level (including a directory citation
  for `packages/ai/src/providers/` — *30+ provider modules*).
  The §directory-not-file citation pattern for when individual
  citation count would be unwieldy.

  Four §Dependencies: lal-fae-form-provisioning (provider
  picking) + daemon-value-message (image payloads) +
  endopi-extension-package-manifest (new providers as packages) +
  gateway-bearer-token-auth (OAuth redirect endpoint for daemon-
  only build).

  Cycle 128 was nominally papers-lane (cycle 127 was comments).
  Papers-lane has been blocked for 22+ consecutive cycles. Cycle
  128 pivoted to designs-lane. Endopi-* family now at 7/9
  ingested (keystone + skills-markdown-format + jsonl-transcript-
  format + edit-tool + iterative-compaction + stdio-rpc-bridge +
  provider-registry-and-oauth). Two spinouts remain: extension-
  package-manifest / prompt-templates.
---

> Abstract: `endopi-provider-registry-and-oauth.md` (181 lines,
> *Proposed (partially satisfied)* status; Parent: endopi.md)
> closes the §Multi-provider LLM API gap from cycle 121's family
> keystone, which named *subscription auth as pi's highest-
> leverage feature for end users*. Same *partially-satisfied*
> lifecycle pattern as cycle 124's iterative-compaction: Genie
> already ships `pi-ai`'s full registry by transitive dependency,
> so the milestone's scope reduces to (a) OAuth flow, (b)
> cross-provider handoff, (c) image input wiring, (d) Lal-vs-
> Genie consolidation policy question.
>
> §ProviderInterface declared as `M.interface` with apiStyle
> (openai/anthropic/google/bedrock/custom) + authShape (apiKey/
> oauth/vertex/none) discriminators + listModels / complete /
> stream methods.
>
> §Subscription OAuth: authorization-code-with-PKCE. §Dual-
> redirect-URI discipline: Familiar pane (Electron build, cycle
> 109's `localhttp://`) or local 127.0.0.1 listener (daemon-only,
> cycle 111's gateway). Credentials encrypted at rest in the
> formula graph store; encryption key derived from passphrase or
> hardware key. §Pi-compatible OAuth credential file is *declined*
> — *we do not import Pi's auth file shape because the secrets
> boundary is different*.
>
> **Single most structurally interesting move**: the §account-
> level-vs-workspace-level distinction. The §third Open question
> names subscription auth's *broader-blast-radius* threat shape:
> *subscription tokens are equivalent to logging in on the web*.
> Recommendation: UI confirmation step on first use + explicit
> documentation.
>
> Three Open questions: Lal-vs-Genie consolidation (a/b/c options
> deferred to maintainer); package placement (@endo/lal vs
> @endo/lal-ai); subscription auth attack-surface widening.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question](../sections/endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question.md) | agent-conventions | current |

Tight 181-line *Proposed (partially satisfied)* design. The whole
argument hangs off one structural claim: *the registry refactor
is partially satisfied by Genie; OAuth is the genuinely missing
high-leverage piece*. One cohesion-honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@d77f3277` (the
  branch `origin/llm`) via the local bare-clone. Same commit as
  cycle 124's `endopi-iterative-compaction`.
- Last touched 2026-05-15 by kriscendobot in commit `d77f3277`.
- Status: *Proposed (partially satisfied)*. Parent: `endopi.md`
  (cycle 121's family keystone).
- **Twenty-fifth-comment-style design ingest.** Pairs with cycles
  112 + 117 + 121 + 122 + 124 + 126 to advance the endopi-*
  family to 7/9 ingested.
- Cycle 128 was nominally **papers-lane** (cycle 127 was
  comments). Papers-lane has been blocked for **22+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 128
  pivoted to designs-lane.
- Cohesion-honest one-section count.
