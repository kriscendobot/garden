---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-08-19T02:40:26Z
---
# wire-watcher review — kriscendobot/minion.town PR #48 (panel seat)

Dispatch: jury seat `wire-watcher`, gauntlet `build-minion-town-git-content-substrate-gauntlet`
(panel iteration 5).
Worktree reviewed: `scratch/project-wt-build-minion-town-git-content-substrate-gauntlet-panel-5-c5deec84`
(HEAD `5075ba4`, "fix(gateway): address panel round-4 must-fix items (§§4–6 serving plane)"),
base `origin/main`.

### wire-watcher

**Verdict:** approve

**Findings:**

None must-fix or should-fix. This round's diff (`content-source.ts`, `vhost-table.ts`,
`content-server.ts`, `content-store.ts`, `projector.ts`) is the wire-watcher's core
surface — CAS identifiers, a mutable-record CAS advance, and a serve-time byte splice
— and every recurring hazard in this seat's brief is already checked before trust,
tested, and cited in-line:

- **In-band-marker trust-bypass**: `advanceVhostContentRoot` (`vhost-table.ts:400-410`)
  refuses to convert an existing non-`mutable: true` record (a content-derived
  `weblet_publish` origin) into a mutable one — the exact "in-band marker flips a
  trust decision" shape this seat watches for — and it's covered by
  `test/gateway/content-source.test.ts:265` ("refuses to seize a content-derived
  (non-mutable) weblet_publish record").
- **Check-before-trust / read-fault handling**: `readVhostFile` distinguishes
  `absent` (ENOENT) from `unreadable` (EIO/EACCES/parse failure) and the CAS treats
  `unreadable` as a conflict, never a clean slate to overwrite (`vhost-table.ts:290-296`,
  tested at `content-source.test.ts:253`).
- **Parser divergence / prototype pollution**: `parseManifest` and `projectTree`
  both build `Object.create(null)` maps and reject a `__proto__` path segment at
  the boundary (`content-store.ts:200`, `projector.ts:144`), and `manifestEntry`
  uses `Object.hasOwn` rather than bracket lookup (`content-server.ts`), closing
  the `constructor`/`toString`/`__proto__` divergence class outright.
- **Failure-mode test catalog**: `sentinelOffsets` — the one genuinely novel wire
  object this PR introduces (a byte-offset list the server trusts to splice content)
  — is bounds-checked twice (against declared `entry.length` at parse time,
  against the actual buffer at splice time) and needle-verified before every
  splice (`content-server.ts` serveEntry), with malformed/negative/non-integer/
  out-of-bounds cases explicitly tested (`content-store.test.ts:104-119`) and a
  fast-check property test proving the offset-splice path is byte-identical to a
  direct re-qualify against the real root, including author text that coincidentally
  contains the literal sentinel string in a `<pre>`/`<script>`/comment
  (`projector.test.ts:397-448`).

**Notes (out of scope but worth flagging):**

- `qualifyUrl` (`projector.ts`) root-qualifies a source-authored href that is
  *already* `/.content/<hex>/...`-shaped (it isn't excluded as non-relative), so
  such a link projects to a doubled `/.content/<sentinel>/.content/<hex>/...`
  path. Not a trust-bypass — `normalizeSourcePath` still rejects any actual file
  published *at* a `.content/`-prefixed key, so this only ever produces a dead
  link inside another author's own HTML, never crosses an origin — but it's the
  one seam where the `isReservedFirstSegment` policy that's otherwise applied
  uniformly (source paths, manifest paths, request paths) is silently absent
  (URL-rewrite targets). Worth a comment or a defensive skip in `qualifyUrl`
  next round if this seat's overlap with the locksmith's namespace-collision
  axis is felt to matter here. [proposed-rule: `qualifyUrl` should treat a
  document-relative reference whose normalized path starts with a reserved
  first segment (`.content/`, `gateway/`, `.well-known/`) as non-qualifiable,
  the same way a `..`-escaping reference already is.]

Self-improvement: this round's authors already write to the wire-watcher's
lens directly in their own doc comments (e.g. content-store.ts:102-107 reasoning
through the `Object.freeze(Set)` non-immutability footgun unprompted). No brief
change proposed this round — the brief's inquiry axes matched the diff cleanly
and found nothing new to encode.
