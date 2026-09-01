---
tier: mentor
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-01T23:07:13Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Follow-up to `design-openrouter-provider` (`designs/openrouter-provider.md`,
commit `9790c4f4db`), which left two maintainer decisions as open questions.
The maintainer (kriskowal) has now answered both — this job builds what they
authorized, not a re-ask.

## Decision 1 — reject logging/training-use by default (answers Open question 1)

The garden's default OpenRouter posture is: **no prompt/response logging, no
training on inputs.** Enforce this as a real, code-auditable constraint, not
an account-page setting someone could forget or reset:

- Investigate OpenRouter's actual current mechanism for this — most likely a
  per-request `provider: { data_collection: "deny" }` field (routes only to
  zero-data-retention-capable providers, whatever they don't serve is simply
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
  Determine empirically (status-only probe, no key exists yet so this may
  need to wait for §3 below, or can be reasoned from OpenRouter's docs) and
  either (a) drop the two named-free rows and replace with providers that
  demonstrably support zero retention even on `:free`, if any exist, or (b)
  document plainly that under this policy the free lane is currently empty
  and the garden's OpenRouter reach starts at zero usable named models until
  a compliant one is found or a paid ZDR-capable route is reviewed and
  authorized separately. Do not silently keep a non-compliant row enabled.
- Update `designs/openrouter-provider.md` § Open questions (mark question 1
  Resolved: with the decision and what it costs) and
  `context/operations/openrouter.md` to state the enforced policy plainly
  and reflect the reviewed row set.

## Decision 2 — admit stealth/cloaked models via a second kind (answers Open question 2)

The maintainer wants to use OpenRouter's rotating cloaked "stealth" models
(e.g. `openrouter/stealth/ox-alpha`-shaped ids) *while cloaked*, accepting
the design's stated risk (undisclosed provenance, no reviewed stable id).
Build the design's already-sketched policy (b):

- A second kind, `openrouter-promo` (or a better name if one occurs to
  you — say why if you rename it), same handler/provider, same
  explicit-model-only fencing as `openrouter`, but with its OWN registry
  namespace so its arms never pool with the stable named lane's
  (`opencode-alternate-harness.md`'s option-C reasoning applies again here:
  a distinct kind keeps distinct risk profiles distinctly scored).
- A **short mandatory re-review cadence** for whatever cloaked ids are
  enabled (the design flagged this as required but undesigned) — pick a
  concrete cadence (daily is a reasonable default for something that can
  vanish or silently become a different model at any time) and a mechanism
  to enforce it: a scheduled check (skill: [schedule]) that re-probes each
  enabled stealth id's `/models` listing and a live tool-using canary, and
  **automatically disables** (not just warns about) an id that 404s or that
  the maintainer has not re-attested within the cadence window.
- A documented **rip-cord**: how to immediately zero the pool and drop a
  specific stealth id's row (`set-openrouter-promos.sh 0` plus removing its
  inventory row) — mirror the shape of `set-openrouters.sh`.
- This lane inherits the deny-logging/deny-training constraint from Decision
  1 unconditionally, same as the stable lane — "we accept not knowing which
  model this is" is a different risk than "we accept our prompts being
  logged", and the maintainer has only authorized the former.

## Decision 2b — reputation continuity on unmask (net-new, not in the prior design)

When a stealth id's identity is later revealed (OpenRouter publishes what it
was, or the maintainer otherwise learns it), the garden should be able to
**carry the accumulated reputation forward** onto the now-named model's
arm(s) rather than discarding it and starting that model at zero history.
This is genuinely new — the prior design didn't address it. Design and build
a maintainer-triggered (never automatic — an unmask is an external fact only
a human confirms) reputation-arm migration:

- Read `reputation.sh` / the reducer (`reputation-reduce.sh`, described
  elsewhere as the sole writer of arm projections) before proposing a
  mechanism — the migration must go through whatever the reducer considers
  its single source of truth, not hand-edit a projection file.
- Shape: an operator script, `rerecord-reputation-arm.sh <old-arm-key>
  <new-arm-key> --authorized-by <maintainer>` (or fold into an existing
  attested-op pattern if one already fits better — the sysop's
  `authorized_by:` attestation gate on destructive ops is the precedent to
  follow for who may trigger this and how it's recorded) that relabels the
  stealth arm's history onto the real model's arm, idempotently, with a
  journal record of the migration (what was renamed, when, by whom) so it's
  auditable and never silently double-applied.
- If a full merge (combining history if the target arm already has some) is
  materially harder than a clean rename (target arm didn't exist before),
  it's fine to build the rename case now and leave merge-on-collision as an
  explicit open question rather than guessing at reducer semantics you
  haven't verified.

## Out of scope for this job

Actually supplying `OPENROUTER_API_KEY` or enabling any worker. The pool
(both `openrouter` and the new `openrouter-promo`) stays at zero. Container
recreation with the key is a separate, host-side, maintainer-run step
(cannot be done from inside a garden container — no docker socket there) —
the liaison is handling that directly with the maintainer, not asking this
job to do it.

## Precedents to read first

- `designs/openrouter-provider.md` (this job's predecessor) and
  `context/operations/openrouter.md`.
- `skills/schedule/SKILL.md` for the re-review cadence mechanism.
- `roles/sysop`/`designs/sysop.md` § attestation, as the precedent for a
  maintainer-attested, auditable, idempotent operator action.
