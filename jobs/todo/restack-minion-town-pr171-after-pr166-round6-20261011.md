---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-11T08:11:08Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
<!-- garden-job: minion-town-ui-gutter-clip-labels -->
Gutter increment 1 of arc `minion-town-ui` ([plan](https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md)); design of record `designs/clip-shell-framework.md`.

## What changes

- **Name source.** Publishing records no name for a site, so the name is the `<title>` of the clip's front `index.html`. New `src/endo/gateway/clip-title.ts` resolves the front (legacy `contentRoot`, or the directory's `front` through `@sites`, via the daemon directory source on the live path), reads the manifest, and scans the first 16 KiB of `index.html` (`text/html` only).
- **Treated as untrusted.** The title is entity-decoded, then stripped of C0/C1 controls, zero-width and bidi-override characters, whitespace-collapsed, and capped at 64 code points. Any failure, or a lookup slower than 1.5 s, gives no name; the listing never fails because of a name.
- **`GET /account/clips`** carries an optional `name` field, re-sanitized at the endpoint and omitted when unusable. MCP `listSites` gains the same optional field.
- **Shell.** `clipRecordsFromListing` validates `name` again (`clipName`) and falls back to "Clip N". The gutter writes it only through `textContent` and attribute values (a source-text test guards against an `innerHTML` sink). The inert card already HTML-escapes it in an empty-sandbox `srcdoc`.
- **Icons.** A name that starts with an emoji ("🌵 Cactus") supplies the icon. Otherwise the icon is chosen from the id, so a clip keeps its icon when other clips are added or removed (it used to rotate by position).
- **`serving: false`** renders dimmed (opacity, grayscale, dotted border), with "(not being served)" in the tooltip and accessible name. The clip stays selectable; its card already says it is not served.

## Tests

`test/gateway/clip-title.test.ts` (new), plus additions to `test/gateway/publish.test.ts`, `test/guest-self-endpoint.test.ts`, and `test/shell-clip.test.ts`. `npm run typecheck` is clean. Locally, `npm test` passes except `test/git-remote/capability.test.ts > propagates a git failure…`, which this diff does not touch. It fails in the garden scratch checkout because of the environment and is not caused by this change.

## Notes

- On the live path, listing does one extra `@sites` directory read per clip, in parallel and bounded by the timeout. It uses its own lazily opened daemon connection (`makeDaemonSiteDirectorySource`).
- The name is author-chosen, not owner-chosen: a clip shows whatever its page calls itself. A guest-assigned pet name would need publish to record one, which it does not today.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
