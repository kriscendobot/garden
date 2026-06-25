---
ts: 2026-06-25T00:17:05Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--membertable-design.md
  - library/sources/cask--membership-next-steps.md
  - library/sources/cask--cluster-provisioning.md
---

# Scholar cask ingest cycle 12 (job `scholar-ingest-cask-11`)

Continued the `kriskowal/cask` `doc/design/` ingest with the **membership sub-cluster**, the first cycle of the blob/root/nursery/verbs/membership group flagged by cycle 11. All three target docs share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); idempotency-checked against `origin/journal2` (none previously ingested).

## Sources ingested (3 sources, 7 sections)

- **doc/design/membertable-design.md** → `cask--membertable-design` (2 sections):
  - `structure-and-operations` — the member table's session-table-shaped parallel arrays (swap-to-end allocator / keys / byKey hashtreetouint64 / trafficClasses) and Has/Add/AddWithTrafficClass/Remove/Get-SetTrafficClass/ForEach ops. Topics: networking, capability-security, content-addressed-storage, data-structures.
  - `cli-root-and-server-integration` — the `cask member add|rm|set-traffic-class|ls` CLI, the caskhead Root Block Extension (`Links[2]` membership link, ZeroHash when empty), Get/SetMembershipRoot, and the server's per-`ini6` Has() check returning `statusNotMember`. Topics: networking, capability-security, content-addressed-storage.
- **doc/design/membership-next-steps.md** → `cask--membership-next-steps` (3 sections):
  - `three-gate-access-model` — the invited-guest principle and the membership → session → capability gate order. Topics: capability-security, networking.
  - `membership-mvp-roadmap` — node_id identity, Option A/B proof, CASK_ROOT bootstrap, the CASK_MEMBERSHIP MVP, ini6/statusNotMember, the seven concrete steps. Topics: networking, capability-security.
  - `capability-gated-read-write` — gate 3 (deferred to CELLS.md): a session is transport only; each LOAD/STOR needs a cap_token scoped to the target cell. Topics: capability-security, networking.
- **doc/design/cluster-provisioning.md** → `cask--cluster-provisioning` (2 sections):
  - `problem-and-prior-ssh-approach` — the five join steps; the abandoned `cask ssh provision` SSH prototype and its five limitations. Topics: networking.
  - `prerequisites-and-future-design` — address discovery / membership propagation / binary distribution / health-and-liveness; the manual-key-exchange future sketch; open questions. Topics: networking.

## Concepts

- **New** `cask-three-gate-access` — the membership/session/capability layered access model (introduced by membership-next-steps).
- **New** `cask-cluster-provisioning` — the deferred online-cluster formation design (introduced by cluster-provisioning).
- **Updated** `member-table-authorization` — added 3 section rows (the two membertable-design sections + membership-mvp-roadmap), ~14 new aliases (node_id, cask member *, trafficClasses, GetMembershipRoot, statusNotMember, etc.), and 4 See-also links.
- **Updated** `cask-caskhead-root` — added the membertable cli-root section row (the Root Block Extension that gives `Links[2]`).

## Indexes updated

- `topics/networking.md` (+7 rows), `topics/capability-security.md` (+5), `topics/content-addressed-storage.md` (+2), `topics/data-structures.md` (+1).
- `topics/README.md` counts: networking 29→36, capability-security 174→179, content-addressed-storage 63→65, data-structures 51→52; networking/content-addressed-storage/data-structures abstracts extended to name the membership material.
- `sources/README.md` (+3 cask rows), `concepts/README.md` (+2 new concept rows), `keywords.md` (+41 lines).

## Corpus state after this cycle

cask: 32 sources / 140 sections.

## Deferred (follow-on `scholar-ingest-cask-12` posted)

The rest of the blob/root/nursery/verbs cluster and the meta + comment-fragment sources remain. A follow-on job names exactly what is left.

Self-improvement: nothing this time. The cycle-11 working note (isolated worktree off `origin/journal2`, CAS-push loop, idempotency via `git show origin/journal2`) carried over cleanly; no new structural friction worth a self-improvement missive.
