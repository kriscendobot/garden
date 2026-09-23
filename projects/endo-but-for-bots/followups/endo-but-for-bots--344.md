---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 344
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 3047
created_at: 2026-05-21T07:30:00Z
last_appended_at: 2026-05-21T07:30:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#344

Created from the docs-populate panel verdict (12 seats: archivist, scribe, stylist, typist, purist, spec-keeper, surfacer, pruner, copyeditor, changeset-auditor, corner-prober, packager; in-band fallback) on the 28-README-populate mirror PR. The PR is 28 markdown files plus 1 one-line JS readability tweak (`999999999` -> `999_999_999` in netstring/reader.js) plus a 7-line CONTRIBUTING.md addition introducing the unabbreviated-names guideline. Three follow-ups warrant revisit at merge time.

## Items

- [ ] **`packages/netstring/index.js` legacy aliases (`netstringReader`, `netstringWriter`) are exported but undocumented in the new README.**
  **Source juror(s)**: surfacer.
  **Round**: 1.
  **Recommended action**: when this PR merges (or upstream mirror endojs/endo#3047 merges), either document the legacy aliases as deprecated in `packages/netstring/README.md`, or remove them from `packages/netstring/index.js` if downstream callers have migrated. Silent presence of an undocumented export is the worst form; either deprecation note or removal is acceptable. File as a follow-up PR or as an issue against endojs/endo.

- [ ] **`packages/cli/README.md` does not reference `endo --help` for the full command set.**
  **Source juror(s)**: spec-keeper, corner-prober.
  **Round**: 1.
  **Recommended action**: the README documents a useful subset of commands (start/stop/run/make/list/store/eval/mkhost/mkguest/send/inbox/spawn/bundle/where) but omits `endo install`, `endo open`, `endo follow`, `endo invite`, `endo accept`, `endo cancel`. The omission is plausibly deliberate (focused on common workflows), but a one-line "See `endo --help` for the full command set" pointer would help. File as a small follow-up doc PR or as a one-line addition to `packages/cli/README.md` at the bottom of the workflow sections.

- [ ] **`packages/cli/README.md` does not document daemon-not-running error messages or recovery paths.**
  **Source juror(s)**: corner-prober.
  **Round**: 1.
  **Recommended action**: the most common new-user confusion with a daemon-backed CLI is invoking a command while the daemon is stopped. The README could carry a one-line "If commands report no daemon, run `endo start` first." in the Daemon Lifecycle section. File as a small follow-up doc PR.
