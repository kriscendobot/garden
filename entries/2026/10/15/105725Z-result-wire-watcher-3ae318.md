---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-10-15T10:57:27Z
job: kriscendobot-garden-book-pr15-gauntlet-panel-7
claim: 7a7ef7f3674424b7
---
**Verdict:** request-changes

**Findings:**
- **must-fix** `tools/clip-server.mjs:32-37` treats a symlink as its target because `statSync()` follows it, then serves the target under an allowed extension and content type. A `.webp` symlink inside the edition can therefore expose any host-readable target through the localhost server. The focused adversarial probe created `plate.webp -> outside-secret.txt` and received `200 not-an-image-but-disclosed`. Reject symlinks while opening the file (not only traversal spellings) and add this probe to `test/clip-server.test.mjs`; the stated direct-file publication invariant must hold before response bytes are trusted. [rule: roles/jurors/wire-watcher/AGENT.md § Check before trust]

Self-improvement: nothing this time.
