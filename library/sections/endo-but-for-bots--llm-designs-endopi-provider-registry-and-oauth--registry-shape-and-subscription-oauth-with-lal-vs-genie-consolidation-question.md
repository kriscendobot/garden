---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
---

# Registry shape and subscription OAuth with Lal-vs-Genie consolidation question

> *Net: this milestone's remaining scope reduces to (a) the OAuth
> flow, (b) cross-provider handoff plumbing, (c) image input
> wiring, and (d) the policy question of Lal-vs-Genie
> consolidation. The original "30+ providers" framing is no longer
> the headline.*
>
> — `designs/endopi-provider-registry-and-oauth.md` §Status

`endopi-provider-registry-and-oauth.md` (181 lines, *Proposed
(partially satisfied)* status, created 2026-05-15) is the seventh
endopi-* design ingested and the fifth spinout from cycle 121's
family keystone. Parent: `endopi.md`. The design closes the
§Multi-provider LLM API gap that cycle 121's keystone named as
*pi's highest-leverage feature for end users* (subscription auth:
Claude Pro/Max, ChatGPT Plus/Pro, GitHub Copilot accounts instead
of API keys).

## The *partially satisfied* Status — six-axis scope refinement

The §Status block is the most operationally interesting paragraph.
Like cycle 124's `endopi-iterative-compaction`, this design uses
the *partially-satisfied* lifecycle pattern. The §opening
observation:

> *`packages/genie` (pre-release, 2026 Q2) already depends on
> `@mariozechner/pi-ai` directly and ships an ollama provider
> adaptor (`buildOllamaModel` in
> `packages/genie/src/agent/index.js`) that masquerades the local
> ollama HTTP endpoint as the `openai-completions` API style.
> Genie therefore exposes `pi-ai`'s full provider registry inside
> Endo today, without the registry-shape refactor this design
> proposes for Lal.*

Cycle 121's §What Genie's existence tells us already made this
point: *the provider-registry gap is partially closed today;
Genie ships pi-ai's full registry by transitive dependency*.

The §What this means for the milestone enumerates *six axes* and
their satisfaction status:

| Phase | Axis | Status |
|-------|------|--------|
| 1 | Registry shape | Partially — Genie has a working consumer; Lal refactor still needed if Lal stays parallel |
| 2 | API-key providers (30+) | Available via Genie today through `pi-ai` |
| 3 | OAuth — Claude subscription | **Genuinely missing**; highest-leverage |
| 4 | OAuth — ChatGPT Plus + Copilot | **Genuinely missing** |
| 5 | Cross-provider handoff | Missing; Genie inherits the registry but doesn't exercise mid-session switching |
| 6 | Image input | Inherits from pi-ai per provider; Endo-side daemon-value-message plumbing unchanged |

The §scope-reduction observation:

> *The original "30+ providers" framing is no longer the headline.*

The design's *headline-has-moved* discipline is the same as cycle
124's iterative-compaction: the algorithm/registry already exists;
the design's role shifts to *picking which substrate-already-
exists-via-Genie pieces to harmonise into Lal vs leave to Genie's
embedding path*.

## The §ProviderInterface — M.interface declaration

The §Provider registry §Design subsection shows the registry as an
`M.interface` declaration:

```js
const ProviderInterface = M.interface('Provider', {
  // Static metadata
  name: M.call().returns(M.string()),
  apiStyle: M.call().returns(M.string()), // 'openai' | 'anthropic' | 'google' | 'bedrock' | 'custom'
  authShape: M.call().returns(M.string()), // 'apiKey' | 'oauth' | 'vertex' | 'none'

  // Model discovery
  listModels: M.callWhen().returns(M.arrayOf(M.record())),

  // Completion
  complete: M.callWhen(M.record()).returns(M.record()),
  stream: M.callWhen(M.record()).returns(M.remotable('AsyncIterable')),
});
```

The §registry-as-interface-guard discipline uses Endo's native
@endo/patterns + @endo/exo machinery (cycles 118 + 127 et al.) to
declare the provider contract. Each provider registers as an exo
implementing the `ProviderInterface`. The §apiStyle + authShape
discriminators are *string sums* matching Pi's `pi-ai` taxonomy
(`'openai'|'anthropic'|'google'|'bedrock'|'custom'` for API style;
`'apiKey'|'oauth'|'vertex'|'none'` for auth shape).

Providers *register themselves at daemon start; new providers ship
as guest plugins per
[endopi-extension-package-manifest](endopi-extension-package-manifest.md)*.
The §extension-package-manifest sibling (still unindexed) is the
distribution surface; the §registry is the runtime surface they
register into.

## §Subscription OAuth — *authorization-code-with-PKCE*

The §Subscription OAuth subsection is *the headline feature*. The
core mechanism:

> *A separate auth-storage exo holds OAuth credentials per
> provider, keyed by provider name and account ID. The OAuth flow
> is the standard authorization-code-with-PKCE path; the redirect
> URI is a Familiar pane (in the Electron build) or a local HTTP
> listener bound to `127.0.0.1` (in the daemon-only build, per
> [gateway-bearer-token-auth](gateway-bearer-token-auth.md)).*

Two structurally interesting moves:

1. **The §dual-redirect-URI discipline**: Familiar pane in the
   Electron build (uses cycle 109's electron-shell's
   `localhttp://` protocol and `protocol.handle` to intercept the
   OAuth redirect); local HTTP listener bound to 127.0.0.1 in the
   daemon-only build (uses cycle 111's familiar-gateway-migration's
   gateway server). Both paths satisfy the OAuth spec's
   *registered-redirect-URI* requirement without forcing a public
   HTTPS endpoint.

2. **The §encrypted-at-rest credential discipline**:
   > *Credentials are stored encrypted at rest, in the same store
   > as the formula graph, with the encryption key derived from
   > the host's passphrase or a hardware key per the existing
   > daemon pattern.*

   The §key-derivation-from-host-passphrase-or-hardware-key is the
   *existing-daemon-pattern* discipline; OAuth tokens get the same
   treatment as any other secret in the formula graph.

The §Out of scope explicitly declines Pi's auth-file shape:

> *Pi stores OAuth tokens under `~/.pi/agent/auth/`; Endo's store
> lives in the formula graph. We do not import Pi's auth file
> shape because the secrets boundary is different (the Endo store
> is encrypted; Pi's may or may not be).*

The §secrets-boundary-is-different rationale is the
*don't-adopt-Pi's-weaker-storage* discipline — unlike cycle 117's
adoption of Pi's JSONL transcript format (where Pi's storage shape
is *fine* and only needs Endo extensions), OAuth tokens are
*sensitive enough that Endo's encrypted store is mandatory*. The
authorship-shape gets adopted; the storage-shape doesn't.

## §Cross-provider handoff — *the registry above is the substrate*

The §Cross-provider handoff subsection is structurally brief:

> *Pi supports mid-session handoff (e.g., start on a fast model
> for exploration, switch to a slow reasoning model for the hard
> part). Lal's in-memory transcript already supports this in shape;
> the daemon-side plumbing is missing. The registry above is the
> substrate.*

The §the-registry-is-the-substrate move: once the
ProviderInterface is in place, mid-session switching is *just
calling `complete(...)` on a different provider exo*. The
transcript already carries the sequence of messages independent
of which provider produced each one. The §missing-plumbing is the
control-plane piece (a `/model <provider>:<name>` slash command,
or a `set_model` RPC command per cycle 126's
endopi-stdio-rpc-bridge).

## Six-phase implementation plan

The §Phased implementation lists six phases, in dependency order:

1. **Registry shape, existing five providers re-registered.** No
   new provider yet; the goal is to retire the static dispatch
   and prove the registry surface.
2. **API-key providers via the registry.** Add 5 to 10 new
   providers (DeepSeek, Mistral, Groq, Cerebras, xAI, OpenRouter,
   Vercel AI Gateway). Each is a small module.
3. **OAuth: Claude subscription.** First subscription provider.
   Defines the OAuth-flow plumbing.
4. **OAuth: ChatGPT Plus (Codex), GitHub Copilot.** The remaining
   two subscription providers Pi supports.
5. **Cross-provider handoff.** `/model` mid-session switches the
   agent to a new provider; the transcript carries forward.
6. **Image input.** Where the provider supports it, image
   attachments on user messages flow through to the LLM.

Phases 1+2 are *partially satisfied via Genie* per the §Status
block. Phases 3+4 (OAuth) are the *genuinely missing* core of the
remaining work. Phases 5+6 are *plumbing on top of the registry*.

## §Three Open questions — *deferred-to-maintainer* discipline

The §Open questions paragraph names three undecided issues:

1. **Lal vs Genie consolidation.** Three options:
   - (a) Lal consolidates onto Genie's `pi-ai` dependency,
     retiring `packages/lal/providers/`
   - (b) Lal and Genie coexist with separate registries
   - (c) The registry lives in a new shared `@endo/ai` package
     that both depend on

   *Recommend deferring to the maintainer after the OAuth flow's
   package-placement is settled.* The *option-(a)-vs-(b)-vs-(c)
   deferred-to-maintainer* is the §three-way-policy-question
   pattern — the design lays out the trade-offs but doesn't
   prescribe.

2. **Package placement** — `@endo/lal` vs `@endo/lal-ai` (mirror
   Pi's split for non-Lal consumer reuse).

3. **Subscription auth attack-surface widening** — subscription
   tokens are *account-level*, not *workspace-level* (API keys).
   The §recommendation: *a UI confirmation step on first use, plus
   documentation that subscription tokens are equivalent to
   logging in on the web*. The §account-level-vs-workspace-level
   distinction is the broader-blast-radius warning — *subscription
   tokens are equivalent to logging in on the web* names the
   actual threat shape (a leaked subscription token compromises
   the account, not just the workspace).

## Five file-level Pi citations

The §Citation section cites five pi-mono files:

- `packages/ai/README.md`
- `packages/ai/src/api-registry.ts`
- `packages/ai/src/oauth.ts`
- `packages/ai/src/models.ts`
- `packages/ai/src/providers/` (directory; *30+ provider modules*)

The §directory-not-file citation for `providers/` is structurally
worth noting — *thirty plus modules* is too many to cite
individually; the directory is the reference. Pi's `pi-ai` package
provides the *full registry by transitive dependency* per the
§Status block.

## Endopi-* family arc progress

The endopi-* family is now at **7/9 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md`
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone)
- cycle 122 — `endopi-edit-tool.md`
- cycle 124 — `endopi-iterative-compaction.md`
- cycle 126 — `endopi-stdio-rpc-bridge.md`
- **cycle 128 (this cycle)** —
  `endopi-provider-registry-and-oauth.md`

Two spinouts remain: `endopi-extension-package-manifest` /
`endopi-prompt-templates`.

## Related sections

- cycle 121 family keystone
  [[endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts]]
  — the §Multi-provider LLM API table that named this design as
  the gap-closer, with the §subscription auth highest-leverage
  observation.
- cycle 121 Genie section
  [[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]]
  — the §provider-registry-partially-closed-today implication
  that this design embodies; the `buildOllamaModel` adaptor
  named here.
- cycle 124
  [[endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking]]
  — sibling endopi-* spinout with the same *partially satisfied*
  lifecycle pattern (anticipated-design-vs-shipped-substrate
  mismatch).
- cycle 109
  [[endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol]]
  — the `localhttp://` protocol that the §dual-redirect-URI
  discipline uses for the Electron-build OAuth redirect path.
- cycle 111
  [[endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon]]
  — the daemon-side gateway that the §dual-redirect-URI
  discipline uses for the daemon-only-build local 127.0.0.1
  redirect path.
- cycle 126
  [[endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui]]
  — the `set_model` RPC command that exercises the
  §cross-provider-handoff phase.
