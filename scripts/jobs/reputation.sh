#!/bin/bash
# reputation.sh — reputation as journal data + the deterministic bid math.
#
# This is the DATA + MATH half of the decentralized bid auction (design
# cleric-worker-bid-auction-reputation.md §4–§5). auction.sh is the PROTOCOL half
# (bid window, award rank, staged eligibility) and sources this file. Both are
# sourced AFTER common.sh — they use its helpers (log, plan_field, JOBS_*,
# resolve_model_tier, role_default_model/effort, worker_kind_field) and never
# re-source it. Source-once guarded.
#
# Everything here is DETERMINISTIC and LLM-FREE by construction (§3.1 invariant 1):
# a reputation is a distribution over aggregate dollars to a merge-worthy artifact
# per arm × work-class × target (§4.1), and a bid is a seeded Thompson draw over
# that distribution (§3.2). "Seeded" means keyed on a hash of the job base and the
# arm, so the SAME journal state yields the SAME draw on every host — the ranking
# is reproducible and auditable from the journal alone, and no `Math.random` /
# `awk rand()` (whose implementation varies across hosts) is ever used. All
# floating-point is POSIX awk arithmetic; all randomness is sha1sum-derived, so
# both are byte-identical across gardeners and clerics on any host.

[ -n "${GARDEN_REPUTATION_SH_SOURCED:-}" ] && return 0
GARDEN_REPUTATION_SH_SOURCED=1

# --- journal layout (relative to a journal clone root) -----------------------
# All reputation state lives under reputation/. The auction's transient bid files
# live under jobs/bids/ (auction.sh) alongside the lifecycle dirs.
REP_ROOT="reputation"
REP_EVENTS="$REP_ROOT/events"        # one event per completed base (single-writer: its own worker)
REP_PENDING="$REP_ROOT/pending"      # completed but acceptance not yet known (finalized by the reducer)
REP_ARMS="$REP_ROOT/arms"            # derived projections — recomputed by the reducer ONLY
REP_VERDICTS="$REP_ROOT/verdicts"    # optional per-base acceptance override (a maintainer/PR signal drop)

# --- config (all env-overridable; the journal rate-card/auction config, when it
# exists, is layered on top by the reducer, but the DEFAULTS live here so the
# system is self-contained and testable without any journal config present) ----
: "${GARDEN_AUCTION_COLD_N:=5}"          # attempts below which an arm draws from the cold prior
: "${GARDEN_REP_COLD_MEAN:=10}"          # cold-start prior mean, aggregate $ to a merge-worthy artifact
: "${GARDEN_REP_COLD_SD:=20}"            # cold-start prior sd — WIDE so a cold arm explores (§3.3)
: "${GARDEN_REP_VAR_FLOOR:=0.25}"        # variance floor for a thin-but-warm arm (sd >= 0.5)
: "${GARDEN_REP_MIN_DRAW:=0.01}"         # floor a Thompson draw here (dollars are strictly positive)
# Human-review dollar inference constants (§4.4). Config, not code; a measured
# review-time instrument supersedes these per-change without churn.
: "${GARDEN_REP_HOURLY_RATE:=125}"       # $/hr for inferred human-review time
: "${GARDEN_REP_REVIEW_BASE_MIN:=5}"     # minutes of review per round, baseline
: "${GARDEN_REP_REVIEW_WPM:=20}"         # words/min a reviewer WRITES (reads far more)

# --- small deterministic primitives ------------------------------------------

# rep_sanitize <s> — collapse anything outside [A-Za-z0-9._-] to '-' so an arm key
# component (a model id, a work_class carrying ':') is a safe single path segment.
rep_sanitize() { printf '%s' "${1:-}" | tr -c 'A-Za-z0-9._-' '-'; }

# rep_seed_int <string> — a stable 32-bit unsigned integer from a string, identical
# on every host (cksum is CRC-32, POSIX). Used only where an integer seed is wanted;
# the Thompson uniforms use rep_seed_uniform (sha1-derived) for a wider space.
rep_seed_int() { printf '%s' "${1:-}" | cksum | cut -d' ' -f1; }

# rep_seed_uniform <seed-string> <index> — a deterministic uniform in (0,1), the
# same on every host: sha1( "<seed>:<index>" ), take 8 hex chars → integer →
# (d+0.5)/2^32. sha1sum is byte-identical everywhere (unlike awk rand()); the +0.5
# keeps it strictly inside (0,1) so log(u1) in Box–Muller never hits log(0).
rep_seed_uniform() {
  local h d
  h="$(printf '%s:%s' "${1:-}" "${2:-0}" | (sha1sum 2>/dev/null || shasum) | cut -c1-8)"
  d=$((16#$h))
  awk -v d="$d" 'BEGIN{ printf "%.10f", (d+0.5)/4294967296.0 }'
}

# rep_thompson_draw <attempts> <mean_dollars> <m2> <accepts> <seed-string>
# One deterministic Thompson-sampling draw from an arm's aggregate-dollar posterior
# (§3.2 step 1). A COLD arm — fewer than cold_n attempts, or never yet accepted —
# draws from the WIDE cold-start prior so it still occasionally draws lowest and
# wins a measuring job (exploration; §3.3). A WARM arm draws from a normal centered
# on its cost-per-accepted mean, with variance inflated by the acceptance rate
# (delta method: cost/accepted = per-attempt/rate, so var scales ~1/rate²), floored
# for thin arms. The lower the draw, the cheaper-to-merge this arm looks THIS time.
# Prints the drawn aggregate-dollar figure (floored at min_draw; dollars are > 0).
rep_thompson_draw() {
  local att="${1:-0}" mean="${2:-0}" m2="${3:-0}" acc="${4:-0}" seed="${5:-}"
  local u1 u2
  u1="$(rep_seed_uniform "$seed" 1)"
  u2="$(rep_seed_uniform "$seed" 2)"
  awk -v att="$att" -v mean="$mean" -v m2="$m2" -v acc="$acc" -v u1="$u1" -v u2="$u2" \
      -v cn="$GARDEN_AUCTION_COLD_N" -v cm="$GARDEN_REP_COLD_MEAN" -v csd="$GARDEN_REP_COLD_SD" \
      -v vf="$GARDEN_REP_VAR_FLOOR" -v md="$GARDEN_REP_MIN_DRAW" 'BEGIN{
    pi = 3.141592653589793;
    if ((att+0) < (cn+0) || (acc+0) < 1) {
      mu = cm+0; sd = csd+0;                     # cold prior — wide, explores
    } else {
      mu = mean+0;
      rate = (acc+0)/(att+0);
      if ((att+0) >= 2) va = (m2+0)/((att+0)-1); else va = 0;
      v = va/(rate*rate);                        # inflate per-attempt var by 1/rate²
      if (v < (vf+0)) v = vf+0;
      sd = sqrt(v);
    }
    z = sqrt(-2*log(u1)) * cos(2*pi*u2);         # Box–Muller standard normal
    d = mu + sd*z;
    if (d < (md+0)) d = md+0;
    printf "%.6f", d;
  }'
}

# --- work-class classification (§4.3) ----------------------------------------
# Deterministic, no LLM, at post/claim time from data the job already carries.
#   work_class = <class>[:<size>]
#     class: design|build|fix|shepherd|weave|triage|doc|ops|other
#     size:  s|m|l  (byte-length buckets of the job body)
# A producer may override the whole thing with an explicit `work-class:` header.
: "${GARDEN_REP_SIZE_S_MAX:=800}"        # body bytes <= this -> small
: "${GARDEN_REP_SIZE_M_MAX:=3000}"       # body bytes <= this -> medium; else large

rep_class_from_role() {   # rep_class_from_role <role-or-verb>
  case "${1:-}" in
    design*|propose|spec) printf 'design\n' ;;
    build*|probe)         printf 'build\n' ;;
    fix*|retcon)          printf 'fix\n' ;;
    shepherd)             printf 'shepherd\n' ;;
    weav*|rebase)         printf 'weave\n' ;;
    triag*)               printf 'triage\n' ;;
    doc*|journalist|librarian) printf 'doc\n' ;;
    ops|conductor|boatman|pages-shepherd) printf 'ops\n' ;;
    '' ) printf 'other\n' ;;
    * )  printf '%s\n' "${1}" ;;   # a recognized-but-unmapped role keys as itself
  esac
}

rep_work_class() {   # rep_work_class <jobfile>
  local jf="${1:?rep_work_class: jobfile}" explicit role bytes size cls
  explicit="$(plan_field "$jf" work-class)"
  [ -n "$explicit" ] && { printf '%s\n' "$explicit"; return 0; }
  role="$(plan_role "$jf")"
  cls="$(rep_class_from_role "$role")"
  # size bucket from the body byte length (a crude but deterministic complexity proxy)
  bytes="$(wc -c < "$jf" 2>/dev/null | tr -dc '0-9')"; bytes="${bytes:-0}"
  if   [ "$bytes" -le "$GARDEN_REP_SIZE_S_MAX" ]; then size=s
  elif [ "$bytes" -le "$GARDEN_REP_SIZE_M_MAX" ]; then size=m
  else size=l; fi
  printf '%s:%s\n' "$cls" "$size"
}

# rep_target <jobfile> — the merge bar the acceptance is judged against (§4.2). A
# job carrying an explicit `target:` header uses it; a job naming a fork PR could
# key off the fork's default branch (a later refinement); a garden-internal job
# defaults to main2 (the branch this fleet lands on directly).
rep_target() {
  local t; t="$(plan_field "${1:?rep_target: jobfile}" target)"
  printf '%s\n' "${t:-main2}"
}

# --- the arm (§4.2): (worker_kind, provider, model, thoughtfulness) ----------
# rep_resolve_arm <kind> <jobfile> — the arm this worker WOULD actually run for the
# job, resolved by the SAME precedence the handlers use (explicit model:/effort:
# header, else the per-kind role default, else the fleet default). Returning the
# executed arm (rather than enumerating hypothetical (model,thoughtfulness) pairs)
# keeps the committed arm == the run arm with no handler change; enumerating a
# thoughtfulness LADDER per unpinned job so the market LEARNS the cheapest adequate
# level (§5) is a clean follow-up gated on the handlers reading an awarded arm.
# Prints three lines: provider, model, thoughtfulness.
rep_resolve_arm() {
  local kind="${1:?rep_resolve_arm: kind}" jf="${2:?rep_resolve_arm: jobfile}"
  local provider="" model="" effort="" role="" req_model="" req_effort=""
  provider="$(worker_kind_field "$kind" provider 2>/dev/null || echo anthropic)"
  role="$(plan_role "$jf")"
  req_model="$(plan_field "$jf" model)"
  req_effort="$(plan_field "$jf" effort)"
  if [ -n "$req_model" ]; then
    model="$(resolve_model_tier "$provider" "$req_model")"
  fi
  [ -n "$model" ] || model="$(role_default_model "$kind" "$role")"
  # Fleet default when still unresolved: openai and local read their concrete
  # default from the journal-backed routing table (model_routing_default), so a
  # fleet-default change is a journal data edit, not a code edit. The claude
  # headerless default is not a knowable id here, so key it by a stable sentinel.
  if [ -z "$model" ]; then
    case "$provider" in
      openai) model="$(model_routing_default openai 2>/dev/null)"; [ -n "$model" ] || model="gpt-5.6-terra" ;;
      local)  model="$(model_routing_default local  2>/dev/null)"; [ -n "$model" ] || model="qwen3:0.6b" ;;
      fireworks) model="fireworks-unconfigured" ;;
      *)      model="claude-default" ;;
    esac
  fi
  effort="$req_effort"; [ -n "$effort" ] || effort="$(role_default_effort "$kind" "$role")"
  printf '%s\n%s\n%s\n' "$provider" "$model" "$effort"
}

# rep_arm_relpath <kind> <provider> <model> <thoughtfulness> <work_class> <target>
# The journal-relative projection path for one arm × work-class × target. Each path
# component is sanitized to a safe single segment.
rep_arm_relpath() {
  local kind p m t wc tgt
  kind="$(rep_sanitize "$1")"; p="$(rep_sanitize "$2")"; m="$(rep_sanitize "$3")"
  t="$(rep_sanitize "$4")";   wc="$(rep_sanitize "$5")"; tgt="$(rep_sanitize "$6")"
  printf '%s/%s/%s/%s/%s/%s@%s.md\n' "$REP_ARMS" "$kind" "$p" "$m" "$t" "$wc" "$tgt"
}

# rep_read_projection <dir> <arm-relpath> — read a committed arm projection, echo
# five space-separated fields: attempts accepts mean_dollars m2 censored. A missing
# projection reads as all-zero (a cold arm). Robust to a partially-written file
# (missing fields default to 0). Reads from the working tree of <dir>.
rep_read_projection() {
  local dir="${1:?}" rel="${2:?}" f="$1/$2" att acc mean m2 cen
  if [ -f "$f" ]; then
    att="$(plan_field "$f" attempts)";     acc="$(plan_field "$f" accepts)"
    mean="$(plan_field "$f" mean_dollars)"; m2="$(plan_field "$f" m2)"
    cen="$(plan_field "$f" censored)"
  fi
  printf '%s %s %s %s %s\n' "${att:-0}" "${acc:-0}" "${mean:-0}" "${m2:-0}" "${cen:-0}"
}

# --- agentic-dollar rollup (§4.4) --------------------------------------------
# rep_agentic_dollars <dir> <base> — sum notional dollars for every engagement of
# <base> from usage/<base>.jsonl (the token-cost-ledger CostRecord; each line a
# JSON object with a `dollars` number). Prints the summed dollars, or the literal
# `censored` when the ledger is absent/unreadable/empty — fail-open, exactly as
# §2.3 requires (absent usage never blocks completion; the sample is cost-censored
# and excluded from the dollar mean but still counts toward the acceptance rate).
# The token-capture pipeline (tada-token-accounting / token-cost-ledger, §2.3) is a
# sibling design not yet wired, so today this censors on nearly every real job; the
# reducer's `censored:` counter surfaces that, and the auction runs pure-exploration
# (cold priors) until the ledger lands, which is the correct shadow-phase behavior.
rep_agentic_dollars() {
  local dir="${1:?}" base="${2:?}" f="$1/usage/$2.jsonl" sum
  [ -f "$f" ] || { printf 'censored\n'; return 0; }
  sum="$(awk '
    { if (match($0, /"dollars"[[:space:]]*:[[:space:]]*[0-9.]+/)) {
        s=substr($0,RSTART,RLENGTH); sub(/.*:[[:space:]]*/,"",s); tot+=s+0; n++ } }
    END{ if (n>0) printf "%.6f", tot; else printf "censored" }' "$f" 2>/dev/null)"
  printf '%s\n' "${sum:-censored}"
}

# --- human-review dollars (§4.4, inferred until measured) --------------------
# rep_human_dollars <rounds> <comment_words> — infer the reviewer's ACTIVE review
# time from the depth of reviewer commentary and price it at the configured hourly
# rate. A reviewer reads far more than they write, so time is base minutes per round
# PLUS the written words at a slow words-per-minute (the reader-not-writer proxy).
# All three constants are rate-card config (GARDEN_REP_*), not code — the measured
# review-metering instrument supersedes this per-change without churn. Prints the
# inferred dollars (0 when rounds and words are both 0/absent — a garden-internal
# job with no formal review costs no human review dollars).
rep_human_dollars() {
  local rounds="${1:-0}" words="${2:-0}"
  case "$rounds" in ''|*[!0-9]*) rounds=0 ;; esac
  case "$words"  in ''|*[!0-9]*) words=0  ;; esac
  awk -v r="$rounds" -v w="$words" -v bm="$GARDEN_REP_REVIEW_BASE_MIN" \
      -v wpm="$GARDEN_REP_REVIEW_WPM" -v rate="$GARDEN_REP_HOURLY_RATE" 'BEGIN{
    if (wpm <= 0) wpm = 20;
    mins = bm*r + w/wpm;
    printf "%.6f", mins/60.0*rate;
  }'
}
