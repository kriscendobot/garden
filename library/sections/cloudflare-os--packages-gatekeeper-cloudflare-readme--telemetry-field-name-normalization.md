---
title: Telemetry field-name normalization
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [worker-observability]
status: current
---

Cloudflare telemetry returns structured log fields below `source` but indexes those fields by their bare names, so the Gatekeeper normalizes result paths and query keys across the mismatch.

An unknown key silently matches nothing, making naive reuse of `source.event` from a result appear valid while producing an empty page. Discovery reports indexed bare names, and the API accepts a `source.`-prefixed alias for filters, calculations, grouping, and value listing. The translation preserves the natural copy-a-result-path workflow without pretending that storage shape and index shape are identical.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
