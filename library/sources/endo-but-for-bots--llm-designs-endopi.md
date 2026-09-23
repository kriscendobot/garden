---
source: designs/endopi.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 32799a923d5c89b79c6416fbbb3bd85845f86c8d
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 2
status: current
notes: |
  Twenty-first-comment-style design ingest. The 583-line *Reference*
  design is the **family keystone** for the endopi-* cluster. Both
  prior endopi-* ingests (cycle 112's `endopi-skills-markdown-format`
  + cycle 117's `endopi-jsonl-transcript-format`) named this file
  as their Parent. Same author + companion to `endoclaw.md`:
  OpenClaw frames Endo's *assistant* shape; Pi frames Endo's
  *coding-agent* shape.

  Author Kris Kowal (prompted); last touched 2026-05-15 in
  `32799a923` by endolinbot — a bot revision adding §Endo-side
  surfaces covered + §Genie: Pi inside Endo (per jcorbin's inline
  review on PR #265) and a third revision pass correcting the
  sandbox-driver mix + adding the 9p filesystem alternative.

  Cohesion-honest two-section split. The 583-line design holds two
  argument clusters that operate on different Endo-side surfaces:

  Section 1 — *Lal/Fae* path (the *re-implement Pi's shape in
  Endo's idioms* tack). Covers:
    - The §Architecture Comparison 12-row table (*ambient authority
      + ergonomics* vs *least authority + auditable structure*)
    - §Target disambiguation (the four rejected alternatives;
      badlogic/pi-mono as canonical reference)
    - The eight §Feature-by-Feature Mapping tables, each spinning
      out a sibling design:
        edit-tool / jsonl-transcript-format (cycle 117) /
        provider-registry-and-oauth / extension-package-manifest /
        skills-markdown-format (cycle 112) / prompt-templates /
        context-files (tracked under skills) /
        stdio-rpc-bridge
      plus iterative-compaction (ninth) + html-export (tenth)
    - §Already-available, §Designed-but-not-implemented, §Endo-
      specific advantages (no Pi equivalent), and §Pi-specific moves
      Endo declines lists.

  Section 2 — *Genie* path (the *embed Pi inside Endo directly*
  tack). Covers:
    - §Genie: Pi inside Endo (`packages/genie` 0.0.1) — the third
      Endo-side surface that depends on `@mariozechner/pi-agent-core`
      + `pi-ai` directly
    - §Mapping table re-asking the umbrella questions of Genie,
      with different answers (LLM API via pi-ai registry verbatim;
      custom buildOllamaModel adaptor; tool-gate.js per-tool gating;
      Claw-compatible SOUL.md/HEARTBEAT.md workspace; observer +
      reflector compaction subagents; heartbeat autonomous executor;
      makeIntervalScheduler cron-style)
    - §What Genie's existence tells us — three implications:
      (1) provider-registry partially closed today (pi-ai full
      registry by transitive dependency)
      (2) compaction substrate now exists (observer + reflector
      pair); endopi-iterative-compaction's role shifts from
      *specify algorithm* to *harmonise with substrate*
      (3) confinement is the open question — packages/sandbox
      (podman/bwrap drivers + planned macOS/Windows) OR a 9p
      filesystem server that exports endo's space (jcorbin
      follow-up alternative)
    - §Upstream-Pi cross-reference — pi-mono package split (Genie
      depends on pi-agent + pi-ai, NOT pi-coding-agent; *Genie is
      closer to pi-agent than to pi-coding-agent*)
    - §Architectural Contrasts — the four worldview-level
      disagreements (capability model / persistence / extensibility
      / security / agent-orchestration shape) with the §Closing
      Thesis: *adopting Pi's developer-velocity moves (edit tool /
      JSONL transcripts / OAuth providers / skills format / RPC)
      without giving up Endo's multi-agent-system shape*.

  Single most structurally interesting move: *the Genie surface
  contradicts the comparative-mapping default* — instead of
  re-implementing Pi's shape in Endo's idioms, Genie depends on Pi
  directly and projects the result into Endo's event vocabulary.
  The *fill-the-Pi-gap-from-the-Endo-side* `buildOllamaModel`
  adaptor (masquerading ollama as `openai-completions` API style at
  `http://127.0.0.1:11434/v1` to bypass `pi-ai`'s absent native
  ollama entry) is the concrete idiom.

  The §Pi source-file citation index has 33 file-level citations
  spanning packages/coding-agent (cli; what the comparative-mapping
  addresses), packages/agent (SDK; what Genie embeds), packages/ai
  (provider/model abstraction; what Genie inherits the registry
  from). The 33 citations are reachable at the file-level via
  github.com/badlogic/pi-mono/blob/main URLs.

  Cycle 121 was nominally papers-lane (cycle 120 was comments).
  Papers-lane has been blocked for 15+ consecutive cycles
  (97/100/102/104/106/108/110/112/113/114/116/117/118/119/120) due
  to lack of PDF-fetching infrastructure. Cycle 121 pivots to
  designs-lane to ingest the endopi family keystone.
---

> Abstract: `endopi.md` is the **family keystone** the prior two
> endopi-* ingests (cycle 112 + cycle 117) named as their Parent.
> The 583-line *Reference* comparative-analysis design maps Pi's
> surface (Mario Zechner's `badlogic/pi-mono` terminal coding-agent
> harness, ~49.5k stars, MIT) onto Endo's surface (daemon + chat +
> familiar + cli + lal + fae + genie) and inventories the gaps
> worth closing as sibling designs.
>
> The §Architecture Comparison 12-row table frames the worldview:
> Pi takes the *ambient authority + ergonomics* path; Endo takes
> the *least authority + auditable structure* path. The §Bet of
> Endo: *capability confinement will pay off when agents act on
> behalf of users who cannot evaluate the agent's source code*.
>
> The §Feature-by-Feature Mapping section runs eight (plus two)
> tables — each spinning out a sibling design for one Pi-Endo gap:
> edit-tool / jsonl-transcript-format / provider-registry-and-oauth
> / extension-package-manifest / skills-markdown-format /
> prompt-templates / context-files / stdio-rpc-bridge, plus
> iterative-compaction and html-export.
>
> The §Genie: Pi inside Endo section adds a third Endo-side surface
> (`packages/genie` 0.0.1, pre-release) that depends on
> `@mariozechner/pi-agent-core` + `pi-ai` directly — the
> *embedding* path that contradicts the comparative-mapping
> default. Genie ships the §observer + reflector compaction
> substrate, the §SOUL.md/HEARTBEAT.md Claw-compatible workspace,
> the §makeIntervalScheduler cron-style autonomous executor.
> Genie's tool surface runs with ambient Node authority — the
> §confinement story is the open question (packages/sandbox via
> podman/bwrap + planned macOS/Windows drivers, OR a 9p filesystem
> server exporting endo's space).
>
> The §Architectural Contrasts close the design with four
> worldview-level disagreements (capability model / persistence /
> extensibility / security / agent-orchestration shape) and the
> §Closing Thesis: *adopting Pi's developer-velocity moves without
> giving up Endo's multi-agent-system shape*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts](../sections/endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts.md) | agent-conventions, capability-security | current |
| [genie-pi-inside-endo-and-the-four-architectural-contrasts](../sections/endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts.md) | agent-conventions, capability-security | current |

The 583-line design holds two argument clusters that operate on
different Endo-side surfaces. Section 1 covers the *Lal/Fae* path
(re-implement Pi's shape in Endo's idioms) — the comparative-
mapping frame + eight spinout-gap tables + the
Already-available/Designed/Declined inventories + the
Endo-specific-advantages list. Section 2 covers the *Genie* path
(embed Pi inside Endo directly) — the `packages/genie` third
surface + the implications-of-Genie's-existence + the pi-mono
package-split cross-reference + the four architectural-contrasts
worldview codification. The two paths answer the same questions
differently; the split is cohesion-honest.

## Provenance

- Fetched 2026-06-02 from
  `endojs/endo-but-for-bots@32799a923` (the branch `origin/llm`)
  via the local bare-clone.
- Last touched 2026-05-15 by endolinbot (the bot identity) in the
  third revision pass per jcorbin's follow-up review on PR #265.
  Author field: *Kris Kowal (prompted)*. The original creation +
  first revision (also 2026-05-15) was authored by kriscendobot.
- Created + updated 2026-05-15; status *Reference*. The dual-pass
  revision history is the *PR-#265 review-driven incremental
  refinement* lifecycle pattern.
- **Twenty-first-comment-style design ingest.** Pairs with cycle
  112's `endopi-skills-markdown-format` + cycle 117's
  `endopi-jsonl-transcript-format` to complete the *family-
  keystone + two-already-ingested-spinouts* triple. The remaining
  six spinouts are still unindexed:
  `endopi-edit-tool` / `endopi-extension-package-manifest` /
  `endopi-iterative-compaction` / `endopi-prompt-templates` /
  `endopi-provider-registry-and-oauth` /
  `endopi-stdio-rpc-bridge`.
- Cycle 121 was nominally **papers-lane**. Papers-lane has been
  blocked for **15+ consecutive cycles** (97/100/102/104/106/108/
  110/112/113/114/116/117/118/119/120) due to lack of PDF-
  fetching infrastructure. Cycle 121 pivoted to designs-lane to
  ingest the endopi family keystone.
- Cohesion-honest two-section count. The 583-line design holds two
  argument clusters operating on different Endo-side surfaces
  (Lal/Fae vs Genie) and answering the same comparative questions
  with different answers; the split honors that.
