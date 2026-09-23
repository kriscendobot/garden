Everything is in place. Inbox empty, PR #89 open with the full deliverable and durable marker. Final report:

---

## Completion report — `minion-town-clip-formula-id-origin-gc`

**Deliverable:** design PR **[kriscendobot/minion.town#89](https://github.com/kriscendobot/minion.town/pull/89)** (draft, against `main`), plus an amendment to `designs/clip-ocap-synthesis.md` § 9. New doc: `designs/clip-formula-id-origin-and-content-gc.md`. No prior claimant had committed work or opened a PR; started fresh.

**Part A — clip identity: verified sound live, no code fix warranted.**
- **Code trace (all guest-reachable paths):** the `<hash>.ocap.site` origin is `base32(directoryFormulaId)` — a fresh random 256-bit id per publish (scaffold) or the directory's own `identify` formula id (live exo) — **never** a content digest. The *only* `sha256(content)` label in the tree is the out-of-band `seed-clip.ts` fixture seeder, not the publish cap.
- **Live production proof (2026-09-04, `minion.town/mcp`, `CLIP_SITES_LIVE=1`, `minion-mcp-test-cc`):** three `publish` calls with **byte-identical `front`** (sha256 `34842a65…`, confirmed by served `ETag`) — including one **identical in both `front` and `back`** — received **three distinct origins** (`h65ahbqp…`, `2k4stwlo…`, `nuhordpn…`), each serving only its own content under the full isolation floor. `upgrade` correctly returns not-yet-supported on live; `unpublish` is owner-gated. This **closes the "not proven live" identity caveat** in `clip-ocap-synthesis.md` § 9 (amended with a pointer to the transcript).
- The misleading "content-addressed" framing is corrected (storage-addressing vs. site-identity are two layers). The CLIPOMETER primer clip is **flagged back** for re-publish (live `upgrade` is disabled; its hash isn't held by this job).

**Part B — content-store GC: confirmed gap, full design.** The CAS is strictly write-once with no delete; `unpublish` drops only the vhost index record, orphaning blobs/manifests/guest-directories forever (this job's own Part-A test just stranded three). Designed a **mark-and-sweep GC** over the fs CAS: liveness roots = `vhosts/*.json` → `contentRoot` → manifest → `blobId`s; a lock-free **intern-mtime grace-window** interlock; dedup-safe by global marking; a **periodic systemd timer** (`deploy/aws/systemd/` shape); **audit-by-default** with an explicit `--delete` and a live dry-run validation plan against the real store; a fakes test plan (`test/*.test.ts`); and the guest-side half (drop the guest directory on unpublish) with its stated Endo-daemon-GC dependency.

**Scoping / follow-ups:**
- GC implementation is scoped to a follow-on **`build clip-content-store-gc`** (design § B.7), complete enough to implement without further clarification (deliverable #5). **I did not post that build job** — it's the maintainer's/liaison's call after design review.
- Residual (unchanged, out of scope): `@sites` durability across a daemon **restart** remains unproven live.
- The three test clips were unpublished (good citizen), which itself exercised — and demonstrated — the GC gap on production.

Design PR is draft (standard fork-side discipline); the watched-fork triager/panel draws review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-formula-id-origin-gc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 84 tokens (3705840 cached reads)
- Output: 38172 tokens
- Cost: $4.2690367500000015
- Wall-clock: 913s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
