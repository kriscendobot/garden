---
title: §Before-and-after as named code-block comparison shape
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

§The-blog-uses-§Before-and-after-code-blocks to make the architectural change concrete:

**Before (`2025-11-25`)** — two-request session-pin:

```
POST /mcp HTTP/1.1
Content-Type: application/json
{"jsonrpc":"2.0","id":1,"method":"initialize", ...}
```

then with `Mcp-Session-Id` returned from server:

```
POST /mcp HTTP/1.1
Mcp-Session-Id: 1868a90c-3a3f-4f5b
Content-Type: application/json
{"jsonrpc":"2.0","id":2,"method":"tools/call", ...}
```

**After (`2026-07-28`)** — single self-contained request:

```
POST /mcp HTTP/1.1
MCP-Protocol-Version: 2026-07-28
Mcp-Method: tools/call
Mcp-Name: search
Content-Type: application/json
{"jsonrpc":"2.0","id":1,"method":"tools/call",
 "params":{"name":"search","arguments":{"q":"otters"},
           "_meta":{"io.modelcontextprotocol/clientInfo":{"name":"my-app","version":"1.0"}}}}
```

§Before-and-after-code-block-pair-with-named-version-numbers as named announcement-discipline. §When-a-protocol-version-changes-the-shape-of-its-canonical-request, §show-the-before-and-after-side-by-side + §the-comparison-IS-the-explanation. §First-explicit-observation in library of §Before-and-after-code-block-pair-with-named-version-numbers.

§Sibling-pattern-to-cycle-238's-Comparison-table-with-PR-#144-shape-vs-revised-shape — §two-different-shapes-of-before-and-after: §cycle-238 tabular-comparison + §cycle-251 code-block-comparison. §Two-cycles-with-explicit-before-and-after-comparison.
