The DRAFT PR is confirmed against `llm`, inbox is clear. The job is complete.

## Completion report

**Job:** `design-endo-content-plane-git-http` — file the reserved second content data plane (Git over HTTP) for `endojs/endo-but-for-bots`, per the merged magnet-URN content-locator design's Follow-up back-planes.

**What I did:**
- Read the full substrate: the parent `endo-content-locators-magnet-urn.md` (registry, `@planes`, magnet grammar, Design Decisions 5 & 11), the **landed** `ContentDataPlane` registry (#789, `content-data-plane.js`/`types.d.ts`/`locator.js`/`manager.js`), the **sibling first plane** #792's actual diff (`makeHttpContentDataPlane`/`makeHttpContentShare` + the ws-gateway `/content` route + `fetchContent` tar), plus `daemon-git-remotes`, `daemon-git-capability` § Bulk Tree Data Plane, and `gateway-package` § Feature 3 (existing smart-HTTP git serving, `gitUploadPack`).
- Wrote `designs/endo-content-plane-git-http.md`: a Gateway-vended, read-only, content-scoped smart-HTTP git endpoint as the preferred **tree** carrier beside the web-seed plane. It reuses the reserved `xs` letter with a `git+` payload (no grammar change, no existing-plane change), serves git-backed trees directly and CAS-backed trees by deterministic on-demand git-object synthesis, and runs the recipient clone through a bounded, credential-free, `upload-pack`-only authority.
- Solved the crux the job names — **reconciling readable-tree `xt` (Endo tree-JSON hash) with git tree identity**: they never coincide, so git identity is transport/dedup-only and trust is re-established by re-hashing the materialized tree against `xt`. This keeps the plane untrusted (parent DD5) and makes it robust to the future CASK hashing change (parent DD11) by construction.
- Surfaced a concrete registry refinement the second plane is first to need: `getPlaneForSource` should resolve `(letter, payload)`, not a bare letter, once multiple planes claim `xs`.

**Verification:** mermaid diagram parse-validated (`mermaid.parse` → 1 `sequence` block OK); all 9 cross-referenced design files confirmed to exist (no dead links).

**Changed / opened:**
- New file `designs/endo-content-plane-git-http.md` on branch `design/endo-content-plane-git-http`.
- **DRAFT** PR **endojs/endo-but-for-bots#797** against base `llm` (confirmed `isDraft: true`).

**Follow-ups / flags:**
- The gate PR **#792 is still OPEN**, not merged, yet this job was promoted. I wrote against #789's landed registry + #792's current pre-merge shape and flagged this in the PR body and in a non-blocking message to the maintainer (possible unblock-watcher edge case where a `blocked` gate promoted early). If #792's surface shifts before merge, the doc may need a light reconcile.
- Milestone placement, dependency-graph edges, and the `designs/README.md` summary row are left to the next journalist classification cycle (matching how the parent deferred the same); noted in Open Questions.
