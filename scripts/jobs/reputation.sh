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
: "${GARDEN_AUCTION_COLD_N:=5}"          # COST samples below which an arm draws from the cold prior
: "${GARDEN_REP_COLD_MEAN:=10}"          # cold-start prior mean, aggregate $ to a merge-worthy artifact
: "${GARDEN_REP_COLD_SD:=20}"            # cold-start prior sd — WIDE so a cold arm explores (§3.3)
: "${GARDEN_REP_VAR_FLOOR:=0.25}"        # variance floor for a thin-but-warm arm (sd >= 0.5)
: "${GARDEN_REP_MIN_DRAW:=0.01}"         # floor a Thompson draw here (dollars are strictly positive)
# Human-review dollar inference constants (§4.4). Config, not code; a measured
# review-time instrument supersedes these per-change without churn.
: "${GARDEN_REP_HOURLY_RATE:=125}"       # $/hr for inferred human-review time
: "${GARDEN_REP_REVIEW_BASE_MIN:=5}"     # minutes of review per round, baseline
: "${GARDEN_REP_REVIEW_WPM:=20}"         # words/min a reviewer WRITES (reads far more)
# Wallclock cost proxy for a cost-CENSORED arm (§4.4, the wallclock-cost-proxy job).
# `duration_secs` is on 100% of events and is measured BY THE GARDEN, so it is never
# censored the way a provider-reported dollar figure is; multiplied by a per-arm
# dollars-per-second rate it is a coarse but honest stand-in for the missing ledger.
: "${GARDEN_REP_RATE_CARD:=reputation/rate-card.md}"  # journal-relative rate table
: "${GARDEN_REP_DEFAULT_RATE_PER_SEC:=0.0052}"        # $/s for an arm with no row
: "${GARDEN_REP_ESTIMATE_SD_MULT:=2}"                 # sd inflation at 100% estimated cost
# `duration_secs` times only the FINAL attempt (the one that reached tada), so a
# requeued job's earlier attempts are wall time the proxy cannot see. The journal
# commit log CAN see them (claim commit -> requeue commit), but a claim interval
# measures how long the BOARD waited, not how long the worker RAN: a worker that
# dies in 5s still holds the claim until the reaper's next tick (~10 min) or, with
# no reap-now hint, the full GARDEN_CLAIM_TTL (4h). Each earlier attempt therefore
# contributes min(interval, this cap) — see rep_attempt_index for the calibration.
: "${GARDEN_REP_ATTEMPT_CAP_SECS:=120}"               # per-earlier-attempt ceiling

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

# rep_thompson_draw <attempts> <mean_dollars> <m2> <accepts> <seed-string> [cost_samples] [estimated_samples]
# One deterministic Thompson-sampling draw from an arm's aggregate-dollar posterior
# (§3.2 step 1). A COLD arm — fewer than cold_n COST samples, or never yet accepted
# — draws from the WIDE cold-start prior so it still occasionally draws lowest and
# wins a measuring job (exploration; §3.3). A WARM arm draws from a normal centered
# on its cost-per-accepted mean, with variance inflated by the acceptance rate
# (delta method: cost/accepted = per-attempt/rate, so var scales ~1/rate²), floored
# for thin arms. The lower the draw, the cheaper-to-merge this arm looks THIS time.
# Prints the drawn aggregate-dollar figure (floored at min_draw; dollars are > 0).
#
# COST evidence is counted SEPARATELY from ACCEPTANCE evidence. <cost_samples> is
# how many of the attempts carried a usable dollar measurement (attempts minus the
# projection's `censored:` count — rep_cost_samples); it defaults to <attempts> for
# a caller with no censoring, so the 5-argument form is unchanged. The warm branch
# is gated on COST samples and its variance divisor is the COST sample count, never
# `attempts`: an arm whose cost is entirely censored has NO cost posterior, and
# reading its zeroed mean/m2 as "this arm merges for $0.00" would make it win every
# auction on price — the exact inverse of the frozen-arm defect. Such an arm draws
# from the configured prior instead (the honest posterior when no cost has been
# observed), amortized by its MEASURED acceptance rate the same way the warm branch
# is (cost per accepted = cost per attempt / rate), so acceptance evidence still
# moves an all-censored arm: it can never bid BELOW the prior on missing data, and a
# rejection-prone arm bids above it. The amortization engages only once there IS
# acceptance evidence (>= cold_n attempts with at least one accept); a brand-new arm
# draws exactly the configured prior, as before.
#
# <estimated_samples> is how many of those <cost_samples> came from the WALLCLOCK
# PROXY rather than a real dollar ledger (rep_estimated_dollars). An estimate is
# evidence, but weaker evidence: `duration_secs x rate` is a coarse product of a
# hand-maintained rate card, and its spread understates the true cost spread (three
# 20-second canaries look far more certain than three priced runs ever would). So the
# warm branch INFLATES sd in proportion to the estimated FRACTION of the cost pool —
# no inflation at 0% estimated, x GARDEN_REP_ESTIMATE_SD_MULT at 100%. An arm priced
# entirely by proxy therefore still explores; it just no longer bids the $0.01 floor
# on a zeroed mean. Defaults to 0, so every existing 5- and 6-argument call is
# byte-identical.
rep_thompson_draw() {
  local att="${1:-0}" mean="${2:-0}" m2="${3:-0}" acc="${4:-0}" seed="${5:-}"
  local csn="${6:-${1:-0}}" esn="${7:-0}"
  local u1 u2
  u1="$(rep_seed_uniform "$seed" 1)"
  u2="$(rep_seed_uniform "$seed" 2)"
  awk -v att="$att" -v mean="$mean" -v m2="$m2" -v acc="$acc" -v u1="$u1" -v u2="$u2" \
      -v csn="$csn" -v esn="$esn" -v sm="$GARDEN_REP_ESTIMATE_SD_MULT" \
      -v cn="$GARDEN_AUCTION_COLD_N" -v cm="$GARDEN_REP_COLD_MEAN" -v csd="$GARDEN_REP_COLD_SD" \
      -v vf="$GARDEN_REP_VAR_FLOOR" -v md="$GARDEN_REP_MIN_DRAW" 'BEGIN{
    pi = 3.141592653589793;
    csn = csn+0; if (csn > (att+0)) csn = att+0; if (csn < 0) csn = 0;
    esn = esn+0; if (esn > csn) esn = csn; if (esn < 0) esn = 0;
    rate = ((att+0) > 0)? (acc+0)/(att+0) : 0;
    if (csn < (cn+0) || (acc+0) < 1) {
      # No usable cost posterior (too few COST samples, or never accepted): the
      # configured wide prior, amortized by the measured acceptance rate when there
      # is enough of it. rp == 1 reproduces the plain prior exactly.
      rp = ((att+0) >= (cn+0) && rate > 0)? rate : 1;
      mu = (cm+0)/rp; sd = (csd+0)/rp;           # cold prior — wide, explores
    } else {
      mu = mean+0;
      if (csn >= 2) va = (m2+0)/(csn-1); else va = 0;
      v = va/(rate*rate);                        # inflate per-attempt var by 1/rate²
      if (v < (vf+0)) v = vf+0;
      sd = sqrt(v);
      if (csn > 0 && esn > 0) {                  # widen for proxy-derived evidence
        ef = esn/csn; if (sm+0 < 1) sm = 1;
        sd = sd * (1 + ((sm+0)-1)*ef);
      }
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
# six space-separated fields: attempts accepts mean_dollars m2 censored estimated. A
# missing projection reads as all-zero (a cold arm). Robust to a partially-written
# file (missing fields default to 0 — including `estimated`, absent from projections
# written before the wallclock proxy, which then read as pure-ledger and behave
# exactly as they did). Reads from the working tree of <dir>.
rep_read_projection() {
  local dir="${1:?}" rel="${2:?}" f="$1/$2" att acc mean m2 cen est
  if [ -f "$f" ]; then
    att="$(plan_field "$f" attempts)";     acc="$(plan_field "$f" accepts)"
    mean="$(plan_field "$f" mean_dollars)"; m2="$(plan_field "$f" m2)"
    cen="$(plan_field "$f" censored)";     est="$(plan_field "$f" estimated)"
  fi
  printf '%s %s %s %s %s %s\n' "${att:-0}" "${acc:-0}" "${mean:-0}" "${m2:-0}" "${cen:-0}" "${est:-0}"
}

# rep_cost_samples <attempts> <censored> [estimated] — how many of an arm's attempts
# carried a usable dollar figure, i.e. the sample count behind mean_dollars/m2.
# Derived rather than stored so it can never disagree with the projection it
# summarizes. `estimated` is the subset of the CENSORED events the reducer was able
# to price from the wallclock proxy, so they are back IN the cost pool even though
# they remain counted in `censored:` — a raw `censored` count that never shrinks is
# how an arm reports how much of its cost evidence is real. Clamped into
# [0, attempts]: a projection left by an older reducer (which counted only the
# uncensored events as `attempts`) can never yield a negative, and an `estimated`
# larger than `censored` can never invent a sample.
rep_cost_samples() {
  local att cen est
  att="$(printf '%s' "${1:-0}" | tr -dc '0-9')"; att="${att:-0}"
  cen="$(printf '%s' "${2:-0}" | tr -dc '0-9')"; cen="${cen:-0}"
  est="$(printf '%s' "${3:-0}" | tr -dc '0-9')"; est="${est:-0}"
  [ "$est" -le "$cen" ] || est="$cen"
  local n=$(( att - cen + est )); [ "$n" -ge 0 ] || n=0
  [ "$n" -le "$att" ] || n="$att"
  printf '%s\n' "$n"
}

# --- agentic-dollar rollup (§4.4) --------------------------------------------
# rep_agentic_dollars <dir> <base> — sum notional dollars for every engagement of
# <base> from usage/<base>.jsonl (the token-cost-ledger CostRecord; each line a
# JSON object with a `total_cost_usd` number). Prints the summed dollars, or the literal
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
    { if (match($0, /"(total_cost_usd|dollars)"[[:space:]]*:[[:space:]]*[0-9.]+/)) {
        s=substr($0,RSTART,RLENGTH); sub(/.*:[[:space:]]*/,"",s); tot+=s+0; n++ } }
    END{ if (n>0) printf "%.6f", tot; else printf "censored" }' "$f" 2>/dev/null)"
  printf '%s\n' "${sum:-censored}"
}

# --- wallclock cost proxy for a censored arm (§4.4) --------------------------
# A provider CLI that reports no per-call dollars leaves rep_agentic_dollars to fail
# open to `censored`, and a whole class of arms (moonshot/kimi-k3, the codex clerics,
# the local hermits) is then priced by NOTHING. But the garden measures every job's
# WALLCLOCK itself — `duration_secs` is present on 100% of events and is not a
# provider report, so it cannot be censored. `duration_secs x dollars-per-second` is
# therefore a complete, uncensored cost SIGNAL for exactly the arms the ledger cannot
# reach. It is coarse: a rate card is a hand-maintained approximation, so an estimate
# must never impersonate a measurement (see rep_thompson_draw's sd inflation, the
# event's `cost_source:`, and the projection's separate `censored:`/`estimated:`).
#
# The rates live in JOURNAL state (reputation/rate-card.md), not code, precisely so a
# wrong rate is corrected by a data edit and the next reducer tick re-derives every
# historical event from the new number — no deploy, no event rewrite.

# rep_rate_lookup <file> <provider> <model> <thoughtfulness> — the raw rate cell from
# ONE rate table, or empty. The table is a markdown table whose first four columns are
# provider | model | thoughtfulness | dollars_per_second; each key cell is either an
# EXACT value or `*`, and the MOST SPECIFIC matching row wins (provider 4 > model 2 >
# thoughtfulness 1), ties going to the first such row. Exact-or-`*` rather than globs:
# there is no shell/awk pattern dialect to disagree about, so every host resolves the
# same rate from the same table — the determinism invariant this whole file rests on.
rep_rate_lookup() {
  [ -f "${1:-}" ] || return 0
  awk -F'|' -v p="${2:-}" -v m="${3:-}" -v t="${4:-}" '
    function trim(s){ gsub(/^[ \t]+/,"",s); gsub(/[ \t]+$/,"",s); return s }
    /^[ \t]*\|/ {
      pr=trim($2); mo=trim($3); th=trim($4); rt=trim($5);
      if (pr=="" || pr=="provider") next;            # header row
      if (pr ~ /^:?-+:?$/) next;                     # separator row
      if (rt !~ /^[0-9]*\.?[0-9]+$/) next;           # prose row / no numeric rate
      sc=0;
      if (pr!="*") { if (pr!=p) next; sc+=4 }
      if (mo!="*") { if (mo!=m) next; sc+=2 }
      if (th!="*") { if (th!=t) next; sc+=1 }
      if (!have || sc>best) { have=1; best=sc; val=rt }
    }
    END{ if (have) printf "%s", val }' "$1" 2>/dev/null
}

# rep_rate_per_second <dir> <provider> <model> <thoughtfulness>
# The arm's dollars-per-second, resolved in precedence order:
#   1. the PER-INSTANCE journal card, reputation/rate-card.md — the correctable layer;
#      a wrong rate is a journal data edit and the next reducer tick re-prices history,
#      with no deploy and no event rewritten. This is the whole point of a coarse proxy.
#   2. the TRACKED SEED, scripts/jobs/rate-card-defaults.md — same table format, on
#      main2, so a FRESH instance with an empty journal still prices its arms sanely
#      (pricing a local hermit at the paid-arm default would be ~90x wrong). Same
#      shape as bot-identity-defaults.tsv / model-routing-defaults.tsv.
#   3. GARDEN_REP_DEFAULT_RATE_PER_SEC — the last-resort constant, so the proxy is
#      self-contained and testable with no config of any kind present.
# Prints nothing when no POSITIVE rate resolves: a zero/absent/garbage rate means
# "this arm has no wallclock proxy", which leaves its events censored and its bid on
# the wide cold prior. That is the honest reading, and it is the one path that must
# never silently become $0.00 — a $0 cost posterior wins every auction on price.
rep_rate_per_second() {
  local dir="${1:-}" p="${2:-}" m="${3:-}" t="${4:-}" r=""
  [ -n "$dir" ] && r="$(rep_rate_lookup "$dir/$GARDEN_REP_RATE_CARD" "$p" "$m" "$t")"
  [ -n "$r" ] || r="$(rep_rate_lookup "$(dirname "${BASH_SOURCE[0]}")/rate-card-defaults.md" "$p" "$m" "$t")"
  case "$r" in ''|*[!0-9.]*) r="${GARDEN_REP_DEFAULT_RATE_PER_SEC:-0}" ;; esac
  case "$r" in ''|*[!0-9.]*) r=0 ;; esac
  awk -v r="$r" 'BEGIN{ if ((r+0) > 0) printf "%.9f", r+0 }'
}

# rep_estimated_dollars <dir> <provider> <model> <thoughtfulness> <duration_secs> [human_dollars]
# The wallclock-derived aggregate-dollar estimate for ONE cost-censored event:
# `duration_secs x rate + human_dollars` (human review is already a real inferred
# figure and is not censored, so it rides along exactly as it does on the ledger
# path). Prints the literal `censored` — never a number, and never 0 — when the event
# carries no positive duration or the arm resolves no positive rate. Fail-open in the
# same direction as rep_agentic_dollars: an absent input yields "unknown", not "free".
rep_estimated_dollars() {
  local dir="${1:-}" p="${2:-}" m="${3:-}" t="${4:-}" secs="${5:-0}" human="${6:-0}" rate
  case "$secs"  in ''|*[!0-9.]*) secs=0  ;; esac
  case "$human" in ''|*[!0-9.]*) human=0 ;; esac
  awk -v s="$secs" 'BEGIN{ exit !((s+0) > 0) }' || { printf 'censored\n'; return 0; }
  rate="$(rep_rate_per_second "$dir" "$p" "$m" "$t")"
  [ -n "$rate" ] || { printf 'censored\n'; return 0; }
  awk -v s="$secs" -v r="$rate" -v h="$human" 'BEGIN{ printf "%.6f\n", (s+0)*(r+0) + (h+0) }'
}

# --- multi-attempt wallclock: the earlier attempts the proxy cannot see ------
#
# `duration_secs` is the worker's OWN measurement of the attempt that reached tada.
# A requeued job burned earlier attempts too (`attempts: n` counts them, and the
# design already holds that "a reaped/resumed job's sunk cost is real cost"), and
# ~23% of events carry attempts > 1 — so for those the proxy is timing one attempt
# and pricing all of them.
#
# The journal commit log is the only record of the earlier attempts that is (a)
# complete for exactly the arms the ledger cannot reach and (b) measured by the
# garden rather than reported by a provider, hence uncensorable like duration_secs:
# a claim commit ADDS `jobs/doin/<base>.md`, the reaper's requeue REMOVES it, and
# the tada commit adds `jobs/tada/<base>.md`. Claim -> requeue is one attempt.
#
# But a claim interval is NOT the attempt's runtime — it is how long the BOARD
# waited. A worker that dies in 5s still holds its claim until the reaper's next
# tick (~10 min), or, when nothing stamped a reap-now hint (the host vanished),
# until the full GARDEN_CLAIM_TTL (4h). Measured on the 106 ledger-priced events,
# against per-attempt truth from `usage/<base>.jsonl`'s `elapsed_s`:
#
#   * 206 earlier attempts account for only 10264s of real runtime (mean ~50s):
#     an earlier attempt usually fails fast and then waits for the reaper.
#   * summing raw claim intervals overstates real runtime ~28x, and as a DOLLAR
#     predictor it is 7x worse than doing nothing (typical multiplicative error
#     14.55x, vs 2.04x for `duration_secs` alone).
#   * charging each earlier attempt min(interval, 120s) is the best estimator
#     tested: error 1.59x, RMSE 2.68 (vs 2.04x / 3.12 for duration_secs alone;
#     att x duration_secs scores 3.01x / 5.08). The optimum is flat over ~50-150s.
#
# So the log REFINES the measurement and never replaces it: effective seconds are
# `duration_secs + SUM min(earlier interval, GARDEN_REP_ATTEMPT_CAP_SECS)`, and an
# event with NO duration stays unpriced (rep_effective_secs prints 0 -> the arm
# keeps bidding the wide prior). The rate card is measured on THIS basis
# (scripts/jobs/rate-card-defaults.md), so changing the basis re-derived every row
# rather than silently inflating every estimate by the ratio between them.
#
# Attribution is per WORKER KIND: only the intervals claimed by a worker of the
# event's own kind are charged to its arm, so a kimi-fallback job does not bill an
# opus arm for the mystic attempts that preceded it (the claim commit's subject,
# `claim(<base>) <host>/<kind>-<id>`, carries the kind).

# _rep_attempt_awk — the shared walk over `git log --reverse --diff-filter=AD
# --name-status`. Emits ONE line per completed run:
#   <base> <kind>:<secs>[,<kind>:<secs>...]      (or `<base> -` when there were none)
# An interval is counted only once ANOTHER claim follows it, which is what makes it
# an EARLIER attempt; the interval that ends at the tada is dropped, because
# duration_secs measures that one exactly. A run's totals are flushed and reset at
# its tada, so a re-posted base is scored on its own run and the LAST line wins.
_rep_attempt_awk() {
  cat <<'AWK'
function emit(b,   kk, a, i, n, keys, out) {
  n = 0
  for (kk in earlier) { split(kk, a, SUBSEP); if (a[1] == b) keys[++n] = kk }
  out = ""
  for (i = 1; i <= n; i++) { split(keys[i], a, SUBSEP)
    out = out (out == "" ? "" : ",") a[2] ":" earlier[keys[i]] }
  for (i = 1; i <= n; i++) delete earlier[keys[i]]
  printf "%s %s\n", b, (out == "" ? "-" : out)
}
/^C /{ ts = $2 + 0; subj = $0; sub(/^C [0-9]+ /, "", subj); next }
{
  if (NF < 2) next
  st = $1; p = $2
  if (p !~ /^jobs\/(doin|tada)\/[^\/]+\.md$/) next
  b = p; sub(/^jobs\/(doin|tada)\//, "", b); sub(/\.md$/, "", b)
  if (p ~ /^jobs\/doin\//) {
    if (st == "A") {
      # a NEW claim proves the held interval was an earlier attempt: bank it.
      if (b in held) { earlier[b, heldk[b]] += held[b]; delete held[b] }
      if (!(b in open)) {
        open[b] = ts
        k = "unknown"
        if (subj ~ /^claim\(/ && subj ~ /\/[A-Za-z0-9]+-[0-9]+$/) {
          k = subj; sub(/.*\//, "", k); sub(/-[0-9]+$/, "", k) }
        okind[b] = k
      }
    } else if (b in open) {
      d = ts - open[b]; if (d < 0) d = 0; if (d > cap) d = cap
      held[b] = d; heldk[b] = okind[b]; delete open[b]
    }
  } else if (st == "A") {          # tada: the run completed
    delete open[b]; delete held[b] # the final attempt is duration_secs' job
    emit(b)
  }
}
END {
  # a run still in flight (claimed, no tada yet) — what complete-job.sh asks about.
  for (kk in earlier) { split(kk, a, SUBSEP); pend[a[1]] = 1 }
  for (bb in pend) emit(bb)
}
AWK
}

# rep_attempt_index <dir> [base] — the earlier-attempt index for every completed run
# in the journal log (one pass, ~0.7s over 38k commits), or for ONE base when given.
rep_attempt_index() {
  local dir="${1:?}" base="${2:-}" prog
  prog="$(_rep_attempt_awk)"
  if [ -n "$base" ]; then
    git -C "$dir" log --reverse --no-renames --diff-filter=AD --name-status \
        --format='C %ct %s' -- "$JOBS_DOIN/$base.md" "$JOBS_TADA/$base.md" 2>/dev/null
  else
    git -C "$dir" log --reverse --no-renames --diff-filter=AD --name-status \
        --format='C %ct %s' -- "$JOBS_DOIN" "$JOBS_TADA" 2>/dev/null
  fi | awk -v cap="${GARDEN_REP_ATTEMPT_CAP_SECS:-120}" "$prog"
}

# rep_attempt_lookup <indexfile> <base> <kind> — earlier-attempt seconds charged to
# <kind> on the LAST completed run of <base>. Prints 0 when unknown, so a missing
# index (a shallow clone, a git failure) degrades to today's duration_secs proxy.
rep_attempt_lookup() {
  local idx="${1:-}" base="${2:-}" kind="${3:-}"
  [ -f "$idx" ] || { printf '0\n'; return 0; }
  awk -v b="$base" -v k="$kind" '
    $1 == b { row = $2 }
    END { n = split(row, p, ",")
          for (i = 1; i <= n; i++) { split(p[i], q, ":"); if (q[1] == k) { printf "%d\n", q[2] + 0; exit } }
          print 0 }' "$idx"
}

# rep_attempt_earlier_secs <dir> <base> <kind> — the same figure for ONE base, for a
# caller that has no index in hand (complete-job.sh, mid-completion: its own run has
# no tada commit yet, so every CLOSED interval is by definition an earlier attempt).
rep_attempt_earlier_secs() {
  local dir="${1:?}" base="${2:?}" kind="${3:-}" tmp secs
  tmp="$(mktemp "${TMPDIR:-/tmp}/rep-attempt.XXXXXX")" || { printf '0\n'; return 0; }
  rep_attempt_index "$dir" "$base" > "$tmp" 2>/dev/null || true
  secs="$(rep_attempt_lookup "$tmp" "$base" "$kind")"
  rm -f "$tmp"
  printf '%s\n' "${secs:-0}"
}

# rep_effective_secs <duration_secs> <earlier_secs> — the wallclock the proxy prices.
# ZERO when there is no positive duration: the log REFINES a measurement, it never
# manufactures one, so "no duration" still means "no proxy" (never $0.00, never an
# estimate conjured from claim timestamps alone).
rep_effective_secs() {
  local d="${1:-0}" e="${2:-0}"
  case "$d" in ''|*[!0-9.]*) d=0 ;; esac
  case "$e" in ''|*[!0-9.]*) e=0 ;; esac
  awk -v d="$d" -v e="$e" 'BEGIN{ if ((d+0) <= 0) { print 0; exit } printf "%d\n", (d+0)+(e+0) }'
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

# --- demerits (hermit-failure capability probe; design hermit-failure-capability-
# demerit.md, feeding gnome-backend-verified-autotune.md) ---------------------
# A DEMERIT records that an arm FAILED a job that a CAPABLE reference model
# (claude/codex) COMPLETED on a bounded follow-up probe (hermit-capability-probe.sh).
# It is an ORDINARY reputation event — same schema the reducer already folds — with
# `accepted: false` and a NON-censored `aggregate_dollars`, so recompute_arms counts
# it as one un-accepted ATTEMPT for the arm: attempts++ without accepts++, driving
# that arm's `acceptance_rate` DOWN for the (work_class, target). That is exactly the
# routing signal future selection / the gnome-backend autotune reads — "local inference
# is unfit for this job class." A censored aggregate would be skipped by the reducer
# (cen++; next) and register nothing, so a demerit MUST carry a positive dollar figure.
#
# The demerit event is written under a demerit-SUFFIXED base so it never collides with
# the capable arm's own completion event for the SAME original base: complete-job.sh
# writes reputation/events/<base>.md when a (possibly different) worker later completes
# the requeued job, whereas a demerit writes reputation/events/<base>.<suffix>.md. Both
# fold by their OWN arm fields, independently.
: "${GARDEN_REP_DEMERIT_SUFFIX:=hermit-demerit}"

# rep_demerit_event_relpath <base> — journal-relative path of <base>'s demerit event.
rep_demerit_event_relpath() {
  printf '%s/%s.%s.md\n' "$REP_EVENTS" "$(rep_sanitize "${1:?}")" "$GARDEN_REP_DEMERIT_SUFFIX"
}

# rep_record_demerit <dir> <base> <kind> <provider> <model> <tht> <wc> <tgt> \
#                    <dollars> [probe_agent] [probe_model]
# Write (and git-add, in the journal clone <dir>) a demerit reputation event for the
# (kind,provider,model,thoughtfulness) arm × <wc> × <tgt>, attributing the failure of
# <base> that a capable probe DID complete. Deterministic and fail-open; the caller
# pushes it on its own single-writer CAS. A non-numeric/`censored` <dollars> falls back
# to the cold-prior mean so the event always folds as a counted attempt.
rep_record_demerit() {
  local dir="${1:?}" base="${2:?}" kind="${3:?}" provider="${4:?}" model="${5:?}"
  local tht="${6:?}" wc="${7:?}" tgt="${8:?}" dollars="${9:?}" pagent="${10:-unknown}" pmodel="${11:-unknown}"
  local rel; rel="$(rep_demerit_event_relpath "$base")"
  case "$dollars" in ''|censored|*[!0-9.]*) dollars="${GARDEN_REP_COLD_MEAN:-10}" ;; esac
  mkdir -p "$dir/$(dirname "$rel")"
  {
    printf -- '---\n'
    printf 'base: %s.%s\n' "$base" "$GARDEN_REP_DEMERIT_SUFFIX"
    printf 'kind: %s\n' "$kind"
    printf 'provider: %s\n' "$provider"
    printf 'model: %s\n' "$model"
    printf 'thoughtfulness: %s\n' "$tht"
    printf 'work_class: %s\n' "$wc"
    printf 'target: %s\n' "$tgt"
    printf 'accepted: false\n'
    printf 'agentic_dollars: %s\n' "$dollars"
    printf 'human_dollars: 0\n'
    printf 'aggregate_dollars: %s\n' "$dollars"
    printf 'demerit: true\n'
    printf 'demerit_of: %s\n' "$base"
    printf 'probe_agent: %s\n' "$pagent"
    printf 'probe_model: %s\n' "$pmodel"
    printf 'source: probe\n'
    printf 'recorded_by: %s\n' "${GARDEN:-unknown}/hermit-probe"
    printf 'recorded_at: %s\n' "$(date -u +%FT%TZ)"
    printf -- '---\n'
    printf 'demerit for %s: arm %s/%s/%s/%s FAILED work_class %s target %s where a capable probe (%s/%s) succeeded\n' \
      "$base" "$kind" "$provider" "$model" "$tht" "$wc" "$tgt" "$pagent" "$pmodel"
  } > "$dir/$rel"
  git -C "$dir" add "$rel" 2>/dev/null || true
}
