---
role: builder
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-09T20:29:15Z -->

# Wire a Rust/XS-side mount glob (and grep) case-table runner

Repo: endojs/endo-but-for-bots. Named follow-up from
`designs/mount-extensions-reconstruction.md` § "Test strategy", filed when
PR B (`feat/mount-glob`, #653) opened.

PR B landed the cross-language data contract in `packages/daemon/test/`:
- `mount-fixture-manifest.json` — declarative fixture tree (files, empty
  dirs, denied credential names, a binary probe, an optional escaping
  symlink).
- `_mount-fixture.js` — the Node-side materializer.
- `mount-glob-cases.json` — the glob variant coverage matrix
  (`{ name, pattern, expect, requiresSymlink? }`), where `expect` is the
  exact UTF-16-sorted result of `EndoMount.glob(pattern)`.

Task: wire a Rust/XS-supervisor-side runner into the Rust workspace that
(a) materializes `mount-fixture-manifest.json` into a temp tree (skipping
`optional` records the platform can't create), and (b) iterates
`mount-glob-cases.json` (and later `mount-grep-cases.json` from PR C),
asserting the XS-run `mount.js` produces byte-identical results to each
`expect`. This is the durable Rust/Node parity guard the review asked for;
until it exists, `mount-platform-fs-conformance.test.js` remains the only
guarantee the same `mount.js` runs under the Rust supervisor.

Notes:
- The `requiresSymlink: true` cases are skipped when the escaping symlink
  can't be created; mirror the Node runner's gate.
- Sorting is UTF-16 code-unit order (JS `Array.prototype.sort` default);
  the Rust side must mirror that exact collation, not a locale/byte order.
- Coordinate with PR C (grep) so the grep case table is picked up by the
  same runner rather than a second one.
