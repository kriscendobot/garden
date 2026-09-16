#!/bin/bash
# comment-provenance.sh — the fleet's GitHub-comment provenance suffix.
#
# WHAT THIS IS
# The maintainer directive (kriskowal, 2026-07-28): every PR/issue comment the
# fleet posts to GitHub carries a small-text footer naming the MODEL, the HARNESS,
# the HOST, and the DEPLOYED garden `main2` hash (hyperlinked) that produced it.
# This library
# renders that one-line footer and rewrites a `gh` argv to inject it. It is sourced
# by the fleet's gh wrapper (scripts/jobs/bin/gh) — the single PATH chokepoint every
# fleet gh call passes through — so the norm is ENFORCED by a script, not remembered
# by an agent (roles/mentor/AGENT.md: move a responsibility off an agent into code).
#
# WHY THE WRAPPER, NOT A SKILL
# scripts/jobs/bin/gh sits at the FRONT of the fleet PATH (common.sh), so EVERY gh
# call any role/subagent/direct-posting script makes is interceptable in one place.
# A skill telling agents to append a line is unreliable (forgotten, doubled, drifts);
# the wrapper cannot forget and is idempotent by construction.
#
# THE FACTS
#   model    — GARDEN_JOB_MODEL, the model actually resolved for THIS job
#             (exported by the handler from resolve_model_tier/role_default_model),
#             not the role's nominal default. Empty ⇒ field omitted.
#   harness  — the worker kind's harness CLI (GARDEN_WORKER_KIND: monk/gardener/friar→claude,
#             cleric/hermit/fireworker/openrouter→codex, mystic→kimi). Empty ⇒ field omitted.
#   provider — the model PROVIDER for the worker kind (GARDEN_WORKER_KIND, the same
#             taxonomy common.sh's worker_kind_field <kind> provider classifies:
#             monk/gardener/opencode-anthropic→anthropic, cleric→openai, hermit→local,
#             mystic→moonshot, fireworker→fireworks, openrouter→openrouter,
#             openrouter-promo→openrouter-promo, friar→ollama-cloud). `harness` alone
#             does NOT disambiguate provider — the `codex` harness fronts
#             openai/local/fireworks/openrouter depending on kind — so provider is a
#             distinct fact. Empty ⇒ field omitted.
#   host     — GARDEN, the fleet's canonical host/shard identity, falling back to
#             `hostname -s`. Empty ⇒ field omitted.
#   garden   — the DEPLOYED sha from .garden-state/deploy/deployed-sha (the code that
#             actually produced the behavior — NOT origin/main2 tip, which the
#             deployed root routinely lags), hyperlinked to the commit on the repo
#             derived from the git remote (survives the pending kriskowal→kriscendobot
#             transfer: whatever the remote says is what we link, and GitHub redirects
#             the old owner anyway). Short sha as the link text.
#
# AUTOMATIC (no LLM in the loop) vs an unresolved-fact bug
# A deterministic caller (a watcher ack, a reactji, a receipt, a mirror-close — no
# `claude -p`/`codex`/`kimi` in its own process) sets GARDEN_NO_LLM=1 to declare its
# comment MACHINE-authored. That renders `model automatic` (harness/provider omitted)
# — legibly distinct from a comment an LLM produced. When a comment is NOT marked
# automatic yet NONE of model/harness/provider resolve, that is an INSTRUMENTATION GAP
# (the caller ran an LLM but forgot to export GARDEN_JOB_MODEL/GARDEN_WORKER_KIND — the
# PR #1125 defect, indistinguishable in the rendered footer from a deterministic post).
# The comment STILL posts (fail-open below), but the gap is surfaced to the maintainer
# (throttled, best-effort — _prov_note_gap) so it is found and fixed, not accumulated.
#
# FAIL OPEN, NEVER CLOSED
# If model/harness/provider/sha cannot be resolved, the footer degrades to the fields
# that DID resolve (or vanishes entirely) — the comment still posts. A comment that
# fails to post because provenance was unavailable is worse than a comment missing its
# footer. Any parse ambiguity ⇒ the wrapper passes the call through UNCHANGED. The
# gap alert is best-effort and NEVER blocks a post.
#
# IDEMPOTENT
# The footer carries a hidden marker (PROV_MARKER); a body that already ends with it
# (or with a hand-written equivalent) is never doubled.
#
# This file is pure/side-effect-free to source: it only defines functions. It is
# deliberately self-contained (does NOT source common.sh) so the hot gh path stays
# cheap and cannot be broken by common.sh's heavier setup.

# The hidden idempotency marker embedded in the rendered footer. Grepping for it is
# the primary "already has a footer" test; a looser shape match backs it up so a
# hand-written footer is also not doubled.
: "${PROV_MARKER:=garden-provenance}"

# The PER-SECTION footnote marker, DELIBERATELY DISTINCT from PROV_MARKER. A
# multi-section aggregate body (a panel's per-seat blocks, a completion summary's
# per-contributor sections) footnotes each section with THIS marker so the
# per-section footnotes do NOT trip the gh wrapper's whole-body idempotency guard
# (provenance_body_has_line keys on PROV_MARKER); the assembled body still receives
# its single closing whole-body footer from the wrapper. See provenance_footnote.
: "${PROV_SECTION_MARKER:=garden-provenance-section}"

# _prov_root — the DEPLOYED garden root. The wrapper on PATH lives at
# <root>/scripts/jobs/bin/gh, so this file lives at <root>/scripts/jobs/…; walk up
# from here. An explicit GARDEN_ROOT env wins (tests, overrides).
_prov_root() {
  if [ -n "${GARDEN_ROOT:-}" ]; then printf '%s\n' "$GARDEN_ROOT"; return 0; fi
  ( cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd )
}

# _prov_esc <s> — minimal HTML escape for text placed inside <code>…</code>/href.
_prov_esc() {
  local s="${1-}"
  s="${s//&/&amp;}"; s="${s//</&lt;}"; s="${s//>/&gt;}"; s="${s//\"/&quot;}"
  printf '%s' "$s"
}

# _prov_harness <worker-kind> — the harness CLI name for a worker kind. Kept in
# sync with worker_kind_field (common.sh) but inlined so this file stays standalone.
# An unknown/blank kind yields empty (field omitted, fail-open).
_prov_harness() {
  case "${1-}" in
    monk|gardener|friar)    printf 'claude' ;;
    cleric|hermit|fireworker|openrouter|openrouter-promo) printf 'codex' ;;
    opencode-anthropic)     printf 'opencode' ;;
    mystic)                 printf 'kimi' ;;
    '')                     : ;;
    *)                      printf '%s' "$1" ;;  # forward an unrecognized kind verbatim
  esac
}

# _prov_provider <worker-kind> — the model PROVIDER for a worker kind. Kept in sync
# with worker_kind_field <kind> provider (common.sh) but inlined so this file stays
# standalone. `harness` alone cannot disambiguate provider (the codex harness fronts
# openai/local/fireworks/openrouter by kind), so this is a separate fact. An
# unknown/blank kind yields empty (field omitted, fail-open).
_prov_provider() {
  case "${1-}" in
    monk|gardener|opencode-anthropic) printf 'anthropic' ;;
    cleric)                 printf 'openai' ;;
    hermit)                 printf 'local' ;;
    mystic)                 printf 'moonshot' ;;
    fireworker)             printf 'fireworks' ;;
    openrouter)             printf 'openrouter' ;;
    openrouter-promo)       printf 'openrouter-promo' ;;
    friar)                  printf 'ollama-cloud' ;;
    '')                     : ;;
    *)                      : ;;  # unrecognized kind ⇒ no provider fact (fail-open)
  esac
}

# _prov_no_llm — true when a deterministic (no-LLM) caller has explicitly marked
# this comment as machine-authored via GARDEN_NO_LLM. Deliberate, opt-in signal:
# a watcher ack / reactji / receipt / mirror-close sets it before its gh call.
_prov_no_llm() {
  case "${GARDEN_NO_LLM:-}" in
    1|true|TRUE|yes|YES|on|ON) return 0 ;;
  esac
  return 1
}

# _prov_host — the fleet's canonical host/shard identity. GARDEN is the shared
# identity knob used across the fleet; hostname -s is its standard fallback.
# Failure or an empty result simply omits the field (fail-open).
_prov_host() {
  local host="${GARDEN:-}"
  [ -n "$host" ] || host="$(hostname -s 2>/dev/null || true)"
  printf '%s' "$host"
}

# _prov_llm_facts_missing — true when this comment is (presumably) LLM-authored — NOT
# marked automatic — yet NONE of model/harness/provider resolved: an instrumentation
# gap (the caller ran an LLM but forgot to export GARDEN_JOB_MODEL/GARDEN_WORKER_KIND).
# Host and garden sha are irrelevant here: a footer naming ONLY those whole-body
# facts is exactly the PR #1125 defect. Used only to decide whether to surface a
# maintainer alert; the post itself always proceeds (fail-open).
_prov_llm_facts_missing() {
  _prov_no_llm && return 1
  [ -n "${GARDEN_JOB_MODEL:-}" ] && return 1
  [ -n "$(_prov_harness "${GARDEN_WORKER_KIND:-}")" ] && return 1
  [ -n "$(_prov_provider "${GARDEN_WORKER_KIND:-}")" ] && return 1
  return 0
}

# _prov_deployed_sha <root> — the recorded deployed sha (the deploy marker). No git
# fallback here: the hot comment path must not shell out to git in the shared root,
# and an unrecorded sha simply degrades the garden field (fail-open). Env overrides
# mirror common.sh for testability.
_prov_deployed_sha() {
  local root="${1-}" marker
  marker="${GARDEN_DEPLOYED_SHA_MARKER:-${GARDEN_DEPLOY_STATE:-${GARDEN_STATE:-$root/.garden-state}/deploy}/deployed-sha}"
  local s; s="$(cat "$marker" 2>/dev/null || true)"
  s="${s//[$'\t\r\n ']/}"
  printf '%s' "$s"
}

# _prov_repo_url <root> — the https base URL of the garden repo, DERIVED from the
# git remote so it tracks the pending owner transfer. `git config --get` is a
# read-only config read (no fetch/checkout/state change), the same safe read
# bot_name()/bot_email() already perform against the shared root. Empty ⇒ the
# garden field degrades to an un-linked short sha.
_prov_repo_url() {
  local root="${1-}" u
  u="$(git -C "$root" config --get remote.origin.url 2>/dev/null || true)"
  [ -n "$u" ] || return 0
  u="${u%.git}"
  case "$u" in
    git@github.com:*)        u="https://github.com/${u#git@github.com:}" ;;
    ssh://git@github.com/*)  u="https://github.com/${u#ssh://git@github.com/}" ;;
    https://github.com/*)    : ;;
    http://github.com/*)     u="https://github.com/${u#http://github.com/}" ;;
    *)                       return 0 ;;  # unrecognized host ⇒ no link (fail-open)
  esac
  printf '%s' "$u"
}

# _prov_is_no_llm_val <v> — true when a value is a truthy no-LLM ("automatic")
# marker. The env path reads GARDEN_NO_LLM via _prov_no_llm; the explicit-facts
# path (a per-section footnote) passes the same truth-values through here.
_prov_is_no_llm_val() {
  case "${1-}" in
    1|true|TRUE|yes|YES|on|ON) return 0 ;;
  esac
  return 1
}

# _prov_mhp_parts <model> <harness> <provider> <no_llm> — build the
# "model … · harness … · provider …" (or, when no_llm is truthy, "model automatic")
# fragment from EXPLICIT resolved facts. Pure, reads NO env: the model, the RESOLVED
# harness, and the RESOLVED provider are all passed in, so a caller composing a
# multi-section body can render each section's own facts (which may differ from the
# composing process's env). Any empty fact is omitted (fail-open); an all-empty,
# not-automatic input yields the empty string.
_prov_mhp_parts() {
  local model="${1-}" harness="${2-}" provider="${3-}" no_llm="${4-}" parts=""
  if _prov_is_no_llm_val "$no_llm"; then
    # Deterministic, no-LLM section/caller: render `model automatic` and omit
    # harness/provider (there is no model/harness/provider — a machine wrote this).
    printf 'model <code>automatic</code>'
    return 0
  fi
  if [ -n "$model" ]; then
    parts="model <code>$(_prov_esc "$model")</code>"
  fi
  if [ -n "$harness" ]; then
    [ -n "$parts" ] && parts="$parts · "
    parts="${parts}harness <code>$(_prov_esc "$harness")</code>"
  fi
  if [ -n "$provider" ]; then
    [ -n "$parts" ] && parts="$parts · "
    parts="${parts}provider <code>$(_prov_esc "$provider")</code>"
  fi
  printf '%s' "$parts"
}

# provenance_line — render the WHOLE-BODY footer line, or nothing if no fact
# resolved. Pure; reads GARDEN_JOB_MODEL / GARDEN_WORKER_KIND / GARDEN_NO_LLM from
# the environment (the composing process's own facts) and appends the deployed
# garden sha. This is the footer the gh wrapper injects at the END of a comment
# body; a per-SECTION footnote uses provenance_footnote instead.
provenance_line() {
  local model harness provider host root sha url short parts no_llm=0
  root="$(_prov_root)"
  sha="$(_prov_deployed_sha "$root")"
  url="$(_prov_repo_url "$root")"

  if _prov_no_llm; then
    no_llm=1
  else
    model="${GARDEN_JOB_MODEL:-}"
    harness="$(_prov_harness "${GARDEN_WORKER_KIND:-}")"
    provider="$(_prov_provider "${GARDEN_WORKER_KIND:-}")"
  fi
  parts="$(_prov_mhp_parts "${model:-}" "${harness:-}" "${provider:-}" "$no_llm")"
  host="$(_prov_host)"
  if [ -n "$host" ]; then
    [ -n "$parts" ] && parts="$parts · "
    parts="${parts}host <code>$(_prov_esc "$host")</code>"
  fi
  # Host and garden sha (the execution location and DEPLOYED code that produced the
  # body) are whole-body facts; they ride the whole-body footer, not per-section
  # footnotes.
  if [ -n "$sha" ]; then
    short="${sha:0:8}"
    [ -n "$parts" ] && parts="$parts · "
    if [ -n "$url" ]; then
      parts="${parts}garden <a href=\"$(_prov_esc "$url")/commit/$(_prov_esc "$sha")\"><code>$(_prov_esc "$short")</code></a>"
    else
      parts="${parts}garden <code>$(_prov_esc "$short")</code>"
    fi
  fi
  [ -n "$parts" ] || return 0
  printf '<sub><!--%s-->%s</sub>' "$PROV_MARKER" "$parts"
}

# provenance_footnote <model> <harness> <provider> [no_llm] — render a PER-SECTION
# provenance footnote from EXPLICIT resolved facts. `harness` and `provider` are
# the RESOLVED names (NOT a worker kind — pass literals, or the output of
# _prov_harness/_prov_provider; or use provenance_footnote_for_kind which resolves
# a kind for you). For a caller stitching a MULTI-SECTION aggregate body — a panel's
# per-seat `claude -p` blocks, a completion summary's per-contributor sections —
# where each section's model/harness/provider may differ from the composing
# process's own env. A whole-body footer would misattribute every section but one.
#
# Same <sub> visual style as the whole-body footer, with two deliberate differences:
#   * it carries PROV_SECTION_MARKER (not PROV_MARKER), so it does NOT trip the gh
#     wrapper's whole-body idempotency guard — the assembled body still gets its
#     single closing whole-body footer;
#   * it OMITS the host and garden sha (whole-body facts, constant across sections;
#     the closing footer carries them once) — a footnote answers only WHICH
#     model/harness/provider (or automatic) produced THIS section.
# Empty (rc 0, no output) when no fact resolves and the section is not marked
# automatic (fail-open) — a section with unknown provenance simply carries none.
provenance_footnote() {
  local parts
  parts="$(_prov_mhp_parts "${1-}" "${2-}" "${3-}" "${4-}")"
  [ -n "$parts" ] || return 0
  printf '<sub><!--%s-->%s</sub>' "$PROV_SECTION_MARKER" "$parts"
}

# provenance_footnote_for_kind <model> <worker-kind> [no_llm] — convenience over
# provenance_footnote: resolve harness/provider from a WORKER KIND (the same
# taxonomy the env path uses via _prov_harness/_prov_provider), then render the
# per-section footnote. A blank/unknown kind resolves to empty harness/provider
# (fail-open, exactly like the env path).
provenance_footnote_for_kind() {
  provenance_footnote "${1-}" "$(_prov_harness "${2-}")" "$(_prov_provider "${2-}")" "${3-}"
}

# provenance_body_has_line <body> — true (rc 0) when the body already carries a
# provenance footer: our hidden marker, or a hand-written equivalent (a <sub> line
# naming model … garden … commit/). Prevents a doubled footer.
provenance_body_has_line() {
  local body="${1-}"
  # Match the WHOLE-BODY marker as its DELIMITED comment token `<!--marker-->`, not a
  # bare substring: PROV_SECTION_MARKER ("garden-provenance-section") contains
  # PROV_MARKER ("garden-provenance") as a substring, so a bare-substring test would
  # false-positive on a body that carries ONLY per-section footnotes and wrongly
  # suppress its single closing whole-body footer. The rendered footer always emits
  # the delimited form, so this stays exact for a real whole-body footer.
  case "$body" in
    *"<!--$PROV_MARKER-->"*) return 0 ;;
  esac
  # Loose shape match for a hand-authored footer (agent copied the template).
  printf '%s' "$body" | grep -Eiq '<sub>[^<]*model .*garden.*commit/' && return 0
  return 1
}

# provenance_append <body> — echo the body with the footer appended (a blank line
# between). Idempotent: a body already carrying a footer is returned unchanged. If
# no fact resolves, the body is returned unchanged (fail-open).
provenance_append() {
  local body="${1-}" line
  if provenance_body_has_line "$body"; then
    printf '%s' "$body"; return 0
  fi
  line="$(provenance_line)"
  if [ -z "$line" ]; then
    printf '%s' "$body"; return 0
  fi
  printf '%s\n\n%s' "$body" "$line"
}

# ===========================================================================
# instrumentation-gap alert — surface (throttled) a comment posted by an
# LLM-driven caller that forgot to export its job facts (the PR #1125 defect),
# so silent gaps get found instead of accumulating unnoticed.
#
# Self-contained on purpose: this file does NOT source common.sh (the hot gh path
# must stay cheap), so the throttle+count is reimplemented minimally here, mirroring
# common.sh's alert_maintainer missing-tools-<host> shape (one delivery per window
# per key, folded occurrence count). The rare DELIVERY forks watchdog-notice.sh —
# which sources common.sh in ITS OWN process (a subprocess, not a hot-path source)
# and coalesces per key in the maintainer inbox. Best-effort and NEVER fails the
# caller: a comment ALWAYS still posts (the fail-open invariant).
# ===========================================================================

# _prov_note_gap — record + (throttled) deliver ONE maintainer alert for a comment
# provenance gap on this host. Keyed per host (comment-provenance-gap-<host>) so a
# busy gap cannot spam the inbox.
_prov_note_gap() {
  [ "${GARDEN_NO_MAINTAINER_ALERT:-0}" = 1 ] && return 0
  local root state host key skey dir marker cfile now last n throttle msg
  root="$(_prov_root)"
  state="${GARDEN_STATE:-$root/.garden-state}"
  host="${GARDEN:-$(hostname -s 2>/dev/null || echo unknown)}"
  key="comment-provenance-gap-${host}"
  skey="${key//[^A-Za-z0-9._-]/_}"
  dir="$state/alerts"
  marker="$dir/$skey.last"; cfile="$dir/$skey.count"
  mkdir -p "$dir" 2>/dev/null || true

  now="$(date +%s 2>/dev/null || echo 0)"
  # Count the occurrence FIRST so one suppressed by the throttle still folds into the
  # next delivery's count (mirrors alert_maintainer).
  n="$(cat "$cfile" 2>/dev/null || echo 0)"; [[ "$n" =~ ^[0-9]+$ ]] || n=0; n=$(( n + 1 ))
  printf '%s\n' "$n" > "$cfile" 2>/dev/null || true

  throttle="${GARDEN_ALERT_THROTTLE_SECS:-3600}"
  if [ -f "$marker" ]; then
    last="$(cat "$marker" 2>/dev/null || echo 0)"; [[ "$last" =~ ^[0-9]+$ ]] || last=0
    [ $(( now - last )) -lt "$throttle" ] && return 0
  fi
  printf '%s\n' "$now" > "$marker" 2>/dev/null || true

  msg="comment-provenance INSTRUMENTATION GAP on host ${host}: a fleet \`gh\` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its \`gh\` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post."

  # Test/alternate sink first (mirrors alert_maintainer's GARDEN_ALERT_CMD hook).
  if [ -n "${GARDEN_ALERT_CMD:-}" ]; then
    "$GARDEN_ALERT_CMD" "$key" "$msg" "$n" >/dev/null 2>&1 || true
    printf '0\n' > "$cfile" 2>/dev/null || true
    return 0
  fi
  local wn="$root/scripts/jobs/watchdog-notice.sh"
  if [ -x "$wn" ]; then
    printf '%s\n' "$msg" \
      | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="watchdog:comment-provenance" \
        "$wn" --count "$n" "$key" >/dev/null 2>&1 || true
  fi
  printf '0\n' > "$cfile" 2>/dev/null || true
  return 0
}

# _prov_gap_check <body> — on the comment-post path, if <body> is a non-empty,
# not-already-footed comment whose LLM facts are missing (and not marked automatic),
# surface the instrumentation gap. A no-op otherwise. Never fails the caller.
_prov_gap_check() {
  local body="${1-}"
  [ -n "$body" ] || return 0
  provenance_body_has_line "$body" && return 0   # already footed ⇒ a repost, not a gap
  _prov_llm_facts_missing || return 0
  _prov_note_gap
  return 0
}

# ===========================================================================
# argv rewriting — the wrapper's hard part: injecting the footer into whichever
# of gh's many body-bearing invocation forms is in use, WITHOUT corrupting the
# body (JSON stays valid; a --body-file on disk is never mutated — a fresh temp
# holds the modified body).
#
# Contract for the wrapper:
#   provenance_rewrite_argv "$@"
#     rc 0 → PROV_NEWARGV is the argv to exec instead of "$@"; PROV_TMPFILES lists
#            temp files to clean AFTER the real gh returns.
#     rc 1 → passthrough: exec the ORIGINAL "$@" unchanged (not a comment-create,
#            body already carries a footer, no fact resolved, or any parse doubt).
# Fail-open is the invariant: every uncertain branch returns 1.
# ===========================================================================

PROV_NEWARGV=()
PROV_TMPFILES=()

# _prov_mktemp — a temp file on an exec-safe path. Body/JSON temp files only need
# to be readable by the real gh; TMPDIR is fine.
_prov_mktemp() {
  local f
  f="$(mktemp "${TMPDIR:-/tmp}/garden-prov.XXXXXX" 2>/dev/null)" || return 1
  PROV_TMPFILES+=("$f")
  printf '%s' "$f"
}

provenance_cleanup() {
  local f
  for f in "${PROV_TMPFILES[@]:-}"; do [ -n "$f" ] && rm -f "$f" 2>/dev/null || true; done
  PROV_TMPFILES=()
}

# _prov_rewrite_body_flag <body|comment> <argv...> — handle the body-bearing gh
# comment surfaces. `body` covers `pr comment`, `issue comment`, and `pr review`,
# where the body arrives via -b/--body or -F/--body-file. `comment` covers the
# lifecycle commands (`pr close`/`reopen`/`merge`, `issue close`/`reopen`) whose
# comment arrives via -c/--comment. Body forms normalize to a fresh --body-file;
# comment forms stay inline because those commands expose no comment-file flag.
# rc 0 if rewritten.
_prov_rewrite_body_flag() {
  local kind="${1:-}"; shift || return 1
  case "$kind" in body|comment) : ;; *) return 1 ;; esac
  local -a args=("$@")
  local i n="${#args[@]}"
  local body="" have_body=0 from_stdin=0
  local -a keep=()

  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      -b|--body)
        [ "$kind" = body ] || { keep+=("$a"); i=$((i+1)); [ "$i" -lt "$n" ] || return 1; keep+=("${args[$i]}"); i=$((i+1)); continue; }
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1
        body="${args[$i]}"; have_body=1 ;;
      --body=*) [ "$kind" = body ] && { body="${a#--body=}"; have_body=1; } || keep+=("$a") ;;
      -b=*)     [ "$kind" = body ] && { body="${a#-b=}";     have_body=1; } || keep+=("$a") ;;
      -F|--body-file)
        [ "$kind" = body ] || { keep+=("$a"); i=$((i+1)); [ "$i" -lt "$n" ] || return 1; keep+=("${args[$i]}"); i=$((i+1)); continue; }
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1
        local f="${args[$i]}"
        if [ "$f" = "-" ]; then body="$(cat)"; from_stdin=1; else body="$(cat "$f" 2>/dev/null)" || return 1; fi
        have_body=1 ;;
      --body-file=*|-F=*)
        if [ "$kind" = body ]; then
          local f="${a#*=}"
          if [ "$f" = "-" ]; then body="$(cat)"; from_stdin=1; else body="$(cat "$f" 2>/dev/null)" || return 1; fi
          have_body=1
        else
          keep+=("$a")
        fi ;;
      -c|--comment)
        if [ "$kind" = comment ]; then
          i=$((i+1)); [ "$i" -lt "$n" ] || return 1
          body="${args[$i]}"; have_body=1
        else
          keep+=("$a")
        fi ;;
      --comment=*|-c=*)
        if [ "$kind" = comment ]; then body="${a#*=}"; have_body=1; else keep+=("$a"); fi ;;
      *) keep+=("$a") ;;
    esac
    i=$((i+1))
  done

  [ "$have_body" -eq 1 ] || return 1   # editor/--edit-last/-w: nothing to inject

  # Surface an instrumentation gap (missing LLM facts, not marked automatic) — the
  # PR #1125 defect. Independent of whether a footer ends up appended below.
  _prov_gap_check "$body"

  # Idempotent: an already-footed body sourced from a FILE/inline can pass through
  # untouched. But if we consumed STDIN we must forward it (stdin is gone), so we
  # still rewrite — just without appending a second footer.
  if provenance_body_has_line "$body"; then
    [ "$from_stdin" -eq 1 ] || return 1
  fi

  local newbody; newbody="$(provenance_append "$body")"
  # Footer empty (no fact resolved) and body unchanged: leave the call UNTOUCHED
  # (fail-open). A stdin body must still be forwarded — we already consumed it.
  if [ "$newbody" = "$body" ] && [ "$from_stdin" -eq 0 ]; then return 1; fi
  if [ "$kind" = comment ]; then
    PROV_NEWARGV=("${keep[@]}" --comment "$newbody")
  else
    local tmp; tmp="$(_prov_mktemp)" || return 1
    printf '%s' "$newbody" > "$tmp" || return 1
    PROV_NEWARGV=("${keep[@]}" --body-file "$tmp")
  fi
  return 0
}

# _prov_api_endpoint_is_comment <endpoint> — true when the REST path creates a
# comment (issue/PR conversation comment, inline review comment, threaded reply,
# or a review whose summary body we footer). Excludes /reactions, PR/issue
# description PATCH, labels, merges — anything without a comment body.
_prov_api_endpoint_is_comment() {
  case "${1-}" in
    */issues/[0-9]*/comments)      return 0 ;;   # issue / PR conversation comment
    */pulls/[0-9]*/comments)       return 0 ;;   # inline review comment
    */comments/[0-9]*/replies)     return 0 ;;   # threaded reply
    */pulls/[0-9]*/reviews)        return 0 ;;   # review (summary body)
  esac
  return 1
}

# _prov_rewrite_api <argv...> — handle `gh api` comment-creating POSTs. The body
# is carried as a field flag (-f/--raw-field/-F/--field body=…) or inside an
# --input JSON file (or `--input -` stdin). Only rewrite when the endpoint is a
# comment endpoint AND a POST (explicit -X POST, or fields defaulting to POST);
# everything else (reads, reactions, PATCH descriptions) passes through. rc 0 if
# rewritten.
_prov_rewrite_api() {
  local -a args=("$@")
  local n="${#args[@]}" i
  local method="" endpoint="" input_idx=-1 input_val=""
  local body_idx=-1 body_prefix="" body_val="" body_from=""   # from: raw|field
  local seen_field=0

  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      api) : ;;  # the subcommand itself
      -X|--method)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; method="${args[$i]}" ;;
      -X=*)       method="${a#-X=}" ;;
      --method=*) method="${a#--method=}" ;;
      -f|--raw-field)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; seen_field=1
        case "${args[$i]}" in body=*) body_idx=$i; body_prefix="body="; body_val="${args[$i]#body=}"; body_from=raw ;; esac ;;
      -f=*|--raw-field=*)
        seen_field=1; local v="${a#*=}"
        case "$v" in body=*) body_idx=$i; body_prefix="${a%%body=*}body="; body_val="${v#body=}"; body_from=raw ;; esac ;;
      -F|--field)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; seen_field=1
        case "${args[$i]}" in body=*) body_idx=$i; body_prefix="body="; body_val="${args[$i]#body=}"; body_from=field ;; esac ;;
      -F=*|--field=*)
        seen_field=1; local v="${a#*=}"
        case "$v" in body=*) body_idx=$i; body_prefix="${a%%body=*}body="; body_val="${v#body=}"; body_from=field ;; esac ;;
      --input)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; input_idx=$i; input_val="${args[$i]}" ;;
      --input=*) input_idx=$i; input_val="${a#--input=}" ;;
      -H|--header|-q|--jq|-t|--template|--hostname|--cache)
        i=$((i+1)) ;;  # value-bearing flags: skip the value so it is not read as the endpoint
      -*) : ;;         # boolean/unknown flag
      *)  [ -z "$endpoint" ] && endpoint="$a" ;;
    esac
    i=$((i+1))
  done

  _prov_api_endpoint_is_comment "$endpoint" || return 1

  # Must be a create POST. Explicit non-POST method (GET/PATCH/DELETE/…) ⇒ not a
  # comment create ⇒ passthrough. No method + a field flag ⇒ gh POSTs ⇒ create.
  if [ -n "$method" ]; then
    case "$method" in [Pp][Oo][Ss][Tt]) : ;; *) return 1 ;; esac
  else
    [ "$seen_field" -eq 1 ] || [ "$input_idx" -ge 0 ] || return 1
  fi

  PROV_NEWARGV=("${args[@]}")

  # --- body via --input JSON --------------------------------------------------
  # A `--input -` STDIN read cannot be un-consumed: once we cat it, passing the
  # original argv through would hand gh an empty stdin. So for the stdin form we
  # ALWAYS forward via a temp file (footered if a .body is present, verbatim
  # otherwise). A `--input <file>` is re-readable, so it may cleanly passthrough.
  if [ "$input_idx" -ge 0 ]; then
    local from_stdin=0; [ "$input_val" = "-" ] && from_stdin=1
    if [ "$from_stdin" -eq 0 ]; then
      command -v jq >/dev/null 2>&1 || return 1  # file input, cannot edit ⇒ passthrough
    fi
    local json
    if [ "$from_stdin" -eq 1 ]; then json="$(cat)"; else json="$(cat "$input_val" 2>/dev/null)" || return 1; fi
    # _prov_forward_json: re-emit $json (possibly edited) to a temp and repoint.
    _prov_forward_json() {
      local j="$1" tmp
      tmp="$(_prov_mktemp)" || return 1
      printf '%s' "$j" > "$tmp" || return 1
      PROV_NEWARGV[$input_idx]="$tmp"
    }
    # jq absent on the stdin path: we already consumed stdin, so forward verbatim
    # (cannot inject, but must not drop the body).
    if ! command -v jq >/dev/null 2>&1; then
      _prov_forward_json "$json" && return 0 || return 1
    fi
    local cur; cur="$(printf '%s' "$json" | jq -er '.body // empty' 2>/dev/null || true)"
    _prov_gap_check "$cur"
    if [ -z "$cur" ] || provenance_body_has_line "$cur"; then
      # No body to footer, or already footed. On stdin we must still forward.
      if [ "$from_stdin" -eq 1 ]; then _prov_forward_json "$json" && return 0 || return 1; fi
      return 1
    fi
    local newbody; newbody="$(provenance_append "$cur")"
    local newjson
    newjson="$(printf '%s' "$json" | jq --arg b "$newbody" '.body=$b' 2>/dev/null)" || {
      [ "$from_stdin" -eq 1 ] && { _prov_forward_json "$json" && return 0; }; return 1; }
    _prov_forward_json "$newjson" && return 0 || return 1
  fi

  # --- body via a field flag --------------------------------------------------
  [ "$body_idx" -ge 0 ] || return 1
  # -F/--field body=@file or body=- reads externally; append after resolving so we
  # never mutate the source file — pass the combined value inline via a raw field.
  local resolved="$body_val"
  if [ "$body_from" = field ]; then
    case "$body_val" in
      @-) resolved="$(cat)" ;;
      @*) resolved="$(cat "${body_val#@}" 2>/dev/null)" || return 1 ;;
      -)  resolved="$(cat)" ;;
    esac
  fi
  _prov_gap_check "$resolved"
  if provenance_body_has_line "$resolved"; then
    case "$body_val" in @-|-) : ;; *) return 1 ;; esac  # already footed & not stdin ⇒ passthrough
  fi
  local newbody; newbody="$(provenance_append "$resolved")"
  # Footer empty (no fact resolved) and value unchanged: passthrough untouched,
  # unless the value came from stdin (already consumed → must forward).
  if [ "$newbody" = "$resolved" ]; then
    case "$body_val" in @-|-) : ;; *) return 1 ;; esac
  fi
  # Re-emit as a raw-field (literal) so an @file/- form cannot re-trigger file/stdin
  # reads on the modified value. Keep any -F=/-f= prefix's flag intact by rewriting
  # to the plain `body=` value; the flag token itself (args[body_idx-…]) stays.
  case "${args[$body_idx]}" in
    body=*|*=body=*) PROV_NEWARGV[$body_idx]="${body_prefix}${newbody}" ;;
    *)               PROV_NEWARGV[$body_idx]="body=${newbody}" ;;
  esac
  # A field flag that read @file/- must become a raw literal so gh treats the new
  # value as a string, not a re-read. If the flag was -F/--field, flip it to -f.
  if [ "$body_from" = field ]; then
    local flag_idx=$((body_idx-1))
    if [ "$flag_idx" -ge 0 ]; then
      case "${args[$flag_idx]}" in
        -F|--field) PROV_NEWARGV[$flag_idx]="--raw-field" ;;
      esac
    fi
    # Inline -F=body=… / --field=body=… forms: rewrite the whole token to raw-field.
    case "${args[$body_idx]}" in
      -F=body=*)      PROV_NEWARGV[$body_idx]="--raw-field=body=${newbody}" ;;
      --field=body=*) PROV_NEWARGV[$body_idx]="--raw-field=body=${newbody}" ;;
    esac
  fi
  return 0
}

# provenance_rewrite_argv <argv...> — top dispatcher. See the contract block above.
provenance_rewrite_argv() {
  # shellcheck disable=SC2034  # PROV_NEWARGV is consumed by the gh wrapper.
  PROV_NEWARGV=()
  local cmd="${1:-}" sub="${2:-}"
  case "$cmd" in
    pr)
      case "$sub" in
        comment|review)    _prov_rewrite_body_flag body "$@" && return 0 ;;
        close|reopen|merge) _prov_rewrite_body_flag comment "$@" && return 0 ;;
      esac ;;
    issue)
      case "$sub" in
        comment)      _prov_rewrite_body_flag body "$@" && return 0 ;;
        close|reopen) _prov_rewrite_body_flag comment "$@" && return 0 ;;
      esac ;;
    api) _prov_rewrite_api "$@" && return 0 ;;
  esac
  return 1
}
