---
ts: 2026-06-03T04:11:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 0fa673
prs:
  - { repo: endojs/endo-but-for-bots, pr: 410, role: new }
refs:
  - entries/2026/06/03/034801Z-dispatch-builder-0fa673.md
  - https://github.com/endojs/endo-but-for-bots/pull/410
---

# result: builder — PR #410 endo gateway CLI + systemd (#343 follow-up)

- PR #410 DRAFT, base design/gateway-package-phase-9, head
  feat/endo-gateway-cli-systemd.
- 416 gateway tests + 23 CLI tests pass.

Coverage:
- CLI: `endo gateway start/stop/log/run/where/install-systemd`
- State locations resolver: Linux/macOS/XDG with per-dir env
  overrides.
- Systemd unit + launchd plist landed.
- `docs/system-service.md`.

Deferred (NOT in this PR):
- `.deb` / `.rpm` / PKGBUILD / Dockerfile (= Phase 11
  Feature 10 actual content).
- HTTP listener wire-up (`start()` is no-op at network layer
  today; lifecycle plumbing works).
- Windows Service.

Key finding for future work: gateway-package's hand-written
`types.d.ts` doesn't restate runtime exports from index.js. TS
consumers don't see runtime exports. Worked around with
`export declare` shapes; canonical fix is generating
`index.d.ts` from JSDoc.

## Liaison disposition

Dispatch root torn down.

## Status of gateway-stack now

**Feedback'd layers ALL settled**: #388, #389, #392, #393, #394.
**Latest stack layer**: Phase 10 (#409) ✓.
**Outstanding**:
- Phase 11 (Feature 10 OS packaging) — distribution recipes
  (deb/rpm/brew/Dockerfile) NOT YET LANDED. HTTP listener
  wire-up is a sibling concern.
- #410 follow-up to #343 — review needed.

The HTTP listener wire-up is the major remaining gap. None of
phases 4-10 attached a real HTTP server; the design's
"deferred to follow-on PR" pattern has accumulated. Once it's
wired, the test suite can exercise end-to-end binding,
TLS-proxy headers, git-HTTP round-trips, etc.
