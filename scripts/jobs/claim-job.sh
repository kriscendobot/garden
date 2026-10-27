#!/bin/bash
# claim-job.sh — consumer primitive: atomically claim one job, todo → doin.
#
# Usage: claim-job.sh <gardener-id>
# On success: prints the claimed basename on stdout and exits 0.
# On no-work:  exits 3 (nothing claimable right now).
# On error:    exits non-zero (other).
#
# THE CLAIM IS THE ACCEPTED PUSH. A local `git mv todo→doin` is invisible to
# other workers/hosts until pushed; the push to origin/<branch> is the
# compare-and-swap. First pusher wins; a rejected (non-fast-forward) push
# means someone else moved the branch — we re-sync, and if our candidate is
# gone we BACK OFF and try the next one (no blind rebase-retry on a claim).
#
# Each gardener operates in its OWN journal clone (never a shared worktree),
# so two same-host gardeners cannot stomp each other's working tree.
#
# Candidates are drawn ONLY from JOBS_TODO. The jobs/plan/ category (parked work
# awaiting a go-ahead or deferred by priority) is never a claim candidate — it is
# promoted into todo/ first (promote-plan.sh).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=auction.sh
source "$HERE/auction.sh"     # the bid auction (sources reputation.sh); source-once guarded

id="${1:?usage: claim-job.sh <gardener-id>}"
# The claiming worker's kind (gardener | cleric), inherited from the spine
# (gardener.sh exports GARDEN_WORKER_KIND); default monk for a standalone call.
KIND="${GARDEN_WORKER_KIND:-monk}"
KIND_PROVIDER="$(worker_kind_field "$KIND" provider 2>/dev/null || echo anthropic)"
# auction_write_bid reads THIS worker's kind + id from the env (so its signature
# stays a plain <dir> <base>); export them alongside the claim.
export AUCTION_KIND="$KIND" AUCTION_ID="$id"
export GARDEN_TAG="claim/$id"

fleet_draining && { log "fleet draining; refusing to claim"; exit 3; }

# Is THIS worker's own unit being stopped or restarted? A deploy's restart wave
# SIGTERMs the gardener, but bash defers its TERM trap until this claim returns, and
# under journal contention one claim pass can race candidates for many minutes. Left
# alone, the pass claims a job after the stop began and the gardener then runs it to
# completion, holding the restart (and the deploy waiting on it) for the whole job
# (oros 2026-10-13: monk 5 claimed 6 min into its stop and held the deploy until
# self-heal killed it at 2400s, so fleet health was never published). The unit is
# `deactivating` for the whole stop, so checking it between candidates bounds the
# claim pass to the attempt already in flight. Off in tests unless a mock unit_ctl
# is injected, so a test claim never reads a live host's unit state.
own_worker_stopping() {
  [ "${GARDEN_TEST:-0}" != 1 ] || [ -n "${GARDEN_UNIT_CTL:-}" ] || return 1
  local u
  u="$(worker_kind_field "$KIND" unit 2>/dev/null)" || return 1
  [ "$(unit_ctl_bounded is-active "${u}${id}.service" 2>/dev/null || true)" = deactivating ]
}

# --- §1.3 pre-auction claim eligibility (the interim backend-fit filter) ------
#
# Now that more than one backend claims from the same board, a worker must never
# claim a job it cannot honor: a job pinned to a Claude model is gardener-only (
# provider anthropic), one pinned to a paid codex model is cleric-only (openai), one
# pinned to a served LOCAL tag (the qwen family) is hermit-only (local), and an
# UNPINNED job (no `model:`, or a value no provider's patterns match) is claimable by
# any kind. Mystic is disabled during the Moonshot-credit exhaustion posture, so it
# accepts no claims even if a stale unit remains alive. K3 stays an exact historical
# id for deterministic migration/requeue handling, never a default route.
# This is a small deterministic predicate — no LLM, no auction — and it is
# the seam the bid auction (build child 2) later replaces: under the auction, backend
# fit is PRICED into the bid instead of hard-filtered.
#
# The provider classification is DATA-DRIVEN: resolve_model_tier reads the
# journal-backed model-routing table (common.sh _model_classify, seeded by
# scripts/jobs/model-routing-defaults.tsv, doc skills/model-selection/SKILL.md), so the
# recognized-model set changes as a journal edit, not a code edit. Each provider
# owns a disjoint id space (claude-* → anthropic, qwen* → local, gpt-*/o[0-9]*/codex-*
# minus gpt-oss* → openai), so a job pins at most one provider. Local is checked
# BEFORE openai for belt-and-suspenders ordering. NOTE: a gpt-oss:* tag now matches
# NO provider → it is UNPINNED (claimable by any kind), no longer auto-local — the
# box serves qwen, not gpt-oss.
job_eligible_for_kind() {
  local jf="$1" tier pin constrained_provider role routed_model trial budget_role
  if [ "$(plan_field "$jf" ratchet-arc)" = ironhorse-test262-ratchet ]; then
    python3 "$HERE/ratchet/policy.py" active "$DIR" >/dev/null 2>&1 || return 1
  fi
  # ROLE backend-fit: a job whose `role:` demands the full Claude-agent posture (the
  # self-directed `gardener` loop the codex/local handlers cannot honor) is claimable
  # only by an anthropic kind — the role analogue of the provider filter below, fencing
  # hermit/cleric/fireworker/mystic off exactly as the mystic carve-out fences builder/
  # designer. Checked FIRST, before tier resolution, so it also catches an unpinned,
  # tier-less `role: gardener` job (the automatic-dispatch default that would otherwise
  # fall through the unclassified-tier early-return below). Closes the
  # hermit-claims-gardener claim/die/requeue hot loop (2026-08-19).
  budget_role="$(canonical_budget_role "$(plan_field "$jf" handler-budget-role)")"
  if [ "$KIND" != monk ] && [ "$KIND" != gardener ] \
     && role_requires_anthropic_posture "$(plan_field "$jf" role)"; then
    # A staged panel deliberately wears the generic gardener role because the
    # script, not the supervising agent, owns its workflow. Its provider-aware
    # runner is the one safe exception to the historical Claude-posture fence.
    # Only the native OpenAI cleric joins the Anthropic workers here; custom/local
    # Codex and Claude-compatible lanes remain excluded.
    [ "$budget_role" = panel ] && [ "$KIND" = cleric ] || return 1
  fi
  pin="$(plan_field "$jf" model)"
  trial="$(plan_field "$jf" trial)"
  if [ -n "$trial" ]; then
    # The only experimental widening is an explicit, numbered qwen mentor-trial
    # permit.  Every other kind and every malformed/unknown trial marker leaves
    # the job untouched.  The closed inventory continues to classify qwen3.6 as
    # minion; `trial-tier` records the difficulty being tested, not a new tier.
    [ "$KIND" = hermit ] || return 1
    qwen_mentor_trial_job "$jf" || return 1
    qwen_mentor_trial_slot_unique "$DIR" "$jf" || return 1
    qwen_mentor_trial_admits "$DIR" || return 1
    qwen_mentor_trial_no_inflight "$DIR" || return 1
  fi
  # A shared provider id cannot by itself select a harness: without this routing
  # namespace, monk and OpenCode would both be eligible for the same Anthropic pin.
  # The namespace is garden-only; the handler/reputation resolver strip it back to
  # the underlying model so the two kind arms remain an apples-to-apples A/B.
  if [[ "$pin" == opencode-anthropic/* ]]; then
    [ "$KIND" = opencode-anthropic ] || return 1
    routed_model="${pin#opencode-anthropic/}"
    routed_model="$(resolve_model_tier anthropic "$routed_model")"
    [ -n "$routed_model" ] || return 1
    tier="$(model_dispatch_tier anthropic "$routed_model" 2>/dev/null || true)"
    [ "$tier" != mentat ] || [ "$(plan_field "$jf" dispatch)" = manual ] || ratchet_watcher_job "$jf" "$DIR" || return 1
    if job_provider_is_constrained "$jf"; then
      [ "$(job_provider_constraint "$jf" 2>/dev/null || true)" = anthropic ] || return 1
    fi
    return 0
  fi
  [ "$KIND" != opencode-anthropic ] || return 1
  tier="$(job_tier "$jf")" || {
    # An absent or unclassified historical model pin is unpinned work for the
    # established pools. Keep hosted pools opt-in: they require their explicit
    # supported pin and never absorb this compatibility traffic.
    [ "$KIND" != mystic ] && [ "$KIND" != fireworker ] && [ "$KIND" != openrouter ] \
      && [ "$KIND" != openrouter-promo ] && [ "$KIND" != opencode-anthropic ] && [ "$KIND" != friar ] \
      && ! job_provider_is_constrained "$jf" && return 0
    return 1
  }
  if job_provider_is_constrained "$jf"; then
    constrained_provider="$(job_provider_constraint "$jf")" || return 1
    [ "$constrained_provider" = "$KIND_PROVIDER" ] || return 1
  fi
  # Mentat is an authorization boundary, not merely a price point: it is
  # dispatchable on manual authority or the scoped ratchet watcher (this gate
  # is keyed on the tier string, never a provider — mentat is multi-provider like
  # mentor: Anthropic Fable/Mythos and OpenAI GPT-6 Astra both live at mentat).
  # Which providers may actually take a mentat job is decided provider-agnostically
  # by the backend-fit filter below (`tier_model_for_provider`), which admits only a
  # provider that has a model at this tier — so a provider without a mentat row
  # (moonshot/fireworks/local/…) still fails closed with no hardcoded allowlist.
  [ "$tier" != mentat ] || [ "$(plan_field "$jf" dispatch)" = manual ] || ratchet_watcher_job "$jf" "$DIR" || return 1
  # A concrete `model:` pin binds the job to the provider that owns that model,
  # so a multi-provider tier (mentor spans Opus 5 / Sol / Kimi) never lets a worker
  # claim a job pinned to a foreign provider's model. resolve_model_tier resolves the
  # pin (a short alias like `terra` or a concrete id like `kimi-k3`) to the concrete
  # id AND fails closed (empty) when this provider does not own it, which is exactly
  # the backend-fit filter. A tier-only job (no model pin) is claimable by any
  # provider that has a model at that tier.
  # Mystic is an opt-in canary lane: it never receives tier-only or unpinned
  # work, and must not take high-stakes design/build routing.  Capacity is the
  # operational kill switch; this predicate keeps an accidentally running unit
  # constrained to an explicit, ordinary K3 job.
  if [ "$KIND" = mystic ]; then
    [ "$pin" = kimi-k3 ] || return 1
    role="$(plan_field "$jf" role)"
    case "$role" in builder|designer) return 1;; esac
  fi
  # OpenRouter is an explicit-model-only lane (like mystic/fireworker): it claims ONLY
  # a job that names `provider: openrouter` OR pins an `openrouter/<wire-id>` model. A
  # bare tier-only or unpinned board job — including a reaper reroute to a tier that
  # OpenRouter happens to serve a model at (minion/myrmidon) — must NOT reach this
  # disabled-by-default provider (designs/openrouter-provider.md § disabled by default).
  # If the job is provider-constrained, the foreign-provider check above already
  # guaranteed the constraint is `openrouter`.
  if [ "$KIND" = openrouter ]; then
    job_provider_is_constrained "$jf" || [[ "$pin" == openrouter/* ]] || return 1
  fi
  # The promo (stealth) lane is likewise explicit-model-only: it claims ONLY a
  # `provider: openrouter-promo` canary OR an `openrouter-promo/<wire-id>` pin whose
  # id currently has a fresh attestation in the journal ledger (the pin's tier
  # resolution above already fails closed on a stale/absent attestation).  A stable
  # `openrouter/<id>` pin is a FOREIGN provider to this kind and was already left.
  if [ "$KIND" = openrouter-promo ]; then
    job_provider_is_constrained "$jf" || [[ "$pin" == openrouter-promo/* ]] || return 1
  fi
  # The friar is an explicit-model-only, PAID, metered lane (Claude Code against Ollama
  # Cloud): it never absorbs tier-only or unpinned work — that would spend the
  # maintainer's key on a job a flat-cost monk or a free hermit could take — and, like
  # mystic, it stays off high-stakes build/design routing until the arm has proven
  # itself. It claims ONLY a job that names `provider: ollama-cloud` OR pins a model;
  # the pin's provider-fit (that ollama-cloud actually owns the tag) is enforced by the
  # resolve_model_tier check below.
  if [ "$KIND" = friar ]; then
    job_provider_is_constrained "$jf" || [ -n "$pin" ] || return 1
    role="$(plan_field "$jf" role)"
    case "$role" in builder|designer) return 1;; esac
  fi
  if [ -n "$pin" ]; then
    [ -n "$(resolve_model_tier "$KIND_PROVIDER" "$pin")" ]
  else
    [ -n "$(tier_model_for_provider "$tier" "$KIND_PROVIDER")" ]
  fi
}

# The per-instance clone seam: the kind-neutral GARDEN_WORKER_CLONE the spine exports.
DIR="${GARDEN_WORKER_CLONE:-$GARDEN_STATE/monks/$id/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# The claim is the universal admission surface: it knows the actual worker host
# and provider that will pay for the job. Decline the whole claim tick on a
# confirmed high-water reading, or when its meter has stayed unreadable beyond a
# short grace period. The grace preserves fail-open behavior for a brief sensor
# blip without letting a dead meter admit unbounded new work indefinitely.
if ! CLAIM_POOL="$(budget_subscription_for_host_kind "$GARDEN" "$KIND" "$DIR" 2>/dev/null)"; then
  if [ "${GARDEN_TEST:-0}" = 1 ] && ! budget_pool_file "$DIR" >/dev/null 2>&1; then
    # Legacy hermetic board fixtures intentionally omit all budget state. Their
    # subject is board mechanics, not subscription admission.
    CLAIM_POOL="$KIND_PROVIDER"
  else
  case "$KIND_PROVIDER" in
    anthropic|openai|openrouter|openrouter-promo|ollama-cloud)
      CLAIM_POOL="unknown:$KIND_PROVIDER:$GARDEN:$KIND"
      ;;
    *)
      # Local inference has no external refill pool and is outside the closed
      # subscription registry by construction.
      CLAIM_POOL="$KIND_PROVIDER"
      ;;
  esac
  fi
fi
# Every claimer of one worker kind on this host re-runs admission each tick, so a
# pool in backoff would otherwise commit an identical decline per worker per tick
# (~2,200 journal commits/day from one cleric pool, 2026-09-27).  Record only when
# the admission decision for this host's worker kind changes, plus the ledger's
# heartbeat, and forget it when the pool admits again.
CLAIM_DECISION_KEY="claim-admission-$KIND"
CLAIM_SENSOR_GRACE="${GARDEN_BUDGET_SENSOR_OUTAGE_GRACE_SECS:-300}"
case "$CLAIM_SENSOR_GRACE" in
  ''|*[!0-9]*) log "WARNING: GARDEN_BUDGET_SENSOR_OUTAGE_GRACE_SECS='$CLAIM_SENSOR_GRACE' is not a count of seconds; using 300"; CLAIM_SENSOR_GRACE=300 ;;
esac
# All workers charged to one pool share this host-local episode timer. Include a
# digest after the readable prefix so two pool names that sanitize alike cannot
# share an outage. noclobber below makes the first observation win when sibling
# claimers discover the outage concurrently.
CLAIM_SENSOR_KEY="${CLAIM_POOL//[^A-Za-z0-9._-]/_}-$(printf '%s' "$CLAIM_POOL" | sha256sum | cut -c1-12)"
CLAIM_SENSOR_DIR="$GARDEN_STATE/budget-sensor-outages/$CLAIM_SENSOR_KEY"
CLAIM_SENSOR_SINCE="$CLAIM_SENSOR_DIR/since"
claim_sensor_now() {
  local now="${GARDEN_BUDGET_SENSOR_NOW:-$(date -u +%s)}"
  case "$now" in ''|*[!0-9]*) now="$(date -u +%s)" ;; esac
  printf '%s\n' "$now"
}
claim_sensor_outage_age() { # prints the persistent episode age
  local now since
  now="$(claim_sensor_now)"
  mkdir -p "$CLAIM_SENSOR_DIR"
  if [ ! -s "$CLAIM_SENSOR_SINCE" ]; then
    ( set -o noclobber; printf '%s\n' "$now" > "$CLAIM_SENSOR_SINCE" ) 2>/dev/null || true
  fi
  since="$(cat "$CLAIM_SENSOR_SINCE" 2>/dev/null || echo "$now")"
  case "$since" in ''|*[!0-9]*) since="$now"; printf '%s\n' "$since" > "$CLAIM_SENSOR_SINCE" ;; esac
  [ "$now" -ge "$since" ] || since="$now"
  printf '%s\n' "$(( now - since ))"
}
clear_claim_sensor_outage() {
  rm -f -- "$CLAIM_SENSOR_SINCE"
  rmdir -- "$CLAIM_SENSOR_DIR" 2>/dev/null || true
}
record_claim_budget_decision() { # status decision outcome reason detail
  local status="$1" decision_name="$2" decision_outcome="$3"
  local decision_reason="$4" decision_detail="$5" decision_input_json
  if decision_input_json="$(jq -cn --arg pool "$CLAIM_POOL" \
    --arg provider "$KIND_PROVIDER" --arg host "$GARDEN" \
    --arg worker_kind "$KIND" --arg status "$status" \
    '{pool:$pool,provider:$provider,host:$host,worker_kind:$worker_kind,status:$status,sensor:"budget-pool"}')"; then
    record_decision --loop claim-admission --input-json "$decision_input_json" \
      --decision "$decision_name" --reason "$decision_reason" \
      --outcome "$decision_outcome" --outcome-detail "$decision_detail" \
      --record-on-change "$CLAIM_DECISION_KEY"
  fi
}
if claim_budget_status="$(pool_admits "$CLAIM_POOL" "$DIR")"; then
  if [ "$claim_budget_status" = unknown ]; then
    claim_sensor_age="$(claim_sensor_outage_age)"
    if [ "$claim_sensor_age" -ge "$CLAIM_SENSOR_GRACE" ]; then
      log "budget pool '$CLAIM_POOL' sensor has been unreadable for ${claim_sensor_age}s; declining this claim tick (grace ${CLAIM_SENSOR_GRACE}s exhausted)"
      alert_maintainer "budget-sensor-outage-$CLAIM_SENSOR_KEY" \
        "claim gate is FAIL-CLOSED on $GARDEN after budget pool '$CLAIM_POOL' stayed unreadable for ${claim_sensor_age}s (grace ${CLAIM_SENSOR_GRACE}s). No new job will be claimed from this pool until its budget sensor recovers. Check the pool's usage logs/live snapshots and budget-pools mapping."
      record_claim_budget_decision unknown decline-claim applied \
        "budget sensor outage exceeded its fail-open grace period" \
        "sensor unreadable for ${claim_sensor_age}s; claim tick stopped before candidate selection"
      exit 3
    fi
    log "WARN: budget pool '$CLAIM_POOL' unreadable for ${claim_sensor_age}s; claims remain open during ${CLAIM_SENSOR_GRACE}s grace"
    record_claim_budget_decision unknown allow-claim fail-open-skipped \
      "budget sensor briefly unreadable; admission grace remains" \
      "sensor unreadable for ${claim_sensor_age}s; candidate selection continues"
  else
    clear_claim_sensor_outage
    clear_decision_change "$CLAIM_DECISION_KEY"
  fi
elif [ "$claim_budget_status" = refuse ]; then
  clear_claim_sensor_outage
  # FAIL CLOSED: an unknown source, or a configured subscription with no trustworthy
  # ceiling, halts claims rather than admitting unbounded spend. This CAN
  # silently wedge a host, so make the halt LOUD and the remedy OBVIOUS: page the
  # maintainer once (alert_maintainer dedups the repeated tick) with the exact
  # set-budget-pool.sh command that clears it.
  remedy="$(pool_admission_refusal "$CLAIM_POOL" "$DIR" 2>/dev/null || true)"
  log "budget pool '$CLAIM_POOL' refuses admission (fail-closed): ${remedy:-untrusted ceiling}"
  alert_maintainer "budget-pool-refuse-$CLAIM_POOL" \
    "claim gate is FAIL-CLOSED on $GARDEN: ${remedy:-budget pool $CLAIM_POOL has no trustworthy ceiling}. No job will be claimed on this host until a calibrated cap is set."
  record_claim_budget_decision refuse decline-claim applied \
    "configured pool has no trustworthy ceiling" \
    "${remedy:-claim tick stopped before candidate selection}"
  exit 3
else
  clear_claim_sensor_outage
  log "budget pool '$CLAIM_POOL' is at its high-water mark; declining this claim tick"
  record_claim_budget_decision backoff decline-claim applied \
    "budget pool is at its configured high-water mark" \
    "claim tick stopped before candidate selection"
  exit 3
fi

# Candidate ordering: start at an id-derived offset so N gardeners don't all
# grab the lexically-first job and collide on every claim.
mapfile -t cand < <(list_jobs "$DIR" "$JOBS_TODO")
n="${#cand[@]}"
[ "$n" -eq 0 ] && { log "no jobs in todo"; exit 3; }

# A plain non-productive exit earns one retry, but only after the reaper's
# recorded back-off.  Use one clock reading for the whole candidate pass so two
# candidates on the same boundary cannot be treated inconsistently.  The test
# override is also useful for deterministic boundary coverage.
claim_now="${GARDEN_CLAIM_NOW:-$(date -u +%s)}"
case "$claim_now" in
  ''|*[!0-9]*) log "WARNING: GARDEN_CLAIM_NOW='$claim_now' is not an epoch; using wall clock"; claim_now="$(date -u +%s)" ;;
esac

# numeric offset from id (hash non-numeric ids)
if [[ "$id" =~ ^[0-9]+$ ]]; then off="$id"; else off=$(( $(printf '%s' "$id" | cksum | cut -d' ' -f1) )); fi
off=$(( off % n ))

# Rolling-deploy canary probes go FIRST, ahead of the offset rotation. A released
# canary is often a single-worker host; if its one worker races an ordinary
# multi-hour job ahead of the probe, the probe misses its deadline and the whole
# roll halts on a healthy canary (2026-09-29: garden2 took a 7200s gauntlet fix one
# second after probe r1 landed; r1..r3 all expired). Host eligibility is still
# decided by the ordinary requires: gate below.
#
# Aged jobs go next, still ahead of the rotation. Rotation alone gives no job a
# bound on its wait: a job whose position every live worker's offset reaches late
# can sit unclaimed while newer jobs are taken around it (2026-10-11: PR 171's
# panel-7 waited 12 hours). A job that has sat in todo/ longer than the threshold
# is tried before any younger one; within the aged tier the worker's rotation is
# kept so peers still spread across several aged jobs instead of all colliding on
# one. Age is the `posted_at:` header when present, else the commit that added the
# file to todo/ (renames off, so a requeue restarts the clock). One bounded log
# walk over the threshold window finds the young set; everything else is aged. A
# clone whose history is shorter than the window reads every header-less job as
# aged, which degrades to the plain rotation. Eligibility is still decided per
# candidate below, so an aged job this host cannot run is skipped as before.
CLAIM_AGING_SECONDS="${GARDEN_CLAIM_AGING_SECONDS:-3600}"
case "$CLAIM_AGING_SECONDS" in
  ''|*[!0-9]*) log "WARNING: GARDEN_CLAIM_AGING_SECONDS='$CLAIM_AGING_SECONDS' is not a count of seconds; using 3600"; CLAIM_AGING_SECONDS=3600 ;;
esac
aging_cutoff=$(( claim_now - CLAIM_AGING_SECONDS ))
declare -A young=()
if [ "$CLAIM_AGING_SECONDS" -gt 0 ]; then
  while IFS= read -r path; do
    [ -n "$path" ] && young["${path##*/}"]=1
  done < <(git -C "$DIR" log --no-renames --diff-filter=A --format= --name-only \
             --since="@$aging_cutoff" -- "$JOBS_TODO" 2>/dev/null || true)
fi
job_is_aged() { # <leaf>
  local posted epoch
  [ "$CLAIM_AGING_SECONDS" -gt 0 ] || return 1
  posted="$(plan_field "$DIR/$JOBS_TODO/$1" posted_at 2>/dev/null || true)"
  if [ -n "$posted" ] && epoch="$(date -u -d "$posted" +%s 2>/dev/null)"; then
    [ "$epoch" -le "$aging_cutoff" ]
    return
  fi
  [ -z "${young[$1]:-}" ]
}

probes=(); aged=(); rest=()
for ((k=0; k<n; k++)); do
  c="${cand[$(( (off + k) % n ))]}"
  if grep -q '^canary-probe: true' "$DIR/$JOBS_TODO/$c" 2>/dev/null; then
    probes+=("$c")
  elif job_is_aged "$c"; then
    aged+=("$c")
  else
    rest+=("$c")
  fi
done
[ "${#aged[@]}" -gt 0 ] && log "${#aged[@]} job(s) in todo/ past the ${CLAIM_AGING_SECONDS}s aging threshold; trying them before the rotation"
cand=("${probes[@]}" "${aged[@]}" "${rest[@]}")

# A canary probe posted AFTER this pass took its snapshot preempts the rest of the
# pass. Under journal contention each lost race costs minutes, so a pass over a dozen
# aged jobs can run for half an hour while the probe's deadline expires unseen
# (oros 2026-10-14: five idle monks spent 00:18-00:42 losing every race on 12 aged
# jobs; probes r1 and r2 for 242f944c were never tried and the roll drained a
# healthy canary). Checked after each re-sync, so the probe waits at most one attempt.
declare -A in_pass=()
for c in "${cand[@]}"; do in_pass["$c"]=1; done
late_canary_probe() {
  local f leaf
  for f in "$DIR/$JOBS_TODO"/*.md; do
    leaf="${f##*/}"
    [ -z "${in_pass[$leaf]:-}" ] || continue
    grep -q '^canary-probe: true' "$f" 2>/dev/null || continue
    printf '%s\n' "$leaf"; return 0
  done
  return 1
}

while [ "${#cand[@]}" -gt 0 ]; do
  # candidates are leaf filenames (<base>.md); the spine key is extensionless.
  leaf="${cand[0]}"; cand=("${cand[@]:1}")
  base="${leaf%.md}"
  if own_worker_stopping; then
    log "this worker's unit is stopping; abandoning the claim pass before '$base'"
    exit 3
  fi
  # re-sync each attempt: the board may have moved under us
  sync_clone "$DIR"
  if late="$(late_canary_probe)"; then
    in_pass["$late"]=1; n=$((n + 1))
    cand=("$leaf" "${cand[@]}")
    base="${late%.md}"
    log "canary probe '$base' appeared mid-pass; trying it next"
  fi
  [ -e "$DIR/$JOBS_TODO/$base.md" ] || { log "'$base' already taken; next"; continue; }

  retry_not_before="$(plain_retry_not_before "$DIR/$JOBS_TODO/$base.md" 2>/dev/null || true)"
  if [ -n "$retry_not_before" ]; then
    retry_not_before_epoch="$(date -u -d "$retry_not_before" +%s 2>/dev/null || true)"
    if [[ "$retry_not_before_epoch" =~ ^[0-9]+$ ]] \
       && [ "$claim_now" -lt "$retry_not_before_epoch" ]; then
      log "'$base' is in its sole plain-exit retry back-off until $retry_not_before; skipping"
      continue
    fi
  fi

  # BOATMAN LOCKOUT (job dedicated-ferry-dispatch). Ferry work is dispatched ONLY
  # by scripts/ferry.sh off the dedicated jobs/ferry/ board, NEVER the generic job
  # board — it crosses into the maintainer's identity on the one credentialed host,
  # so it must not be race-claimed by an arbitrary gardener and run under the bot pin.
  # A `role: boatman` job here is a MIS-POST: refuse to claim it (mechanically, not by
  # convention — the comment-provenance.sh principle: move the responsibility into
  # code) and alert LOUDLY rather than silently dropping it. The unclaimed job stays
  # visibly in todo/ and the maintainer is paged (deduped per base). See
  # roles/boatman/AGENT.md and CLAUDE.md § The ferry.
  if [ "$(plan_role "$DIR/$JOBS_TODO/$base.md")" = boatman ]; then
    log "'$base' carries role: boatman — REFUSING to claim; ferry dispatch is scripts/ferry.sh only, never the board"
    alert_maintainer "boatman-job-on-board-$base" \
      "A 'role: boatman' job ('$base') is on the generic job board, but the boatman is dispatched ONLY by scripts/ferry.sh off jobs/ferry/ (job dedicated-ferry-dispatch). No gardener will claim it. Remove it from the board and stage the ferry as a jobs/ferry/ directive instead. See roles/boatman/AGENT.md and CLAUDE.md § The ferry."
    continue
  fi

  # §1.3 backend-fit filter: skip a job pinned to a provider this kind cannot honor.
  if ! job_eligible_for_kind "$DIR/$JOBS_TODO/$base.md"; then
    log "'$base' is pinned to a model this $KIND ($KIND_PROVIDER) cannot honor; skipping (backend-fit)"
    continue
  fi

  # Host requirements are an independent eligibility axis from model/provider
  # fit.  The shared predicate is also re-run freshly after a successful claim by
  # gardener.sh, because a credential can lapse between these two moments.
  if ! job_requirements_available "$DIR/$JOBS_TODO/$base.md"; then
    missing="$(job_requirements_missing "$DIR/$JOBS_TODO/$base.md")"
    log "'$base' requires host capability ${missing:-invalid-requires-header}; skipping (host-requirements)"
    continue
  fi

  # Learned review-write exclusion (review-write-deny.sh): this host's token got a
  # token-grant 403 posting a PR review for this owner, so a panel/undraft stage
  # for it would spend its fan-out and fail at the post. Leave it for a capable
  # host. Host-local state only; nothing about the credential reaches the journal.
  if deny_owner="$(job_review_write_denied_owner "$DIR/$JOBS_TODO/$base.md")"; then
    log "'$base' posts a PR review for '$deny_owner', which this host's token cannot write (learned 403); skipping (review-write)"
    continue
  fi

  # Project-pause chokepoint (designs/project-pause-enforcement.md). Defense in depth:
  # even if a stale producer already POSTED a paused-project job onto the board, no
  # worker claims it. A claimable paused job means the post gate was bypassed (a stale
  # host), so alert — coalesced per project through note_project_pause_block, never one
  # message per candidate. Skip like the backend-fit filter; other candidates may claim.
  if pause_slug="$(project_pause_hit "$DIR" "$base" "$DIR/$JOBS_TODO/$base.md")"; then
    log "'$base' belongs to PAUSED project '$pause_slug'; refusing to claim (project-pause)"
    note_project_pause_block "$DIR" "$pause_slug" "a claimable todo job '$base' on the board"
    continue
  fi

  # --- bid auction (design §3) -------------------------------------------------
  # A `market: bid` job runs through the auction; everything else is the untouched
  # race below. The auction NEVER bypasses the push CAS: it only decides WHETHER
  # this worker should attempt the todo→doin push right now. While the bid window
  # is open the worker writes its own bid (a separate per-bidder push) and moves on
  # WITHOUT claiming; after the window closes it claims only if the deterministic
  # award rule + staged eligibility (auction_eligible_now) says it may. Whoever's
  # claim push is accepted still owns the job exactly once — a mis-timed push is at
  # worst a mis-award, never a double-award or a lost job.
  awarded_bidder=""; awarded_provider=""; awarded_model=""; awarded_tht=""
  jf="$DIR/$JOBS_TODO/$base.md"
  if [ "$(auction_market_mode "$jf")" = bid ]; then
    bidder="$(auction_bidder_id "$KIND" "$id")"
    if auction_window_open "$DIR" "$base" "$jf"; then
      # Bidding phase: ensure our bid is committed (idempotent), then move on — the
      # claim happens on a later tick once the window closes. auction_write_bid does
      # its own commit_and_push (releasing the clone lock); the next candidate's
      # sync_clone re-takes it.
      if auction_write_bid "$DIR" "$base"; then
        log "bid on '$base' as $bidder (window open); not claiming yet"
      else
        log "bid push on '$base' lost a race; will retry next tick"
      fi
      continue
    fi
    if ! auction_eligible_now "$DIR" "$base" "$jf" "$bidder"; then
      log "'$base' auction closed but $bidder not yet eligible to claim (staged widening); skipping"
      continue
    fi
    awarded_bidder="$bidder"
    { read -r awarded_provider; read -r awarded_model; read -r awarded_tht; } < <(rep_resolve_arm "$KIND" "$jf")
    log "'$base' auction: $bidder is eligible; claiming (committed arm $awarded_provider/$awarded_model/$awarded_tht)"
  fi

  # A canary probe's claim replays a lost CAS onto the fresh tip without the
  # worktree (journal_replay_head) instead of falling back to the next candidate.
  # On a slow clone every claim is decided at a tip ~90s old and loses to any peer
  # write, so the probe never left todo/ and the roll failed a healthy canary (oros
  # 2026-10-14 00:52-01:04Z: five idle monks lost r2 and r3, every loss `cas`, then
  # the roll re-drained the host). The replay stays a CAS on the claim's own paths:
  # it is refused once a peer claimed, the roller withdrew, or anyone edited the
  # probe's todo/ file. Ordinary claims keep re-deriving from the fresh tip.
  claim_replay="${GARDEN_JOURNAL_REPLAY_ATTEMPTS:-0}"
  grep -q '^canary-probe: true' "$jf" 2>/dev/null && claim_replay="${GARDEN_CLAIM_PROBE_REPLAY_ATTEMPTS:-3}"

  mkdir -p "$DIR/$JOBS_DOIN" "$DIR/work"
  git -C "$DIR" mv "$JOBS_TODO/$base.md" "$JOBS_DOIN/$base.md"
  claimed_at="$(date -u +%FT%TZ)"
  # stamp claim metadata into the job file (appended; the body is preserved). The
  # worker_kind is recorded so tada reports, usage rows, and (build child 2)
  # reputation events know which backend did the work.
  {
    printf '\n---\nclaim:\n'
    printf '  host: %s\n'      "$GARDEN"
    printf '  gardener: %s\n'  "$id"
    printf '  worker_kind: %s\n' "$KIND"
    printf '  tier: %s\n' "$(job_tier "$jf")"
    printf '  provider: %s\n' "$KIND_PROVIDER"
    printf '  model: %s\n' "$(tier_model_for_provider "$(job_tier "$jf")" "$KIND_PROVIDER")"
    printf '  claimed_at: %s\n' "$claimed_at"
    # Auction provenance (empty for a race claim). awarded_bid is the winning
    # bidder; the committed arm is stamped so the reputation event (§4.5) keys the
    # outcome to exactly the (kind, provider, model, thoughtfulness) that ran.
    if [ -n "$awarded_bidder" ]; then
      printf '  awarded_bid: %s\n'      "$awarded_bidder"
      printf '  awarded_provider: %s\n' "$awarded_provider"
      printf '  awarded_model: %s\n'    "$awarded_model"
      printf '  awarded_thoughtfulness: %s\n' "$awarded_tht"
    fi
  } >> "$DIR/$JOBS_DOIN/$base.md"
  # worktree-state record under work/ (the spine: same basename). worktree_dir
  # names the REAL per-job garden worktree (handlers/monk-claude.sh's
  # gardener-wt-<base> under GARDEN_SCRATCH) for a human inspecting the claim;
  # it is INFORMATIONAL ONLY — worktrees persist across a requeue so a resumed
  # claim re-enters its in-flight work, and nothing may delete them from board
  # state (orphans age out via the reaper's scratch janitor).
  {
    printf 'host: %s\n'         "$GARDEN"
    printf 'gardener: %s\n'     "$id"
    printf 'worker_kind: %s\n'  "$KIND"
    printf 'claimed_at: %s\n'   "$claimed_at"
    printf 'worktree_dir: %s\n' "${GARDEN_SCRATCH:-$GARDEN_ROOT/scratch}/gardener-wt-$base"
  } > "$DIR/work/$base"
  # create this job doer's inbox (unread/read), alive for the job's lifetime.
  mkdir -p "$DIR/inbox/$base/unread" "$DIR/inbox/$base/read"
  touch "$DIR/inbox/$base/unread/.gitkeep" "$DIR/inbox/$base/read/.gitkeep"
  git -C "$DIR" add "$JOBS_DOIN/$base.md" "work/$base" "inbox/$base"

  if GARDEN_JOURNAL_REPLAY_ATTEMPTS="$claim_replay" commit_and_push "$DIR" "claim($base) $GARDEN/$KIND-$id"; then
    log "claimed '$base'"
    printf '%s\n' "$base"
    exit 0
  fi

  log "lost claim race on '$base'; backing off to next candidate"
  # do NOT retry the same job; loop picks the next candidate after re-sync
done

log "could not claim any of $n candidates (all taken)"
exit 3
