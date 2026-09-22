Completion report:

## Review directive on endojs/endo-but-for-bots PR #1226 — done

**Preflight:** exit 0 (PROCEED, no peer resolution). The review (`5273006881`, body `@kriscendobot rsvp`, CHANGES_REQUESTED, by kriskowal) targets the design PR `docs(designs): a stdio MCP server scoped to one guest's tool surface` on the `design/endo-guest-stdio-mcp` branch. Treated as design revision work (design doc, no code build). All fetched bodies handled as untrusted data.

**Enumerated all 6 inline comments + review body, and resolved each:**

1. **superfluous meta-narrative (line 35)** → removed the "Updated 2026-09-21" revision-narrative paragraph from § Status (its design content already lives in § Scoping).
2. **"don't consolidate these yet… more than one way to use Claude" (line 748)** → struck the reconcile-to-single-model open question; both topologies (harness-owned broker / server-held connection) now stand as coexisting across § Scoping, the cross-document note, Dependencies, and Design Decision 1.
3. **"MCP server reaches daemon via UDS, drill down to the guest facet, always dispatch through that guest and no other" (line 757)** → stated directly in § Scoping; confined `claude` free to use any authority the guest holds (facet is the ceiling); scoped-bootstrap named as the clean confined-shape realization.
4. **"pin this down now… investigate options" (config intake, line 763)** → decided: `--mcp-config` file path backed by anonymous pipe/`memfd` (no on-disk file, no inline JSON on argv, no shell `<(…)`), matching endo-claude's already-pinned contract; formula id in `env`.
5. **"claude must be denied arbitrary socket access, else forfeit" (line 770)** → struck the "rely on formula-id secrecy" fallback; restored the non-negotiable confinement premise (sandbox denies the confined tree the daemon socket); daemon connection lives outside the confined tree in the confined shape; updated the endo-posix-sandbox dependency row to make socket-denial load-bearing.
6. **"expose a logging facet, mechanism immaterial" (line 775)** → resolved: server exposes a logging facet + advertises MCP `logging`; log source left an implementation detail.

**Changes landed:** one commit `c1df1296ee62ffa49fba4e2efdfd133ae5e1e343` pushed to `design/endo-guest-stdio-mcp` (rebase-CAS). Only `designs/endo-guest-stdio-mcp.md` committed; an unrelated `packages/floot/package.json` unicode-escape rewrite from the warm-cache install was left uncommitted. Mermaid re-validated parse-only (`flowchart-v2 OK`).

**RSVP:** 6 SHA-citing threaded replies posted (via `/replies`, bodies passed as files; backticks verified intact) + 1 top-level summary comment (`#issuecomment-5769713564`) mapping every ask to its outcome.

**Follow-ups (genuinely open, narrowed to schedule/verification):** (a) scoped-bootstrap timing — daemon-issued guest-scoped bootstrap now vs. broker-narrows-host-root first; (b) sandbox verification with endo-posix-sandbox that the slice denies the confined tree the socket while the harness-owned connection process reaches it from outside. Both are surfaced in the design's Open Questions and the summary. PR remains DRAFT (design-stage; no build).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-review-adf95686.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (7152883 cached reads)
- Output: 52838 tokens
- Cost: $6.3357105
- Wall-clock: 954s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
