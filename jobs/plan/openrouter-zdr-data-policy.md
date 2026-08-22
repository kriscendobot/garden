---
gate: orchestrated
orchestrated_by: openrouter-zdr-and-stealth-orchestration
priority: normal
role: builder
posted_by: producer
posted_at: 2026-08-22T08:15:35Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Child 1 of 3 in the `openrouter-zdr-and-stealth-orchestration` orchestration.
Splits out Decision 1 from the doomed monolithic job
`openrouter-zdr-policy-and-stealth-lane` (deadline-overrun after 40 min
handler wall-clock — see `jobs/plan/openrouter-zdr-policy-and-stealth-lane.md`,
doomed 2026-08-22T08:13:03Z; that record is superseded by this
decomposition, do not resurrect it). Builds on `design-openrouter-provider`
(`designs/openrouter-provider.md`, commit `9790c4f4db`).

## The maintainer's decision (answers Open question 1)

The garden's default OpenRouter posture is: **no prompt/response logging, no
training on inputs.** Enforce this as a real, code-auditable constraint, not
an account-page setting someone could forget or reset:

- Investigate OpenRouter's actual current mechanism for this — most likely a
  per-request `provider: { data_collection: "deny" }` field (routes only to
  zero-data-retention-capable providers; whatever they don't serve is simply
  excluded from routing) alongside/instead of the account-level privacy
  toggle at openrouter.ai/settings/privacy. Confirm current behavior against
  OpenRouter's own docs rather than assuming; this is a request I have not
  verified against a live account.
- Wire the `openrouter`/`cleric-codex.sh` `$custom_openai_compat` request
  path to send that deny-collection constraint on **every** OpenRouter
  request, unconditionally — not opt-in per job, not toggleable by a job
  body. This is a fleet posture, not a per-request choice.
- **Re-review the two seed inventory rows against this constraint.** The
  design doc already noted free `:free` variants commonly *require*
  logging/training to be enabled as the price of the free tier — if that's
  still true, a deny-collection request to those ids may simply return no
  eligible provider (empty routing) rather than an error, or may 404/402.
  Determine empirically if possible (no key exists yet in the worktree, so
  this may need to be reasoned from OpenRouter's own docs instead of a live
  probe) and either (a) drop the two named-free rows and replace with
  providers that demonstrably support zero retention even on `:free`, if any
  exist, or (b) document plainly that under this policy the free lane is
  currently empty and the garden's OpenRouter reach starts at zero usable
  named models until a compliant one is found or a paid ZDR-capable route is
  reviewed and authorized separately. Do not silently keep a non-compliant
  row enabled.
- Update `designs/openrouter-provider.md` § Open questions (mark question 1
  **Resolved:** with the decision and what it costs) and
  `context/operations/openrouter.md` to state the enforced policy plainly
  and reflect the reviewed row set.

## Out of scope for this job

The stealth/promotional `openrouter-promo` kind (that's the next child,
`openrouter-stealth-lane`, which depends on this one landing first — it
inherits this deny-collection enforcement unconditionally) and the
reputation-arm-migration tooling (`openrouter-reputation-unmask-migration`,
the third child). Also out of scope: actually supplying
`OPENROUTER_API_KEY` or enabling any worker — the `openrouter` pool stays at
zero. Container recreation with the key is a separate, host-side,
maintainer-run step the liaison is handling directly, not this job.

## Precedents to read first

- `designs/openrouter-provider.md` and `context/operations/openrouter.md`.
- `jobs/plan/openrouter-zdr-policy-and-stealth-lane.md` (the doomed original,
  for full context on all three decisions — but only Decision 1 is this
  job's scope).
