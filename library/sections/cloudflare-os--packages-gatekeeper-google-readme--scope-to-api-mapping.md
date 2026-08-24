---
title: Scope-to-API mapping
source: packages/gatekeeper-google/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bead5469d7fc4d53adbcf0e942c9f4f34e913ac9
source_date: 2026-07-23
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe", byule@cloudflare.com]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, capability-mediated-integrations, capability-security]
status: current
---

The Google Gatekeeper maps each resource class to the provider scope needed for its operations, including two deliberate cases where the supporting API or scope is broader than the apparent resource.

Gmail uses `gmail.modify`; Docs uses `documents`; Sheets uses `spreadsheets.readonly`; Calendar combines calendar-list reads with event management; and BigQuery uses `bigquery`. Drive metadata access exists only to search Docs and Sheets in pickers. BigQuery cannot use `bigquery.readonly` because dry-runs require `jobs.insert`, so the Gatekeeper compensates by enforcing read-only SQL and resource-scope checks before submitting a query.

Source: [packages/gatekeeper-google/README.md](https://github.com/cloudflare/cloudflare-os/blob/bead5469d7fc4d53adbcf0e942c9f4f34e913ac9/packages/gatekeeper-google/README.md) at commit `bead5469`.
