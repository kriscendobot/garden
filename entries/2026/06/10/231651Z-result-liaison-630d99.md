---
ts: 2026-06-10T23:16:51Z
kind: result
role: liaison
dispatch: 630d99
host: endolin
model: opus-4-7-1m
---

# librarian cycle 284 — chat-lane — `@endo/zip/src/reader.js`

Cycle 284 (chat-lane after cycle 283 designs-lane endo-gateway). One source ingested: `@endo/zip/src/reader.js` (60 lines; the smallest of the three zip cluster source files ingested so far). **Closes the zip cluster source-file loop**: cycle 280 writer + cycle 282 types + cycle 284 reader — three sibling files producing, declaring, and consuming the same typedef set.

## Library state

- 790 sections (up from 789 at cycle 283).
- 331 source documents (up from 330).
- §one-hundred-and-seventeenth consecutive designs-chat alternation cycles 166-250 + 252-284 (251 was out-of-band).

## Files written

- `library/sections/endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop.md` (new section file; 60-line file in full scope).
- `library/sources/endo--packages-zip-src-reader-js.md` (new source page).
- `library/sections/README.md` (Total 789 → 790; sources 330 → 331; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 14 first-explicit-observations + new counter row `library-reaches-790-sections at cycle 284` + `one-hundred-and-seventeenth consecutive designs-chat alternation`).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-283` → `pending-cycle-284`).

## First-explicit-observations (fourteen)

1. **§reader-writer-symmetric-pair-shape** — class + async-adapter-factory in each, with asymmetric line counts (264 writer vs 60 reader).
2. **§three-cycles-closing-the-zip-cluster-source-loop** — 280 writer + 282 types + 284 reader.
3. **§the-class-exposes-stat-but-the-async-adapter-only-exposes-read** — async-adapter deliberately narrows the public interface; `ArchiveReader` typedef names only `read`; `stat` is class-private convenience.
4. **§the-`@type`-inline-JSDoc-on-a-local-const-as-named-type-cast-shape** — `/** @type {import('./types.js').ReadFn} */ const read = async path => reader.read(path);`.
5. **§the-inline-`import('./types.js').X`-form-vs-`@import`-at-top form** — reader.js deviates from project CLAUDE.md preference; §two-import-style-shapes-in-one-cluster.
6. **§the-`<unknown>`-default-value-as-named-sentinel** — `name = '<unknown>'` with angle-bracket convention for placeholder.
7. **§the-`@ts-expect-error`-with-named-justification-in-comment** — `// @ts-expect-error missing properties from ArrayBuffer`.
8. **§the-`as`-rename-import-pattern** — `readZip as readZipFormat`; `Format` suffix names the narrower format-level shape.
9. **§the-`location`-vs-`name`-parameter-naming-drift** — outer API uses domain term, inner class uses generic term; named-rename-at-the-API-boundary.
10. **§the-error-message-naming-both-names** — `Cannot find file ${name} in Zip file ${this.name}`.
11. **§two-named-Map-lookup-then-act-shapes** — read throws on missing, stat returns undefined; the-presence-check-IS-the-API-branch.
12. **§the-stat-shape-projecting-onto-typedef** — explicit four-field projection onto `ArchivedStat`; the-projection-IS-the-conformance-act.
13. **§the-content-field-is-deliberately-not-in-stat** — extends §confinement-by-omission from security (cycle 259) to API-design (cycle 284); §four-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 284).
14. **§the-Map-lookup-IS-the-shared-mechanism** — the class IS essentially a named Map with an archive label.

## Multi-cycle pattern recognition

- **§seven-cycles-with-closing-an-importer-and-producer-loop** — 263+273 fragment-references-the-referenced-doc + 268+270 constructor-validator-pair + 280+282 consumer-producer-pair + 280+282+284 three-file-cluster.
- **§four-cycles-with-explicit-confinement-by-omission** — 234 path-restrictions + 238 origin-allowlist + 259 Page-three-named-non-exposures + 284 stat-content-omission (first cycle in API-design domain rather than security domain).
- **§four-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster** — 278 signature + 280 writer + 282 types + 284 reader.
- **§two-cycles-with-import-rename-to-avoid-collision-with-export in same cluster** — 280 writer + 284 reader.
- **§two-named-JSDoc-optional-markers** — `Date?` postfix-question-mark (cycle 282) + `T=` postfix-equals (cycle 284).

## Synthesis target

Slot machine library `@game/replay/src/reader.js`: a `ReplayReader` sync class wrapping a Map of player-action-records + a `readReplay` async-adapter that narrows to `{ read }` for the recorded-game-event consumer; constructor takes `(data, options)` where `options.name` defaults to `'<unknown>'`; `read(eventName)` throws on missing event with both-names error; `stat(eventName)` returns optional `EventStat=` (deliberately omits the event payload, only metadata); the async adapter type-annotates the read function with `/** @type {ReadFn} */` to bind to the typedef shape; `// @ts-check` on the file; both inline `import('./types.js').X` types (deviating from project preference for `@import`) and import rename to avoid collision with `format-reader.js`'s `readReplay`.

## Single most structurally interesting move

**§the-class-exposes-stat-but-the-async-adapter-only-exposes-read** — the async-adapter **deliberately narrows the public interface**. The `ArchiveReader` typedef (from cycle 282's types.js) names *only* `read`; `stat` is a sync convenience on the class but is NOT part of the cross-package contract. The factory enforces this narrowing by destructuring `{ read }` from the constructed reader at the return point, not by hiding the class entirely. This is **§the-typedef-IS-the-public-contract + the-class-IS-the-private-implementation**, with the factory at the boundary doing the narrowing.

## Next cycle

Cycle 285 — designs-lane next.
