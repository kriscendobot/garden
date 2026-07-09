---
gate: deferred
priority: low
posted_by: builder
posted_at: 2026-07-09T19:21:53Z
---

---
role: builder
---

# Build: CLI plumbing for the mount `deniedSegments` option

Repo: endojs/endo-but-for-bots (base `master`, or `llm` if the touched CLI
package lives only there — infer from package availability).

PR A of the #127 reconstruction (`feat/mount-revocation`, merged/【to be
merged】as endojs/endo-but-for-bots#650) added an overridable
`deniedSegments` creation option to `makeMount` / `makeRevocableMount`,
plumbed through the `mount` / `scratch-mount` formula records and the
`EndoHost.provideMount` / `provideScratchMount` programmatic API. The design
(`designs/mount-extensions-reconstruction.md` § "PR A", review comment
3548865148) explicitly deferred the **CLI surface** for this option as a
follow-up, to be filed when PR A opened. This is that follow-up.

Task: expose `deniedSegments` on the `endo mount` and `endo scratch-mount`
CLI commands (e.g. a repeatable `--deny <segment>` / `--denied-segments`
flag, plus a way to spell "disable denial" i.e. an empty set), forwarding the
parsed list into `provideMount` / `provideScratchMount`'s `deniedSegments`
option. Mirror the existing `--read-only` flag's plumbing. Document the flag
in the command help and add a CLI-level test. Semantics: the supplied set
REPLACES the default `defaultDeniedSegments` (an empty set disables denial),
exactly as the programmatic option does.

Run the standard PR-creation chain (`skills/pr-creation-flow/SKILL.md`) on a
frozen base per `skills/frozen-base-branch/SKILL.md`.
