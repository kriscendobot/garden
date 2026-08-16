#!/bin/bash
# worker-spine-kinds-test.sh — the factored worker spine, exercised for BOTH kinds.
#
# The gardener loop, the scaler, the set-count, and the systemd template are ONE
# spine parameterized by worker kind (gardener | cleric); a handler + a registry row
# is all a new backend adds (design §2, cleric-worker-bid-auction-reputation.md).
# This test asserts that factoring holds:
#
#   REGISTRY   — worker_kind_field returns the right handler/unit/provider/namespace
#                per kind; worker_kinds enumerates them; unknown kind fails.
#   MODEL SEL  — resolve_model_tier is provider-scoped (anthropic unchanged, openai
#                added); role_default_model / role_default_effort are per-kind.
#   ONE SPINE  — gardener.sh (the SAME file) claims + completes a job as a GARDENER
#                and as a CLERIC via a stub handler, differing only by the state
#                namespace and the bus/marker labels — never a forked loop. The
#                cleric's markers/clone live under the clerics/ namespace.
#   ELIGIBILITY— a job pinned to a Claude model is gardener-only; one pinned to a
#                codex model is cleric-only; an unpinned job is claimable by either.
#   ONE TEMPLATE — the single garden-worker@.service.in renders to BOTH
#                garden-gardener@.service and garden-cleric@.service (no per-kind
#                source), and the scaler/scale path arms EACH kind's pool.
#
# Usage: worker-spine-kinds-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SRC="$ROOT/scripts/systemd"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job cannot
# splice its own GARDEN_*/JOURNAL_* under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"

STUB="$HERE/stub-handler.sh"

# seed_board <dir> <base> [frontmatter] — throwaway origin + board with one todo job.
seed_board() {
  local tr="$1" base="$2" front="${3:-}" bare="$1/journal.git" seed="$1/seed" branch=journal2
  local -a git_id=(-c user.name=test -c user.email=test@localhost)
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    { [ -n "$front" ] && printf -- '---\n%s\n---\n' "$front"; printf '# %s\n\ndo the work for %s\n' "$base" "$base"; } > "jobs/todo/$base.md" )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# ============================================================================
hr; echo "REGISTRY — worker_kind_field / worker_kinds / worker_busy_marker"; hr
# --- monk: the canonical Anthropic worker kind (design anthropic-worker-kind-monk) --
[ "$(worker_kind_field monk handler)" = "handlers/monk-claude.sh" ] && ok "monk handler" || bad "monk handler ($(worker_kind_field monk handler))"
[ "$(worker_kind_field monk provider)" = "anthropic" ] && ok "monk provider anthropic" || bad "monk provider"
[ "$(worker_kind_field monk unit)" = "garden-monk@" ] && ok "monk unit prefix" || bad "monk unit"
[ "$(worker_kind_field monk count_key)" = "monks" ] && ok "monk count_key" || bad "monk count_key"
[ "$(worker_kind_field monk state_ns)" = "monks" ] && ok "monk state_ns" || bad "monk state_ns"
[ "$(worker_kind_field monk label)" = "garden-monk" ] && ok "monk self-heal label" || bad "monk label"
# --- gardener: the LEGACY Anthropic alias, retained unchanged for the staged cutover -
[ "$(worker_kind_field gardener handler)" = "handlers/gardener-claude.sh" ] && ok "gardener (legacy) handler" || bad "gardener handler ($(worker_kind_field gardener handler))"
[ "$(worker_kind_field cleric   handler)" = "handlers/cleric-codex.sh" ]   && ok "cleric handler"   || bad "cleric handler ($(worker_kind_field cleric handler))"
[ "$(worker_kind_field gardener provider)" = "anthropic" ] && ok "gardener provider anthropic" || bad "gardener provider"
[ "$(worker_kind_field cleric   provider)" = "openai" ]    && ok "cleric provider openai"    || bad "cleric provider"
[ "$(worker_kind_field gardener unit)" = "garden-gardener@" ] && ok "gardener unit prefix" || bad "gardener unit"
[ "$(worker_kind_field cleric   unit)" = "garden-cleric@" ]   && ok "cleric unit prefix"   || bad "cleric unit"
[ "$(worker_kind_field cleric   count_key)" = "clerics" ] && ok "cleric count_key" || bad "cleric count_key"
[ "$(worker_kind_field cleric   state_ns)"  = "clerics" ] && ok "cleric state_ns"  || bad "cleric state_ns"
# hermit = the provider: local codex-cleric — reuses the codex handler, distinct ns.
[ "$(worker_kind_field hermit   handler)" = "handlers/cleric-codex.sh" ] && ok "hermit reuses codex handler" || bad "hermit handler ($(worker_kind_field hermit handler))"
[ "$(worker_kind_field hermit   provider)" = "local" ]    && ok "hermit provider local"    || bad "hermit provider"
[ "$(worker_kind_field hermit   unit)" = "garden-hermit@" ] && ok "hermit unit prefix" || bad "hermit unit"
[ "$(worker_kind_field hermit   count_key)" = "hermits" ] && ok "hermit count_key" || bad "hermit count_key"
[ "$(worker_kind_field hermit   state_ns)"  = "hermits" ] && ok "hermit state_ns"  || bad "hermit state_ns"
[ "$(worker_kind_field mystic   handler)" = "handlers/mystic-kimi.sh" ] && ok "mystic uses official Kimi handler" || bad "mystic handler ($(worker_kind_field mystic handler))"
[ "$(worker_kind_field mystic   provider)" = "moonshot" ] && ok "mystic provider moonshot" || bad "mystic provider"
[ "$(worker_kind_field mystic   unit)" = "garden-mystic@" ] && ok "mystic unit prefix" || bad "mystic unit"
[ "$(worker_kind_field mystic   count_key)" = "mystics" ] && ok "mystic count_key" || bad "mystic count_key"
[ "$(worker_kind_field mystic   state_ns)" = "mystics" ] && ok "mystic state_ns" || bad "mystic state_ns"
[ "$(worker_kind_field fireworker handler)" = "handlers/cleric-codex.sh" ] && ok "fireworker reuses OpenAI-compatible Codex handler" || bad "fireworker handler"
[ "$(worker_kind_field fireworker provider)" = "fireworks" ] && ok "fireworker provider fireworks" || bad "fireworker provider"
[ "$(worker_kind_field fireworker unit)" = "garden-fireworker@" ] && ok "fireworker unit prefix" || bad "fireworker unit"
[ "$(worker_kind_field fireworker count_key)" = "fireworkers" ] && ok "fireworker count key" || bad "fireworker count key"
[ "$(worker_kinds | paste -sd, -)" = "monk,gardener,cleric,hermit,mystic,fireworker" ] && ok "worker_kinds enumerates monk + the legacy gardener alias + all backends" || bad "worker_kinds ($(worker_kinds | paste -sd, -))"
# canonical_worker_kind: the SOLE decoder. v1 gardener -> monk; known v2 unchanged;
# unknown / contradictory rejected with no silent fallback.
[ "$(canonical_worker_kind gardener)" = monk ] && ok "canonical: v1 gardener -> monk" || bad "canonical v1 gardener"
[ "$(canonical_worker_kind monk)" = monk ] && ok "canonical: monk -> monk" || bad "canonical monk"
[ "$(canonical_worker_kind cleric)" = cleric ] && ok "canonical: cleric unchanged" || bad "canonical cleric"
canonical_worker_kind gardener 2 >/dev/null 2>&1 && bad "canonical: v2-schema gardener must reject" || ok "canonical: v2-schema gardener rejected (no such v2 spelling)"
canonical_worker_kind friar >/dev/null 2>&1 && bad "canonical: unknown must reject" || ok "canonical: unknown kind rejected (no silent fallback)"
canonical_worker_kind monk 2 openai >/dev/null 2>&1 && bad "canonical: contradictory provider must reject" || ok "canonical: contradictory kind/provider tuple rejected"
[ "$(canonical_worker_kind monk 2 anthropic)" = monk ] && ok "canonical: monk/anthropic tuple accepted" || bad "canonical monk/anthropic"
# anthropic_active_kind: monks: wins, else the legacy gardeners:; never both.
AAK_D="$(mktemp -d "${TMPDIR:-/tmp}/garden-aak.XXXXXX")"
: > "$AAK_D/none";                       [ "$(anthropic_active_kind "$AAK_D/none")" = gardener ] && ok "active kind: no count line -> legacy gardener" || bad "active kind none"
printf 'gardeners: 3\n' > "$AAK_D/g";     [ "$(anthropic_active_kind "$AAK_D/g")" = gardener ] && ok "active kind: only gardeners: -> gardener" || bad "active kind gardeners"
printf 'monks: 2\ngardeners: 3\n' > "$AAK_D/both"; [ "$(anthropic_active_kind "$AAK_D/both")" = monk ] && ok "active kind: monks: present (mirror retained) -> monk wins, never both" || bad "active kind both"
rm -rf "$AAK_D"
( GARDEN_STATE=/tmp/x; [ "$(worker_busy_marker cleric 3)" = "/tmp/x/clerics/3/busy" ] ) && ok "cleric busy marker under clerics/ ns" || bad "cleric busy marker path"
( GARDEN_STATE=/tmp/x; [ "$(gardener_busy_marker 3)" = "/tmp/x/gardeners/3/busy" ] ) && ok "gardener busy marker back-compat wrapper" || bad "gardener busy marker wrapper"
worker_kind_field friar handler 2>/dev/null && bad "unknown kind must fail" || ok "unknown kind 'friar' → non-zero (registry rejects)"

# ============================================================================
hr; echo "MODEL SELECTION — provider-scoped tiers + per-kind role defaults"; hr
[ "$(resolve_model_tier opus)" = "claude-opus-4-8" ] && ok "anthropic default (bare tier) unchanged" || bad "anthropic bare tier"
[ "$(resolve_model_tier anthropic sonnet)" = "claude-sonnet-4-6" ] && ok "resolve_model_tier anthropic sonnet" || bad "anthropic sonnet"
[ "$(resolve_model_tier openai terra)" = "gpt-5.6-terra" ] && ok "resolve_model_tier openai terra" || bad "openai terra"
[ "$(resolve_model_tier openai frontier)" = "gpt-5.5" ] && ok "resolve_model_tier openai frontier" || bad "openai frontier"
[ "$(resolve_model_tier openai gpt-5.4-mini)" = "gpt-5.4-mini" ] && ok "openai concrete id passthrough" || bad "openai passthrough"
[ -z "$(resolve_model_tier openai opus)" ] && ok "openai map rejects a claude tier (no cross-provider leak)" || bad "openai leaked a claude tier"
# local provider — data-driven classification from the model-routing table (the
# tracked default: qwen family). A gpt-oss tag is NO LONGER local (box serves qwen).
[ "$(resolve_model_tier local qwen3.6)" = "qwen3.6" ] && ok "local served qwen tag passthrough" || bad "local qwen tag passthrough"
[ -z "$(resolve_model_tier local gpt-oss:20b)" ] && ok "local map rejects gpt-oss (retired: box serves qwen only)" || bad "local still captured gpt-oss"
[ -z "$(resolve_model_tier local llama3.2:3b)" ] && ok "local map rejects a non-qwen served tag" || bad "local captured a non-qwen tag"
[ -z "$(resolve_model_tier openai gpt-oss:20b)" ] && ok "openai map rejects a gpt-oss tag (!gpt-oss* exclude)" || bad "openai captured a gpt-oss tag"
[ -z "$(resolve_model_tier local terra)" ] && ok "local map rejects a codex tier (no cross-provider leak)" || bad "local leaked a codex tier"
[ "$(resolve_model_tier moonshot kimi-k3)" = "kimi-k3" ] && ok "moonshot concrete kimi-k3" || bad "moonshot concrete id"
[ -z "$(resolve_model_tier moonshot k3)" ] && ok "moonshot refuses abbreviated k3 selector" || bad "moonshot accepted abbreviated K3"
[ -z "$(resolve_model_tier openai kimi-k3)" ] && ok "openai rejects kimi-k3" || bad "openai captured Kimi"
[ -z "$(resolve_model_tier anthropic kimi-k3)" ] && ok "anthropic rejects kimi-k3" || bad "anthropic captured Kimi"
[ -z "$(resolve_model_tier local kimi-k3)" ] && ok "local rejects kimi-k3" || bad "local captured Kimi"
[ "$(resolve_model_tier fireworks fireworks/accounts/fireworks/models/glm-5p2)" = "fireworks/accounts/fireworks/models/glm-5p2" ] && ok "reviewed Fireworks GLM selector binds" || bad "Fireworks GLM selector"
[ -z "$(resolve_model_tier fireworks fireworks/accounts/fireworks/models/example)" ] && ok "unknown Fireworks selector fails closed" || bad "placeholder Fireworks selector accepted"
[ -z "$(resolve_model_tier fireworks accounts/fireworks/models/glm-5p2)" ] && ok "Fireworks requires namespaced selector" || bad "Fireworks selector was implicit"
# --- GLM 5.2 and Fireworks-served Kimi K3 as reviewed routes -----------------
# Both wire ids were verified against first-party Fireworks documentation
# (context/operations/fireworks.md § Registered routes): the model pages
# fireworks.ai/models/fireworks/{glm-5p2,kimi-k3} both show "Available Serverless".
# These assertions fail if a future inventory edit changes either verified id.
[ "$(resolve_model_tier fireworks fireworks/accounts/fireworks/models/kimi-k3)" = "fireworks/accounts/fireworks/models/kimi-k3" ] && ok "reviewed Fireworks K3 selector binds" || bad "Fireworks K3 selector"
[ "$(model_dispatch_tier fireworks fireworks/accounts/fireworks/models/glm-5p2)" = mentor ] && ok "Fireworks GLM 5.2 is a mentor-tier model" || bad "GLM 5.2 tier"
[ "$(model_dispatch_tier fireworks fireworks/accounts/fireworks/models/kimi-k3)" = mentor ] && ok "Fireworks-served K3 is a mentor-tier model" || bad "Fireworks K3 tier"
# KNOWN LIMITATION, asserted so it is never a silent surprise: GLM 5.2 and
# Fireworks-served K3 share the mentor tier, and the resolver is tier-first-match,
# so a plain `tier: mentor` Fireworks job resolves to GLM 5.2. K3 is registered
# with a verified id but is NOT independently tier-selectable while it shares the
# tier — a maintainer routing decision (fireworks.md § Registered routes).
[ "$(tier_model_for_provider mentor fireworks)" = "fireworks/accounts/fireworks/models/glm-5p2" ] && ok "mentor fireworks resolves to GLM 5.2 (K3 shares the tier, documented)" || bad "mentor fireworks resolution ($(tier_model_for_provider mentor fireworks))"
# The Moonshot/mystic K3 lane is a DIFFERENT backend, not re-routed or absorbed:
# bare `kimi-k3` stays moonshot-only and never resolves under the fireworks provider,
# and the namespaced Fireworks K3 id never resolves under moonshot.
[ -z "$(resolve_model_tier fireworks kimi-k3)" ] && ok "bare kimi-k3 does NOT bind under fireworks (mystic lane intact)" || bad "fireworks captured the bare mystic K3 pin"
[ -z "$(resolve_model_tier moonshot fireworks/accounts/fireworks/models/kimi-k3)" ] && ok "namespaced Fireworks K3 does NOT bind under moonshot" || bad "moonshot captured the Fireworks K3 route"
[ "$(role_default_model builder)" = "claude-opus-4-8" ] && ok "gardener builder → opus (back-compat 1-arg)" || bad "gardener builder default"
[ "$(role_default_model cleric builder)" = "gpt-5.6-terra" ] && ok "cleric builder → gpt-5.6-terra" || bad "cleric builder default"
[ "$(role_default_model gardener cleaner)" = "claude-haiku-4-5-20251001" ] && ok "gardener cleaner → Haiku" || bad "gardener cleaner default"
[ "$(role_default_model gardener retcon)" = "claude-haiku-4-5-20251001" ] && ok "gardener retcon → Haiku" || bad "gardener retcon default"
[ "$(role_default_model gardener weaver)" = "claude-sonnet-4-6" ] && ok "gardener weaver → Sonnet" || bad "gardener weaver default"
[ "$(role_default_model gardener conductor)" = "claude-sonnet-4-6" ] && ok "gardener conductor → Sonnet" || bad "gardener conductor default"
[ "$(role_default_model gardener journalist)" = "claude-haiku-4-5-20251001" ] && ok "gardener journalist → Haiku" || bad "gardener journalist default"
[ "$(role_default_model gardener pages-shepherd)" = "claude-sonnet-4-6" ] && ok "gardener pages-shepherd → Sonnet" || bad "gardener pages-shepherd default"
[ "$(role_default_model cleric cleaner)" = "gpt-5.4-mini" ] && ok "cleric cleaner → mini" || bad "cleric cleaner default"
[ "$(role_default_model cleric weaver)" = "gpt-5.5" ] && ok "cleric weaver → frontier" || bad "cleric weaver default"
[ -z "$(role_default_model cleric fixer)" ] && ok "cleric fixer unpinned (rides fleet default)" || bad "cleric fixer default"
[ "$(role_default_model hermit builder)" = "qwen3.6" ] && ok "hermit builder → qwen3.6 (local fleet default from table)" || bad "hermit builder default ($(role_default_model hermit builder))"
[ "$(role_default_model hermit cleaner)" = "qwen3.6" ] && ok "hermit cleaner → qwen3.6" || bad "hermit cleaner default"
[ "$(role_default_model hermit weaver)" = "qwen3.6" ] && ok "hermit weaver → qwen3.6" || bad "hermit weaver default"
[ -z "$(role_default_model hermit fixer)" ] && ok "hermit fixer unpinned (rides hermit fleet default)" || bad "hermit fixer default"
[ -z "$(role_default_model mystic builder)" ] && ok "mystic builder has no high-stakes default" || bad "mystic builder default"
[ -z "$(role_default_model fireworker fixer)" ] && ok "fireworker has no implicit model default" || bad "fireworker default"
ARM_JOB="$(mktemp "${TMPDIR:-/tmp}/garden-mystic-arm.XXXXXX")"
printf '%s\n' '---' 'model: kimi-k3' 'role: fixer' '---' > "$ARM_JOB"
# shellcheck source=../reputation.sh
source "$JOBS/reputation.sh"
mapfile -t mystic_arm < <(rep_resolve_arm mystic "$ARM_JOB")
rm -f "$ARM_JOB"
[ "${mystic_arm[*]}" = "moonshot kimi-k3 medium" ] && ok "mystic reputation arm retains kind/provider/model" || bad "mystic reputation arm (${mystic_arm[*]})"
# A Fireworks mentor job earns its own arm (fireworker/fireworks/<wire id>), which
# must NOT pool with the Moonshot/mystic K3 arm above: different kind, provider, and
# model all key the arm, so the two K3 backends never share reputation.
FW_ARM_JOB="$(mktemp "${TMPDIR:-/tmp}/garden-fw-arm.XXXXXX")"
printf '%s\n' '---' 'provider: fireworks' 'tier: mentor' 'role: fixer' '---' > "$FW_ARM_JOB"
mapfile -t fw_arm < <(rep_resolve_arm fireworker "$FW_ARM_JOB")
rm -f "$FW_ARM_JOB"
[ "${fw_arm[*]}" = "fireworks fireworks/accounts/fireworks/models/glm-5p2 medium" ] && ok "fireworker reputation arm is fireworks/<wire id>" || bad "fireworker reputation arm (${fw_arm[*]})"
FW_ARM_PATH="$(rep_arm_relpath fireworker "${fw_arm[0]}" "${fw_arm[1]}" "${fw_arm[2]}" gardener:s main2 2>/dev/null || true)"
MY_ARM_PATH="$(rep_arm_relpath mystic "${mystic_arm[0]}" "${mystic_arm[1]}" "${mystic_arm[2]}" gardener:s main2 2>/dev/null || true)"
{ [ -n "$FW_ARM_PATH" ] && [ "$FW_ARM_PATH" != "$MY_ARM_PATH" ]; } && ok "Fireworks and Moonshot arms project to distinct journal paths (no pooling)" || bad "Fireworks/Moonshot arm paths collided ($FW_ARM_PATH / $MY_ARM_PATH)"
[ "$(role_default_effort cleric builder)" = "high" ] && ok "cleric builder effort high" || bad "cleric builder effort"
[ "$(role_default_effort cleric fixer)" = "medium" ] && ok "cleric fixer effort medium" || bad "cleric fixer effort"
[ "$(role_default_effort hermit builder)" = "high" ] && ok "hermit builder effort high" || bad "hermit builder effort"

# ============================================================================
hr; echo "POLICY INVARIANTS — no IMPLICIT Fable; K3 is an explicit-only trial lane"; hr
# Maintainer directive (2026-07-25, via the liaison): walk back EVERY implicit/
# default use of Fable to Opus. Fable is honored only on an EXPLICIT per-job
# `model: fable`; NO role default on ANY worker kind may resolve to the Fable id.
# This is the drift guard: if a future edit re-pins any role to Fable, it fails here.
FABLE_ID="$(resolve_model_tier anthropic fable)"
[ "$FABLE_ID" = "claude-fable-5" ] && ok "fable tier still BINDS (explicit model: fable honored)" || bad "fable tier binding ($FABLE_ID)"
fable_default_leak=0
for k in gardener cleric hermit mystic fireworker; do
  for r in designer builder fixer weaver conductor shepherd researcher scholar triager cleaner journalist orchestrator; do
    if [ "$(role_default_model "$k" "$r")" = "$FABLE_ID" ]; then
      bad "IMPLICIT Fable default leaked: kind=$k role=$r resolves to $FABLE_ID"
      fable_default_leak=1
    fi
  done
done
[ "$fable_default_leak" -eq 0 ] && ok "no role default on any kind resolves to Fable (no implicit Fable anywhere)"
# The two pinned gardener roles land on Opus, not Fable (positive assertion).
[ "$(role_default_model gardener designer)" = "claude-opus-4-8" ] && ok "gardener designer → Opus (former Fable default walked back)" || bad "gardener designer default ($(role_default_model gardener designer))"
[ "$(role_default_model gardener builder)"  = "claude-opus-4-8" ] && ok "gardener builder → Opus" || bad "gardener builder default"
# K3 trial lane: mystic is the ONLY K3-capable kind and it is ZERO-default. No
# role default — design/build or otherwise — selects K3 on any kind; K3 rides in
# only on an explicit `model: kimi-k3` pin (eligibility section proves the claim path).
for r in designer builder fixer researcher scholar triager; do
  [ -z "$(role_default_model mystic "$r")" ] || bad "mystic role default must be empty (zero-default K3): role=$r"
done
ok "mystic zero-default across roles (K3 never an implicit choice)"
# No non-mystic kind can even bind the BARE k3 id via its provider tier map. The
# fireworks provider is included: a Fireworks-served K3 is reached by its namespaced
# `fireworks/accounts/fireworks/models/kimi-k3` id, never by the bare `kimi-k3` pin
# that belongs to the Moonshot/mystic lane.
{ [ -z "$(resolve_model_tier anthropic kimi-k3)" ] && [ -z "$(resolve_model_tier openai kimi-k3)" ] \
  && [ -z "$(resolve_model_tier local kimi-k3)" ] && [ -z "$(resolve_model_tier fireworks kimi-k3)" ]; } \
  && ok "bare kimi-k3 binds under NO non-moonshot provider (explicit K3 stays on the mystic lane)" || bad "bare kimi-k3 leaked to a non-moonshot provider"

# ============================================================================
hr; echo "ONE SPINE — the SAME gardener.sh completes a job as gardener AND as cleric"; hr
run_kind() {  # run_kind <kind> <base> <host> [frontmatter]
  local kind="$1" base="$2" host="$3" front="${4:-}" tr bare
  tr="$(mktemp -d "${TMPDIR:-/tmp}/garden-spine-$kind.XXXXXX")"
  bare="$(seed_board "$tr" "$base" "$front")"
  env GARDEN="$host" GARDEN_STATE="$tr/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
      GARDEN_WORKER_KIND="$kind" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
      GARDEN_JOB_HANDLER="$STUB" \
      "$JOBS/gardener.sh" 1 > "$tr/worker.log" 2>&1 || true
  local v="$tr/verify"; git clone -q --single-branch --branch journal2 "$bare" "$v" 2>/dev/null
  # completed doin→tada
  if [ -f "$v/jobs/tada/$base.md" ] && [ ! -e "$v/jobs/doin/$base.md" ]; then
    ok "$kind: claimed + completed '$base' doin→tada (shared spine)"
  else
    bad "$kind: '$base' not completed (tada=$([ -f "$v/jobs/tada/$base.md" ] && echo y || echo n) doin=$([ -e "$v/jobs/doin/$base.md" ] && echo y || echo n))"
  fi
  # The claim carries worker_kind in its doin commit. complete-job removes that
  # path afterward, so inspect the path-specific history.
  git -C "$v" log -p --all -- "jobs/doin/$base.md" > "$tr/claim-history" 2>/dev/null || true
  if grep -q "worker_kind: $kind" "$tr/claim-history"; then
    ok "$kind: claim metadata stamped worker_kind: $kind (journal history)"
  else
    bad "$kind: worker_kind not stamped in the claim history"
  fi
  # the spine logged its kind
  grep -q "kind=$kind" "$tr/worker.log" && ok "$kind: spine started with kind=$kind" || bad "$kind: spine kind not logged"
  # per-kind state namespace: the identity marker lives under the kind's ns
  local ns; ns="$(worker_kind_field "$kind" state_ns)"
  [ -f "$tr/state/$ns/1.garden" ] && ok "$kind: identity marker under $ns/ namespace" || bad "$kind: identity marker not under $ns/ (found: $(find "$tr/state" -name '*.garden' 2>/dev/null | tr '\n' ' '))"
  rm -rf "$tr"
}
# The canonical Anthropic kind claims + completes an Anthropic-pinned job through the
# SAME spine, stamping worker_kind: monk and keeping its state under the monks/ ns —
# the design's stage-1 acceptance evidence (a monk alone claims the Anthropic job).
run_kind monk     mkspine mkhost "model: opus"
run_kind gardener gspine ghost "model: opus"
run_kind cleric   cspine chost "model: terra"
run_kind hermit   hspine hhost "model: qwen3.6"
run_kind mystic   mspine mihost "model: kimi-k3"
run_kind fireworker fwspine fwhost $'provider: fireworks\ntier: mentor'

# ============================================================================
hr; echo "ELIGIBILITY — §1.3 backend-fit filter keeps a kind off a foreign-pinned job"; hr
# A cleric must NOT claim a job pinned to a Claude model; it stays in todo for a
# gardener. An unpinned job a cleric CAN claim.
elig_case() {  # elig_case <kind> <base> <front> <expect: claimed|left>
  local kind="$1" base="$2" front="$3" expect="$4" tr bare
  tr="$(mktemp -d "${TMPDIR:-/tmp}/garden-elig.XXXXXX")"
  bare="$(seed_board "$tr" "$base" "$front")"
  env GARDEN="ehost" GARDEN_STATE="$tr/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
      GARDEN_WORKER_KIND="$kind" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
      GARDEN_JOB_HANDLER="$STUB" \
      "$JOBS/gardener.sh" 1 > "$tr/worker.log" 2>&1 || true
  local v="$tr/verify"; git clone -q --single-branch --branch journal2 "$bare" "$v" 2>/dev/null
  local claimed=no; { [ -f "$v/jobs/tada/$base.md" ] || [ -e "$v/jobs/doin/$base.md" ]; } && claimed=yes
  if [ "$expect" = claimed ] && [ "$claimed" = yes ]; then
    ok "$kind claimed '$base' ($front) as expected"
  elif [ "$expect" = left ] && [ "$claimed" = no ] && [ -f "$v/jobs/todo/$base.md" ]; then
    ok "$kind left '$base' ($front) in todo (backend-fit filter)"
  else
    bad "$kind eligibility wrong for '$base' ($front): expect=$expect claimed=$claimed"
  fi
  rm -rf "$tr"
}
elig_case cleric   pinnedclaude "model: opus"  left
elig_case cleric   pinnedcodex  "model: terra" claimed
elig_case cleric   unpinnedjob  ""             claimed
elig_case gardener pinnedcodex2 "model: terra" left
elig_case gardener pinnedclaude2 "model: opus" claimed
# monk is Anthropic: it claims a Claude-pinned job and, like the gardener, leaves a
# foreign-provider-pinned one for the right backend (backend-fit filter is per-provider).
elig_case monk     pinnedclaude_m "model: opus"  claimed
elig_case monk     pinnedcodex_m  "model: terra" left
elig_case monk     pinnedqwen_m   "model: qwen3.6" left
elig_case monk     unpinned_m     ""             claimed
# hermit (provider: local) claims ONLY local-pinned (qwen family, per the routing
# table) or unpinned jobs; a qwen-pinned job is off-limits to the paid cleric and the
# gardener. A gpt-oss:* tag is NO LONGER local — it matches no provider, so it is
# UNPINNED and claimable by ANY kind (regression guard for "hermits only serve qwen").
elig_case hermit   pinnedqwen   "model: qwen3.6"   claimed
elig_case hermit   pinnedqwen2  "model: qwen3.6"   claimed
elig_case hermit   pinnedcodex3 "model: terra"        left
elig_case hermit   pinnedclaude3 "model: opus"        left
elig_case hermit   unpinnedjob2 ""                    claimed
elig_case cleric   pinnedqwen3  "model: qwen3.6"   left
elig_case gardener pinnedqwen4  "model: qwen3.6"   left
elig_case mystic   pinnedkimi   "model: kimi-k3"      claimed
elig_case cleric   pinnedkimi2  "model: kimi-k3"      left
elig_case gardener pinnedkimi3  "model: kimi-k3"      left
elig_case hermit   pinnedkimi4  "model: kimi-k3"      left
elig_case mystic   unpinnedkimi ""                    left
elig_case mystic   abbreviatedkimi "model: k3"         left
elig_case mystic   builderkimi $'model: kimi-k3\nrole: builder' left
elig_case mystic   designerkimi $'model: kimi-k3\nrole: designer' left
elig_case fireworker pinnedfireworks $'provider: fireworks\ntier: mentor' claimed
elig_case fireworker unpinnedfireworks "" left
elig_case fireworker foreignprovider $'provider: moonshot\ntier: mentor' left
elig_case cleric foreignfireworks $'provider: fireworks\ntier: mentor' left
elig_case gardener foreignfireworks2 $'provider: fireworks\ntier: mentor' left
elig_case fireworker unknownprovider $'provider: imaginary\ntier: mentor' left
# gpt-oss is retired from local: now unpinned, so EVERY kind may claim it.
elig_case gardener gptoss_gard  "model: gpt-oss:120b" claimed
elig_case cleric   gptoss_cler  "model: gpt-oss:20b"  claimed
elig_case hermit   gptoss_herm  "model: gpt-oss:20b"  claimed

# ============================================================================
hr; echo "ONE TEMPLATE — garden-worker@.service.in renders BOTH kinds; scale arms each"; hr
[ -e "$SRC/garden-worker@.service.in" ] && ok "single worker template garden-worker@.service.in exists" || bad "worker template missing"
[ ! -e "$SRC/garden-gardener@.service" ] && ok "no per-kind garden-gardener@.service source (factored away)" || bad "stale garden-gardener@.service source present"
[ ! -e "$SRC/garden-cleric@.service" ] && ok "no per-kind garden-cleric@.service source (rendered only)" || bad "stray garden-cleric@.service source present"

# Render the template for both kinds the way install-units does and check the
# @WORKER_KIND@ substitution landed distinctly.
RT="$(mktemp -d "${TMPDIR:-/tmp}/garden-render.XXXXXX")"
for kind in monk gardener cleric hermit mystic fireworker; do
  sed -e "s#@GARDEN_ROOT@#/opt/garden#g" -e "s#@WORKER_KIND@#$kind#g" "$SRC/garden-worker@.service.in" > "$RT/garden-$kind@.service"
done
grep -q 'GARDEN_WORKER_KIND=monk' "$RT/garden-monk@.service" && ok "monk unit sets GARDEN_WORKER_KIND=monk" || bad "monk kind env"
grep -q 'self-heal-run.sh garden-monk ' "$RT/garden-monk@.service" && ok "monk ExecStart labels self-heal garden-monk" || bad "monk self-heal label"
grep -q 'GARDEN_WORKER_KIND=gardener' "$RT/garden-gardener@.service" && ok "gardener (legacy) unit sets GARDEN_WORKER_KIND=gardener" || bad "gardener kind env"
grep -q 'GARDEN_WORKER_KIND=cleric'   "$RT/garden-cleric@.service"   && ok "cleric unit sets GARDEN_WORKER_KIND=cleric"     || bad "cleric kind env"
grep -q 'GARDEN_WORKER_KIND=hermit'   "$RT/garden-hermit@.service"   && ok "hermit unit sets GARDEN_WORKER_KIND=hermit"     || bad "hermit kind env"
grep -q 'GARDEN_WORKER_KIND=mystic'   "$RT/garden-mystic@.service"   && ok "mystic unit sets GARDEN_WORKER_KIND=mystic"     || bad "mystic kind env"
grep -q 'GARDEN_WORKER_KIND=fireworker' "$RT/garden-fireworker@.service" && ok "fireworker unit sets GARDEN_WORKER_KIND=fireworker" || bad "fireworker kind env"
grep -q 'self-heal-run.sh garden-cleric ' "$RT/garden-cleric@.service" && ok "cleric ExecStart labels self-heal garden-cleric" || bad "cleric self-heal label"
grep -q 'self-heal-run.sh garden-hermit ' "$RT/garden-hermit@.service" && ok "hermit ExecStart labels self-heal garden-hermit" || bad "hermit self-heal label"
grep -q 'self-heal-run.sh garden-mystic ' "$RT/garden-mystic@.service" && ok "mystic ExecStart labels self-heal garden-mystic" || bad "mystic self-heal label"
grep -q 'self-heal-run.sh garden-fireworker ' "$RT/garden-fireworker@.service" && ok "fireworker ExecStart labels self-heal garden-fireworker" || bad "fireworker self-heal label"
rm -rf "$RT"

# The scaler scale path arms EACH kind's pool via mock-systemctl (no real systemd).
ST="$(mktemp -d "${TMPDIR:-/tmp}/garden-scale.XXXXXX")"
export GARDEN_ROOT="$ROOT" GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh"
export GARDEN_MOCK_STATE="$ST/armed" GARDEN_MOCK_LOG="$ST/log"; : > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"
export XDG_CONFIG_HOME="$ST/config"
"$JOBS/install-units.sh" scale cleric 2 >/dev/null 2>&1
"$JOBS/install-units.sh" scale monk 2 >/dev/null 2>&1
"$JOBS/install-units.sh" scale gardener 3 >/dev/null 2>&1
"$JOBS/install-units.sh" scale hermit 2 >/dev/null 2>&1
"$JOBS/install-units.sh" scale mystic 1 >/dev/null 2>&1
"$JOBS/install-units.sh" scale fireworker 1 >/dev/null 2>&1
gm=$(grep -c '^garden-monk@[12]\.service$' "$GARDEN_MOCK_STATE" || true)
gc=$(grep -c '^garden-cleric@[12]\.service$' "$GARDEN_MOCK_STATE" || true)
gg=$(grep -c '^garden-gardener@[123]\.service$' "$GARDEN_MOCK_STATE" || true)
gh=$(grep -c '^garden-hermit@[12]\.service$' "$GARDEN_MOCK_STATE" || true)
gk=$(grep -c '^garden-mystic@1\.service$' "$GARDEN_MOCK_STATE" || true)
gf=$(grep -c '^garden-fireworker@1\.service$' "$GARDEN_MOCK_STATE" || true)
[ "$gm" -eq 2 ] && ok "scale monk 2 -> garden-monk@{1,2} armed (canonical Anthropic pool renders + scales)" || bad "monk scale (@1-2=$gm)"
[ "$gc" -eq 2 ] && ok "scale cleric 2 → garden-cleric@{1,2} armed" || bad "cleric scale (@1-2=$gc)"
[ "$gg" -eq 3 ] && ok "scale gardener 3 → garden-gardener@{1,2,3} armed (independent pool)" || bad "gardener scale (@1-3=$gg)"
[ "$gh" -eq 2 ] && ok "scale hermit 2 → garden-hermit@{1,2} armed (new kind scalable, no arg-parse edit)" || bad "hermit scale (@1-2=$gh)"
[ "$gk" -eq 1 ] && ok "scale mystic 1 -> garden-mystic@1 armed (hosted pool independently scalable)" || bad "mystic scale (@1=$gk)"
[ "$gf" -eq 1 ] && ok "scale fireworker 1 -> garden-fireworker@1 armed (Fireworks pool independently scalable)" || bad "fireworker scale (@1=$gf)"
# back-compat: bare `scale <N>` still means gardener
: > "$GARDEN_MOCK_STATE"
"$JOBS/install-units.sh" scale 1 >/dev/null 2>&1
{ [ "$(grep -c '^garden-gardener@1\.service$' "$GARDEN_MOCK_STATE")" -eq 1 ] && [ "$(grep -c '^garden-cleric@' "$GARDEN_MOCK_STATE")" -eq 0 ]; } \
  && ok "bare 'scale 1' back-compat → gardener pool only" || bad "bare scale back-compat"
rm -rf "$ST"
unset GARDEN_UNIT_CTL GARDEN_MOCK_STATE GARDEN_MOCK_LOG XDG_CONFIG_HOME

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
