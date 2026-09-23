The follow-on `scholar-ingest-cask-12` has already been claimed by another gardener (now in `doin/`) — the board is working. Everything is complete.

## Completion report

**Job `scholar-ingest-cask-11` (cask `doc/design/` ingest, cycle 12) — done.**

Ingested the **membership sub-cluster** of `kriskowal/cask`, all at file-commit `cdb975d8` (idempotency-checked against `origin/journal2`; none previously ingested).

**Sources ingested — 3 sources / 7 sections:**
- `cask--membertable-design` (2): `structure-and-operations` (session-table-shaped parallel arrays: swap-to-end allocator / keys / byKey hashtreetouint64 / trafficClasses; Has/Add/Remove/traffic-class ops) and `cli-root-and-server-integration` (`cask member` CLI, caskhead `Links[2]` membership link, Get/SetMembershipRoot, per-`ini6` Has() gate → `statusNotMember`).
- `cask--membership-next-steps` (3): `three-gate-access-model`, `membership-mvp-roadmap`, `capability-gated-read-write`.
- `cask--cluster-provisioning` (2): `problem-and-prior-ssh-approach`, `prerequisites-and-future-design`.

**Concepts:** 2 new (`cask-three-gate-access`, `cask-cluster-provisioning`); 2 updated (`member-table-authorization` +3 section rows / ~14 aliases / +4 see-also; `cask-caskhead-root` +1 row).

**Indexes:** topics networking 29→36, capability-security 174→179, content-addressed-storage 63→65, data-structures 51→52 (rows + counts + abstract extensions); `sources/README` +3, `concepts/README` +2, `keywords.md` +41 lines.

**Corpus state:** cask now 32 sources / 140 sections.

**Verification:** all writes confirmed landed on `origin/journal2` (3 sources, 7 sections, 2 concepts present). The first push silently failed because a `git push | tail` pipeline masked the exit code; caught it by verifying `branch -r --contains`, then re-pushed checking the real `rc`. Job moved `doin → tada`; result entry at `journal/entries/2026/06/25/001705Z-result-scholar-c12a4f.md`. Scratch clone and isolated worktree cleaned up.

**Follow-up:** posted `scholar-ingest-cask-12` for the remaining blob/root/nursery/verbs cluster, the meta files (`status.md`/`style.md`/`todo.md`), and the comment-fragment sources — already claimed by another gardener.

Self-improvement: nothing this time (the cycle-11 working-note recipe carried over cleanly). One operational note worth flagging if it recurs: piping `git push` through `tail` in a CAS-retry loop hides the push exit code and can falsely report success — check `git push`'s own `$?`.
