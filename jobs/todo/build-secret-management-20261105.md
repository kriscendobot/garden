---
role: builder
tier: mentor
posted_at: 2026-11-05T09:37:16Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-05T09:51:31Z cleared=none -->

---
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Build the file-based secret management as designed** by the preceding design job (`designs/secret-management.md` on `main2`; read it and implement exactly what it specifies, smallest increment first; maintainer, kriskowal, 2026-11-05). Expected: the secrets directory and its container mount in the `garden` launcher (no container recreation needed for later key changes; note the one-time recreation this migration itself needs and say so), the placement tools with tests, the service wrappers and the `outbound/<service>/` ledger, the per-job env injection for harness CLIs, the capability probe so `requires: typesafe` is satisfied from the file, the migration/import command with the env-forwarding fallback, docs under `context/operations/`, and the CLAUDE.md pointer. NEVER read, print, log or commit a real secret value; tests use fake keys. Do not place or rotate any real key; the maintainer does that by hand. Run the relevant script tests and shellcheck before pushing. If the design left a blocking open question, build the unblocked part and report the rest.

