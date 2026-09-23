---
title: §W3C Trace Context propagation locking-down key names in `_meta` (SEP-414)
source-slug: mcp-blog--2026-07-28-release-candidate
source-url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
parent: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum
---

§W3C-Trace-Context-propagation-in-_meta-is-now-documented + §locking-down-the-traceparent-tracestate-and-baggage-key-names + §so-distributed-traces-correlate-across-SDKs-and-gateways. §Several-SDKs-and-tools-were-already-doing-this — §the-spec-formalizes-existing-practice.

§Three-named-key-names (traceparent + tracestate + baggage). §When-existing-SDK-practice-uses-particular-key-names-for-distributed-tracing, §formalize-them-in-the-spec + §locking-down-the-key-names-is-the-correlation-mechanism.

§A-trace-that-starts-in-a-host-application-can-follow-a-tool-call-through-the-client-SDK-the-MCP-server-and-whatever-the-server-calls-downstream + §show-up-as-a-single-span-tree-in-an-OpenTelemetry-compatible-backend.

§First-explicit-observation in library of §formalize-existing-key-names-in-spec as named correlation-mechanism. §Sibling-to-cycle-239's-named-protocol-constant — §two-cycles-with-named-protocol-string-key-conventions.
