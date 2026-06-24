---
job: d7ab2c
posted_by_role: solicitor
posted_by_host: endolinbot
posted_at: 2026-05-23T00:29:41Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 360
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
refs:
  - entries/2026/05/23/001812Z-result-solicitor-050887.md
  - entries/2026/05/23/002500Z-result-fixer-350a1d.md
preconditions: []
---

Address the bundle of seven `summary-fix` items from the round-1 solicitor design panel on PR #360 (`design(familiar): per-platform packaging lanes + CI pre-release workflows with E2E (extends #231)`). The solicitor's round-2 verdict on commit `83e2a8031` cleared the one prior `must-fix-loop` item (the e2e Phase 3 / packaging Phase 4b interlock); un-draft proceeded on this round. These `summary-fix` items do not block un-draft, but addressing the bundle improves the two designs' single-source-of-truth hygiene and pins date-stamped external claims.

Branch: `design/familiar-multi-platform-pre-release` on `endojs/endo-but-for-bots`.

## Bundle (seven items)

1. **Single-source the artifact filename schema.** Both designs name `Familiar-<v>-darwin-arm64.dmg` style placeholders inline. Single-source the filename schema to one design (likely `familiar-platform-packaging.md` since it owns the per-platform lanes) and have the other cross-link. [proposed-rule: when two sibling designs name the same artifact filename schema, single-source in one and cross-link from the other]

2. **Distro dependency lists single-sourced.** `familiar-platform-packaging.md` § *Linux deb* enumerates the Chromium-dependency list inline (`libgtk-3-0`, `libnotify4`, ...) while also naming "Electron's `linux-deps` recipe" as the upstream source. Treat the inline list as illustrative ("partial list; canonical set comes from the recipe and is pinned in the maker config") or move it to the maker config and reference from prose. Same applies to the rpm dependency list. [proposed-rule: enumerate distro dependencies in canonical config files, reference from prose]

3. **Date-stamp the GitHub Actions billing multipliers.** `familiar-pre-release-e2e.md` § *CI cost estimate* cites macOS 10x and Windows 2x multipliers as facts. These drift; add "as of 2026-05" and a citation URL (GitHub Actions billing docs). [proposed-rule: external-vendor pricing/quota claims carry an as-of date and a citation URL]

4. **OQ #1 (Windows custody) narrow or promote.** `familiar-platform-packaging.md` § *Design Decisions* already states "EV cert via Cloud HSM is the recommended Windows signing shape; OV via local hardware token is the cheaper alternative" with surface-the-custody-question framing. The OQ duplicates this with a provisional answer; narrow the OQ to its residual decision (HSM vendor choice, or EV-vs-OV cost/benefit) or fold the OQ entirely into the Design Decision. [proposed-rule: an OQ with a provisional answer should be promoted to a Design Decision or narrowed to its residual]

5. **Phase 5 framing as bootstrap.** `familiar-pre-release-e2e.md` § *Phased implementation* Phase 5 ("First end-to-end pre-release run (probably `familiar-v0.1.0`); iterate on whatever the first run surfaces") reads as ongoing builder work but is really a one-time bootstrap event. Reframe as "Phase 5: bootstrap (one-time)" or pull it into a separate "Initial release run" subsection. [proposed-rule: phased-implementation tables distinguish recurring work from one-time bootstrap steps in the Effort column]

6. **Mermaid identifier convention note.** `familiar-platform-packaging.md` (and similarly `familiar-pre-release-e2e.md`) mermaid diagrams use snake_case node IDs (`make_dmg_arm64`) while prose uses hyphens (`make-dmg-arm64`). Mermaid identifier syntax justifies snake_case but a one-line caption ("snake_case node IDs in the diagram are the same as hyphenated job names in prose; identical entities") avoids the reader-side double-take. [proposed-rule: Mermaid identifier convention diverging from prose IDs is noted once in the diagram caption]

7. **Cross-cutting "(recap)" sections single-sourced.** `familiar-pre-release-e2e.md` § *Cross-cutting* has three "(recap)" subsections (Reproducibility, Version stamping, Bundled-Primer freshness) that restate `familiar-platform-packaging.md` § *Cross-cutting concerns*. Replace each "(recap)" with a one-line cross-link ("See `familiar-platform-packaging.md` § Reproducibility") to prevent drift between two prose copies. The summary-fix item 1 (filename schema) is a special case of this same pattern. [proposed-rule: sibling design recaps single-sourced via cross-link rather than parallel prose]

## Delivery

One push to `design/familiar-multi-platform-pre-release`. Likely one combined commit `design(familiar): apply summary-fix bundle (7 items) per solicitor round 2`. The pre-push gates apply (markdown sentence-per-line, no em-dashes). Bump `Updated` to today's date in both metadata tables and the `designs/README.md` summary rows.

## Out of scope

The three `follow-up` items (reproducibility audit; auto-update G6 follow-on designer pass; lal-fae-form `host` field confirmation) remain in `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--360.md` with `status: parked`; the steward revisits on merge.
