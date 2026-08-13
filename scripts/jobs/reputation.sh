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
REP_ADJUSTMENTS="$REP_ROOT/adjustments" # append-only, invoice/backfill cost corrections

# rep_adjusted_agentic_dollars <journal-dir> <base> — print the most recent
# sanctioned invoice/backfill value for an event, or nothing when there is none.
#
# Adjustments are append-only records at
# reputation/adjustments/<base>/<ordered-id>.md.  The lexical ordering of the
# id is the explicit correction order: a later correction supersedes an earlier
# one without editing either the raw event or the earlier correction.  A record
# must repeat its base and carry a non-negative decimal `agentic_dollars`; bad
# records are ignored (fail-open to the raw event/proxy) rather than turning a
# malformed journal edit into a free run.  The reducer is the only consumer; it
# never rewrites events, so the evidence and its correction remain separately
# auditable.
rep_adjusted_agentic_dollars() {
  local dir="${1:?}" base="${2:?}" f declared amount latest=""
  [ -d "$dir/$REP_ADJUSTMENTS/$base" ] || return 0
  shopt -s nullglob
  for f in "$dir/$REP_ADJUSTMENTS/$base"/*.md; do
    declared="$(plan_field "$f" base)"
    amount="$(plan_field "$f" agentic_dollars)"
    [ "$declared" = "$base" ] || continue
    awk -v n="$amount" 'BEGIN { exit !(n ~ /^[0-9]+([.][0-9]+)?$/) }' || continue
    latest="$amount"
  done
  shopt -u nullglob
  [ -n "$latest" ] && printf '%s\n' "$latest"
}

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
# Per-EARLIER-attempt wallclock cap for a requeued job (rep_wallclock_index). The
# proxy wallclock is the FINAL attempt's claim->tada span (uncapped — real
# engagement that produced the artifact) PLUS min(interval, this cap) for each
# earlier reaped attempt. Without the cap, a job that sat IDLE in the queue between
# a reap and its next claim bills that dead queue time as engagement wallclock —
# the 2026-07-29 backlog inflated one Fireworks base's proxy 72x this way. The cap
# bounds an earlier attempt at the longest a worker could have HELD the claim before
# the reaper requeued it: the default reap floor = default handler wall + kill-after
# + safety slack (matches reaper.sh's headerless reap_age_threshold, 2400+60+30).
# Longer intervals are reaper/queue latency, not worker engagement, and are clamped.
: "${GARDEN_REP_ATTEMPT_CAP_SECS:=2490}"              # cap on each EARLIER attempt's proxy span
# Providers billed by a FLAT SUBSCRIPTION rather than metered per call (the fleet's
# Claude Max plans). A per-call `total_cost_usd` from such a provider is NOTIONAL
# API list-price, not money: on a flat plan the marginal dollar of one more call is
# zero, and the real cost basis is the subscription divided by throughput — which the
# WALLCLOCK PROXY (rate card) expresses, not the CLI's per-call figure. So a flat
# provider's ledger dollars must NOT price the auction: the reducer treats them as
# cost-CENSORED and falls through to the proxy, exactly as for a provider that reports
# no dollars at all. The RAW ledger figure is still captured (usage/<base>.jsonl and
# the event's `agentic_dollars:`) as audit evidence — only the AGGREGATE the reducer
# folds is censored, so evidence and correction stay separately auditable. Space/comma
# list; env-overridable; EMPTY disables the policy (an all-metered fleet, or a test
# that uses `anthropic` as a generic priced stand-in).
: "${GARDEN_REP_FLAT_PROVIDERS=anthropic}"   # `=` not `:=`: an explicit EMPTY disables

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
  local provider="" model="" effort="" role="" req_tier="" req_effort=""
  provider="$(worker_kind_field "$kind" provider 2>/dev/null || echo anthropic)"
  role="$(plan_role "$jf")"
  req_tier="$(job_tier "$jf" 2>/dev/null || true)"
  req_effort="$(plan_field "$jf" effort)"
  [ -n "$req_tier" ] && model="$(tier_model_for_provider "$req_tier" "$provider")"
  [ -n "$model" ] || model="$(role_default_model "$kind" "$role")"
  # Fleet default when still unresolved: openai and local read their concrete
  # default from the journal-backed routing table (model_routing_default), so a
  # fleet-default change is a journal data edit, not a code edit. The claude
  # headerless default is not a knowable id here, so key it by a stable sentinel.
  if [ -z "$model" ]; then
    case "$provider" in
      openai) model="$(model_routing_default openai 2>/dev/null)"; [ -n "$model" ] || model="gpt-5.6-terra" ;;
      local)  model="$(model_routing_default local  2>/dev/null)"; [ -n "$model" ] || model="qwen3.6" ;;
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
# rep_provider_is_flat <provider> — return 0 (true) when <provider> is billed by a
# flat subscription, so its per-call ledger dollars are NOTIONAL (list-price), not
# money, and must not price the auction (GARDEN_REP_FLAT_PROVIDERS). Deterministic,
# LLM-free, byte-identical on every host. Consumed by complete-job.sh (write time) and
# reputation-reduce.sh (reduce time) so the SAME policy governs both fresh events and
# the historical backlog.
rep_provider_is_flat() {
  local p="${1:-}" x
  [ -n "$p" ] || return 1
  for x in ${GARDEN_REP_FLAT_PROVIDERS//,/ }; do
    [ "$x" = "$p" ] && return 0
  done
  return 1
}

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

# --- wallclock proxy: the journal's claim-to-tada span ----------------------
#
# `duration_secs` is only the final worker attempt. The journal records the true
# engagement wallclock, including every requeue: the first claim adds
# jobs/doin/<base>.md and completion adds jobs/tada/<base>.md. Its commit
# timestamps therefore give the claim-to-tada span without trusting provider usage
# records. This is the cost proxy's primary time source; duration_secs remains a
# compatibility fallback for old or incomplete journal history.

# _rep_wallclock_awk walks the relevant journal history and emits one line for each
# completed run: `<base> <claim-to-tada-secs>`. A base may be re-posted, so clearing
# the start after tada deliberately makes the final line the latest completed run.
_rep_wallclock_awk() {
  cat <<'AWK'
# Emit "<base> <proxy_secs>" per completed engagement. proxy_secs is the FINAL
# attempt's claim->tada span (uncapped) PLUS min(interval, cap) for each EARLIER
# reaped attempt, so idle queue time between a reap and the next claim is never
# billed as engagement. State per base: claim[b] = open attempt's claim ts,
# accum[b] = sum of capped earlier-attempt spans, reap[b] = a deferred doin-delete
# whose fate (reap vs completion) is only known at the NEXT event for b.
/^C /{ ts = $2 + 0; next }
{
  if (NF < 2) next
  st = $1; p = $2
  if (p !~ /^jobs\/(doin|tada)\/[^\/]+\.md$/) next
  b = p; sub(/^jobs\/(doin|tada)\//, "", b); sub(/\.md$/, "", b)
  if (p ~ /^jobs\/doin\//) {
    if (st == "A") {
      # A new claim proves any deferred doin-delete was a REAP, not a completion:
      # charge that earlier attempt, capped, then open this attempt.
      if (b in reap) {
        span = reap[b] - claim[b]; if (span < 0) span = 0
        if (cap > 0 && span > cap) span = cap
        accum[b] += span
        delete reap[b]
      }
      claim[b] = ts
    } else if (st == "D" && (b in claim)) {
      # Defer: at completion the doin-delete pairs with the tada-add in ONE commit,
      # so we cannot yet tell a reap from a completion. Resolve at the next event.
      reap[b] = ts
    }
  } else if (p ~ /^jobs\/tada\// && st == "A" && (b in claim)) {
    # Completion: the final (open) attempt is billed IN FULL, uncapped.
    d = ts - claim[b]; if (d < 0) d = 0
    printf "%s %d\n", b, accum[b] + d
    delete claim[b]; delete reap[b]; delete accum[b]
  }
}
AWK
}

# rep_wallclock_index <dir> [base] — claim-to-tada spans for completed runs in the
# journal log, or one base when requested.
rep_wallclock_index() {
  local dir="${1:?}" base="${2:-}" prog tada_path
  local paths=()
  prog="$(_rep_wallclock_awk)"
  if [ -n "$base" ]; then
    paths+=("$JOBS_DOIN/$base.md")
    tada_path="$(tada_find "$dir" "$base" || true)"
    [ -z "$tada_path" ] || paths+=("$tada_path")
    git -C "$dir" log --reverse --no-renames --diff-filter=AD --name-status \
        --format='C %ct %s' -- "${paths[@]}" 2>/dev/null
  else
    git -C "$dir" log --reverse --no-renames --diff-filter=AD --name-status \
        --format='C %ct %s' -- "$JOBS_DOIN" "$JOBS_TADA" 2>/dev/null
  fi | awk -v cap="${GARDEN_REP_ATTEMPT_CAP_SECS:-0}" "$prog"
}

# rep_wallclock_lookup <indexfile> <base> — latest completed span, blank when the
# log has none so callers can distinguish that from a real zero-second span.
rep_wallclock_lookup() {
  local idx="${1:-}" base="${2:-}"
  [ -f "$idx" ] || return 0
  awk -v b="$base" '$1 == b { value = $2 } END { if (value != "") print value }' "$idx"
}

# rep_proxy_secs <span_secs> <duration_secs> — prefer the true journal span; use the
# final-attempt duration only where history cannot yield a positive span.
rep_proxy_secs() {
  local s="${1:-}" d="${2:-0}"
  case "$s" in ''|*[!0-9.]*) s=0 ;; esac
  case "$d" in ''|*[!0-9.]*) d=0 ;; esac
  awk -v s="$s" -v d="$d" 'BEGIN { if ((s+0) > 0) printf "%d\n", s+0; else printf "%d\n", d+0 }'
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
