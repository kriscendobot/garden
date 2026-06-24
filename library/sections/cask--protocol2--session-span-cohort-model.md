---
title: CASK Network Protocol v2 (superseded) — session, span, and cohort model
source: doc/design/protocol2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: superseded
notes: |
  Never-implemented v2 proposal. The shipped session model is the
  Noise-IK / encrypted-session design of cask--net-crypto--* and
  cask--net-session-init-design--*, not this signed-session-number scheme.
  Retained for the span/cohort tracing model, which informed the shipped
  trace/trace2 telemetry design.
---

## Abstract

The session, span, and cohort identity model proposed for the never-built v2, plus its protocol flow, timeout/retry guidance, and v1-migration plan. Sessions are 64-bit numbers signed by the recipient's ed25519 private key (to prevent collision and unauthorized creation) that scope spans. Spans are 64-bit per-session correlation IDs for Dapper-style distributed tracing, with each peer maintaining its own span counter and responses echoing session and span. Cohorts are 64-bit identifiers that double as a priority and a trace-aggregation grouping; responses must echo the request's cohort, and cohorts can drive priority queues, trace aggregation, and request scheduling. **This signed-session-number scheme was never implemented**; the shipped casknet uses Noise-IK handshakes and encrypted-session tables. The dual-purpose cohort idea, however, is the lineage ancestor of the shipped TrafficClass/Priority telemetry model.

## Sessions

Sessions are identified by 64-bit session numbers signed by the recipient's public key to prevent collision and ensure authenticity (the signature mechanism left implementation-specific, intended to prevent unauthorized session creation). Sessions scope spans to prevent collisions across sessions. The recipient's 32-byte ed25519 public key is included in every message and validated on receipt; only authorized parties can create valid sessions for a given recipient.

## Spans

Spans are 64-bit identifiers for request correlation and Dapper-style distributed tracing, scoped to a session so multiple concurrent requests coexist. Each peer maintains its own span counter within a session; spans wrap at 2^64; responses echo the session and span from the corresponding request. Spans trace request flows across multiple hops.

## Cohorts

Cohorts are 64-bit identifiers used for prioritizing and aggregating trace spans: they group related spans for analysis, prioritization, and scheduling, are scoped to sessions, and can coordinate related operations. Responses must echo the request's cohort. Cohorts can implement priority queues, trace aggregation, and coordinated request handling. This dual trace-identifier-and-priority role is the same idea the design brief (`cask--protocol2-arch--design-brief`) asked to be named, and it carried into the shipped TrafficClass/Priority model (`[[codel-send-buffer-shedding]]`, `cask--trace2--traffic-class-and-priority`).

## Protocol flow, timeouts, migration

**Flow.** STOR is fire-and-forget (client sends, server validates and stores, no response, client may retry on timeout). LOAD is request/response (server replies with a STOR carrying the block; no response means not-found, and timeout indicates failure).

**Timeouts and retries.** Recommended LOAD response timeout 10 seconds; exponential backoff; at most 3 retries for STOR (fire-and-forget) and 5 for LOAD; timeout handling implementation-specific.

**Migration from v1.** Dual-protocol support on different ports during transition; version detection from the first 4 bytes (v1 lowercase `stor`/`load` vs v2 uppercase `STOR`/`LOAD`); gradual per-client migration; v1 fallback for legacy clients.

## Security considerations

Hash validation (compute SHA-256, compare, reject mismatches, never trust the hash without validating); session numbers signed by the recipient's private key to prevent unauthorized session creation; recipient public keys validated on receipt; session-establishment mechanisms left implementation-specific.

Source: [doc/design/protocol2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol2.md) at commit `cdb975d8`.
