---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-04T00:42:48Z
---
# result: scholar-ingest-cedar-access-control-for-ai-agents

Ingested the Cedar access-control material (issue-kriscendobot-garden-79) and posted the minion.town/Endo findings comment.

## Sources ingested
- **cedar-aws-announcement** (https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/, `source_content_sha256` 0eb61f66, fetched direct) — 3 sections: overview (policy-as-code, RBAC/ABAC, decouple-from-app-logic), verification-guided-development (formally-modeled Rust engine), verified-permissions-and-local-use (central auditable store + offline libs).
- **thestack-cedar-for-ai-agents** (https://www.thestack.technology/cedar-the-access-control-building-block-thats-perfectly-timed-for-ai-agents/, `source_content_sha256` 02ede54a, fetched direct) — 1 section (overview); **PAYWALLED**, only the free introduction retrievable (`status: partial`), body not read.
- **cedarpolicy.com/en/integrations** — NOT ingested: client-rendered SPA (served HTML is the Cedar Language Playground shell, empty `<div id="app">`); no integration list retrievable as text. The integration-*class* analysis was reasoned from Cedar's documented model instead and lives in the concept page + issue comment.

## Topics/concepts touched
- New topic **policy-language-authorization** (Cedar as worked example; the reference-monitor complement to capability-security).
- New concept **cedar-policy-language** (Cedar's PARC/RBAC/ABAC/verified-engine model).
- New concept **policy-vs-capability-authorization** — the analytical through-line: ambient-authority policy engine vs ocap-behind-the-tool-call, per-integration-class verdicts (ocap subsumes the interior; policy only at the mint boundary + declarative/reference-less rule sets), and concrete @endo/gateway + @endo/mcp ideas (mint-at-edge, attenuation-as-tool-primitive, legible grant graph, UCAN middle-ground). Draws the through-line to the existing ocap corpus (confused-deputy, caretaker-pattern, capability-chain, capability-mediated-integrations) and the minion.town ocap direction.
- Indexes updated: sources/README (2 rows), topics/README (1 row + count), concepts/README (2 bullets), keywords.md (2 lines).

## Gates
- library-link-check.sh --changed: **OK** (both Cedar clusters + all touched index rows resolve to committed files).
- regenerate-topics-counts.sh --check: **current**.
- regenerate-sections-index.sh: landed (new sections projected); regenerate-topics-counts.sh: already current.

## Deliverable
- Findings comment posted: https://github.com/kriscendobot/garden/issues/79#issuecomment-5534022876 (did NOT close the issue, per instructions).

## Follow-ups
- None required. If the maintainer wants the paywalled article body or a rendered capture of the integrations SPA (which would need a headless browser, out of scholar scope), a follow-on `scholar-ingest-source` could carry it, but the two open AWS sources + reasoned class analysis already answer the maintainer's question.
