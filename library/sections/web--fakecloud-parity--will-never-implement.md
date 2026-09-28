---
title: What fakecloud will never implement
source_kind: web
source_url: https://fakecloud.dev/docs/parity
source_content_sha256: ee0e08c4fd9a477add0cf8f22d9a97e65951f9f48472c04429eb6154da0166db
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

The deliberate non-goals — features needing real AWS infrastructure, proprietary data, or external networks (Bedrock weights, a real CA for ACM, WAF managed-rule content, public DNS, the CloudFront edge, real outbound email/SMS, EBS/EFS block storage, RTMP) — each replaced by a clearly synthesized stand-in so tests are not silently wrong.

"A small set of features depend on real AWS infrastructure, vendor-internal data, or external networks that a local emulator fundamentally cannot replicate. fakecloud is committed to not faking these — we surface a clearly synthesized stand-in instead so tests are not silently wrong."

- **Bedrock foundation-model weights:** not shipped. Point `FAKECLOUD_BEDROCK_UPSTREAM_URL` at a real LLM endpoint (Anthropic, an OpenAI-compatible server, or Ollama) and `InvokeModel`/`Converse`/streaming perform genuine inference, translating both directions; unconfigured, the runtime returns deterministic offline responses with real token counting and fault injection.
- **Bedrock Agent semantic responses** (`InvokeAgent`, `RetrieveAndGenerate`): shape-correct synthetic chunks.
- **ACM real certificate authority:** certificates are self-signed or imported PEM; trust them locally for testing only.
- **WAFv2 AWS Managed Rule Group content:** references accepted and structurally evaluated; the proprietary rule bodies are not the real AWS content.
- **Real public DNS (Route 53):** `TestDNSAnswer` resolves against local state; an opt-in UDP/TCP 53 server is available but not Internet-facing.
- **CloudFront global edge network:** a single-node in-process data plane serves origins locally; no distributed edge, per-PoP behavior, or edge caching.
- **Real outbound email and SMS (SES, SNS):** messages land in the introspection ledger; the opt-in SMTP submission listener (`FAKECLOUD_SES_SMTP_PORT`) does not relay to the public Internet.
- **EBS/EFS block storage:** out of scope; EFS on ECS is mounted as Docker volumes.
- **CloudFront RTMP streaming distributions:** configuration round-trip only; wontfix.

The page invites an issue describing what a user is trying to test when a listed gap blocks them, since "there is often a smaller, targetable surface that fakecloud can implement instead."

Source: [fakecloud parity matrix](https://fakecloud.dev/docs/parity), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
