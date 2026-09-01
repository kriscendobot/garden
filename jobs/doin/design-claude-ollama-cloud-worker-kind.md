---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Add a new Anthropic-taxonomy worker kind that runs Claude Code against Ollama
Cloud (ollama.com), authenticated with a maintainer-supplied Ollama API key,
alongside the existing monk (real Anthropic API), cleric (OpenAI/Codex), and
hermit (local Ollama/Codex) kinds. Follow the established "adding a third
backend" recipe (common.sh:513-515, context/operations/local-inference-amd/
worker-backend.md). Concretely:

- Handler: extend handlers/monk-claude.sh to be provider-parameterized
  (mirroring cleric-codex.sh's existing provider=local branch): when the new
  provider is active, export ANTHROPIC_BASE_URL=https://ollama.com,
  ANTHROPIC_AUTH_TOKEN=$<new-secret-var>, ANTHROPIC_API_KEY= (cleared) before
  the existing claude -p invocation. No other line of that handler should
  need to change.
- Registry: new worker_kind_field() row -- handler handlers/monk-claude.sh
  (reused), agent_bin: claude, a new, distinct provider (not anthropic, not
  local -- see quota-throttle note below), a new unit/count_key/state_ns/
  label. Suggested kind name: friar (the exact placeholder name common.sh:513
  already uses as its example of "a third backend on a future CLI").
  Not load-bearing -- confirm no collision, can pick differently.
- Model/tier map: new rows in model-tier-inventory.tsv and
  model-routing-defaults.tsv for whichever Ollama Cloud model tag(s) are
  onboarded first, at a tier matched to measured capability -- mirroring the
  existing "local qwen3.6 minion" row. Verify current Ollama Cloud
  catalog/pricing at design time, not from this brief.
- Secrets: add the new API-key env var to the allowlist in
  scripts/systemd/seed-api-key-handoff.sh (currently ANTHROPIC_API_KEY
  MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY only), same
  base64url-charset validation, AND to the matching `-e` forwarding list and
  usage-doc lines in the `garden` launcher script itself (garden:82-85,
  254-264) -- both files are baked into the image via COPY / the deploy
  build-contract hash, so this change needs a rebuild before the new
  variable name is recognized; the key's VALUE never enters the image or the
  repo at any point, only the host-exported env var at container-start time.
  Pick a name that can't collide with the pre-existing, non-secret,
  ignored-by-Ollama OLLAMA_API_KEY convention already used by hermit/codex's
  local config -- e.g. OLLAMA_CLOUD_API_KEY.
- Rate card / quota: this is a paid, metered, external surface, unlike
  hermit's free local compute -- needs its own reputation/rate-card.md
  provider row (not pooled with anthropic or local), and must NOT inherit
  the local-provider quota-throttle exclusion in designs/quota-throttle.md
  ("Ollama (hermit, provider: local) -- explicit non-goal"), which is
  explicitly premised on local compute never emitting a cap signature.
  Ollama Cloud will emit real rate-limit/quota errors against the
  maintainer's key, so the new provider needs its own throttle
  classification, sized like mystic (moonshot) or fireworker's
  "manually-funded arm routed to a human," not like hermit.
- Verification / risk to smoke-test before trusting the fleet on it: Ollama
  Cloud's /v1/messages wants Authorization: Bearer (ANTHROPIC_AUTH_TOKEN),
  not x-api-key -- confirm this works end to end, not just locally. Confirm
  Claude Code doesn't hard-fail when it hits an unsupported endpoint
  (count-tokens is the known risk -- see live Ollama GitHub issue). Confirm
  usage/cost accounting (usage_capture_result in monk-claude.sh) degrades
  sensibly given Ollama's token counts are approximate and prompt caching
  isn't supported.

Open questions for the design doc's own "Open questions" section: final
kind/provider names; which Cloud model(s) to onboard first and at what tier;
initial pool sizing (friars: N) and which host(s) run it; whether this needs
maintainer attestation to arm (like the local-model sysop op) given it's a
new paid external surface.

## Status update from the liaison (2026-09-01, after hand-off.md was posted)

The maintainer has obtained an Ollama Cloud API key (held locally, never
typed into a chat session or committed) — this job's precondition from
`hand-off.md` is satisfied and it's safe to proceed with implementation, not
just the design doc. The maintainer already understands the key threads in
via the existing host-env-var → `garden -e` forwarding → `seed-api-key-
handoff.sh` bridge (like `ANTHROPIC_API_KEY` today), not via the Dockerfile,
and that landing the `garden`/`seed-api-key-handoff.sh` changes above
requires an image rebuild before the new variable name is recognized — the
key's value itself never needs to enter the image or the repo. `hand-off.md`
also suggests the maintainer run `ollama launch claude` locally (Ollama's own
quick-start) as an independent sanity check of the key/Cloud access; that's
outside this job's scope and not something to wait on before designing.

Source: `hand-off.md`, a research hand-off written on the bare host (not
inside the container, so it never touched the journal) mapping every harness
the fleet could run against every inference provider. Read it in full if
still present in the garden root for the wider harness x provider survey
this design sits inside of; its content is otherwise preserved in this job's
sibling postings (`update-provider-model-catalog-matrix`,
`probe-opencode-anthropic`) and this session's transcript.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
<!-- garden-provider-quota-backoff: type=session reset-at=2026-09-01T22:50:00Z -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-01T21:08:56Z
