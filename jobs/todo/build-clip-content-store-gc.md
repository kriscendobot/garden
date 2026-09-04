---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town @ main. Design `designs/clip-formula-id-origin-and-content-gc.md` (commit ced1aef) landed with Part A closed as a live-verified finding (no code change) and Part B fully scoped as a follow-on build named in the doc itself: `build clip-content-store-gc` (§ B.7).

Implement the content-store garbage collector per that design:
- Mark-and-sweep over the fs CAS (§ B.3), fail-closed on unreadable/unparseable/unresolvable roots, with one retry on a torn `vhosts/*.json` read before aborting.
- `internBlob` utimes-bump on dedup hit + immediate pre-unlink re-stat to protect blobs within the `GRACE` window (§ B.4); `.condemned/` quarantine variant noted as the stronger-safety option.
- Default-safe audit mode (no mutation), `--delete`/`--remove` as the sole explicit opt-in, `--drop-unresolved <recordId>...` as the audited manual escape hatch, gated under `--delete` and inert in audit mode (§ B.6).
- Periodic systemd timer running audit by default; promotion to reclaim via an explicit `GATEWAY_GC_DELETE=1` EnvironmentFile edit, never a hidden default (§ B.5/§ B.7).
- Daemon-side footprint: on `unpublish`, drop the guest's own `clip-<n>-<rand>` directory entry so the formula becomes unreferenced for Endo's own GC (§ B.8).
- Fakes-based test suite per house conventions (`test/*.test.ts`, § B.9) green in CI.
- Full acceptance criteria enumerated at the end of the design; audit-mode production validation against the real accumulated store recorded before the first `--delete` run.
