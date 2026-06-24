---
ts: 2026-06-02T22:41:03Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--df39dc
cycle: 128
---

# Cycle 128 — endopi-provider-registry-and-oauth.md (Kris Kowal, endo-but-for-bots) — seventh endopi-* spinout

Ingested `designs/endopi-provider-registry-and-oauth.md` (181
lines, *Proposed (partially satisfied)* status, Parent: endopi.md)
from `endojs/endo-but-for-bots@d77f3277` (branch `origin/llm`).
**Twenty-fifth-comment-style design ingest.** One cohesion-honest
section:

- **registry-shape-and-subscription-oauth-with-lal-vs-genie-
  consolidation-question** — closes the §Multi-provider LLM API
  gap from cycle 121's family keystone (*subscription auth is
  pi's highest-leverage feature for end users*). Same
  *partially-satisfied* lifecycle pattern as cycle 124's
  iterative-compaction: Genie ships pi-ai's full registry by
  transitive dependency, so the milestone's scope reduces to (a)
  OAuth flow, (b) cross-provider handoff plumbing, (c) image
  input wiring, (d) Lal-vs-Genie consolidation policy question.

## The single most structurally interesting move

The §account-level-vs-workspace-level distinction names the
threat shape of subscription tokens: *subscription tokens are
equivalent to logging in on the web*. The §broader-blast-radius
warning is the third Open question's most consequential framing.
Recommendation: UI confirmation step on first use + explicit
documentation that *subscription tokens are equivalent to
logging in on the web*.

## §Pi-compatible OAuth credential file declined

The §Out of scope contrast with cycle 117's
`endopi-jsonl-transcript-format`: cycle 117 *adopted* Pi's JSONL
file shape (because Pi's storage is fine); this cycle *declines*
Pi's auth file shape because *the secrets boundary is different
(the Endo store is encrypted; Pi's may or may not be)*. The
§don't-adopt-Pi's-weaker-storage discipline is structurally
distinct from cycle 117's §adopt-Pi-format-with-endo-extensions.

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

## Rotation note

Cycle 128 was nominally **papers-lane** (cycle 127 was
comments). Papers-lane has been blocked for **22+ consecutive
cycles** (97/100/102/104/106/108/110/112/113/114/116/117/118/119/
120/121/122/123/124/125/126/127) due to lack of PDF-fetching
infrastructure. Cycle 128 pivoted to designs-lane.

## Counts

- 631 → **632** sections (+1).
- 172 → **173** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — seventh
  endopi-* row in this topic).
- Keywords index extended with ~32 provider-registry-and-oauth-
  specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 129 wakes in 1500s. Rotation lands on **chat-lane**
nominally (still exhausted at 20/20). Expect a pivot. Two
endopi-* spinouts remain (extension-package-manifest /
prompt-templates).
