---
ts: 2026-06-03T04:31:50Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--bc8cef
short_id: bc8cef
prs:
  - { repo: endojs/endo-but-for-bots, pr: 410, role: sibling }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/410
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway Feature 10 distribution recipes (sibling to #410)

Sibling PR (NOT stacked) to PR #410. Base
`design/gateway-package-phase-10` so the recipes see the
full stack content; branch name e.g. `feat/endo-gateway-dist`.

Feature 10 (OS packaging) recipes that #410 did NOT cover:
- Debian `.deb` packaging.
- RPM `.rpm` packaging.
- Arch PKGBUILD.
- Dockerfile (production image).
- Homebrew formula.
- Service-user `endo:endo` provisioning notes in each recipe.

Each recipe references #410's systemd unit and launchd plist.
Document the install workflow per packaging system.
