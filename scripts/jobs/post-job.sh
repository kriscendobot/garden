#!/bin/bash
# post-job.sh — producer primitive: put a job onto the board's todo/.
#
# Usage: post-job.sh [--identity <key>] [--provider-canary <provider> <tier>] <basename> [<body-file>]
#   <basename>   reserved job name; the spine that ties todo↔doin↔tada↔worktree.
#                Must be filesystem- and git-ref-safe; keep it short.
#   <body-file>  optional file whose contents become the job body. If omitted,
#                the body is read from stdin (or a one-line placeholder).
#   --identity   optional stable directive identity (see below). May also be
#                supplied via the GARDEN_JOB_IDENTITY env var.
#
# Idempotent by BASENAME: if <basename> already exists in the lifecycle the post is
# a no-op success — a triager that re-sees the same change across ticks will not
# duplicate the job, provided the basename is derived deterministically from the
# change identity. plan/todo/doin ALWAYS count: plan/ because a job the proxy parked
# as blocked (proxy.sh park_blocked_jobs moves the ONLY live copy there) must not be
# re-minted into todo/ by a producer re-seeing the directive — that would run the
# "blocked" job AND let promote-plan.sh later clobber it with the stale plan body.
# tada/ (COMPLETED) counts ONLY when NO directive identity is given: with an identity,
# the identity index (below) is the authoritative re-see guard and a FINISHED job must
# not swallow a FRESH directive that happens to derive the same base (the #671
# "Shepherd." drop — see the basename check below). A base is NOT comment-unique for
# the mechanical-verb producers (it is keyed on (PR,verb)), so tada-blocking a fresh
# directive there was a silent-drop hazard the identity layer already guards against.
#
# Idempotent by DIRECTIVE IDENTITY: basename dedup only collapses re-posts of the
# SAME base. It does NOT catch two DIFFERENT producers minting DIFFERENTLY-named
# jobs for the ONE underlying directive — the comment-watcher's
# `<slug>-pr<N>-<hash>` and a peer/liaison's hand-named `ebfb-pr-<N>-<slug>` both
# fired on ONE PR comment, spawning two concurrent same-PR jobs (the PR #58
# clobber root cause). When a producer passes a directive identity — a stable key
# for the comment/review that triggered the work, e.g.
# `endojs/endo-but-for-bots#58:comment:4850565566` — the post is additionally
# deduped against the `jobs/index/<hash>` map: if that identity already owns a job
# that is still live (plan/todo/doin/tada) the post is a NO-OP, so ONE directive maps
# to at most one open job regardless of what each producer named it. When no
# explicit identity is given, one is best-effort derived from the body if it cites
# exactly one canonical GitHub comment URL (derive_job_identity_from_body), so a
# hand-named peer job that quotes the comment URL dedups too. The index entry is
# written atomically WITH the job (one commit) and re-pointed when it goes stale.
#
# Posts are ADDS, which never conflict the way claims do, so on a rejected
# push we simply re-sync and retry.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="post"

usage() {
  cat <<'EOF'
post-job.sh — put a job onto the board's todo/.

Usage: post-job.sh [--identity <key>] <basename> [<body-file>]
  <basename>   reserved job name (filesystem- and git-ref-safe; must not start
               with '-'); the spine tying todo<->doin<->tada<->worktree.
  <body-file>  optional; the job body. If omitted, read from stdin (or a
               one-line placeholder).
  --identity   optional stable directive identity (a key for the PR comment/
               review that triggered the work); collapses jobs from different
               producers onto ONE open job. Also via GARDEN_JOB_IDENTITY.
  --provider-canary <provider> <tier>
               post a bounded, provider-constrained tier canary. It writes
               `provider:`, `tier:`, and `dispatch: canary`; its body must not
               name a concrete `model:`. Ordinary automatic jobs stay minion.
EOF
}

# Intercept help BEFORE consuming the positional, so a '--help' typo cannot be
# posted verbatim as a real job basename.
case "${1:-}" in -h|--help) usage; exit 0;; esac

# --- option parse: --identity / --role may precede the positionals -----------
# --role stamps the performing role (designer, builder, …) into the job body's
# leading `role:` frontmatter, which the gardener handler resolves to a per-role
# default model (common.sh role_default_model). Distinct from a directive
# identity; both are optional and may appear in either order before the base.
identity="${GARDEN_JOB_IDENTITY:-}"
role=""
canary_provider=""
canary_tier=""
while [ $# -gt 0 ]; do
  case "$1" in
    --identity)   identity="${2:?--identity needs a value}"; shift 2;;
    --identity=*) identity="${1#--identity=}"; shift;;
    --role)       role="${2:?--role needs a value}"; shift 2;;
    --role=*)     role="${1#--role=}"; shift;;
    --provider-canary) canary_provider="${2:?--provider-canary needs a provider}"; canary_tier="${3:?--provider-canary needs a tier}"; shift 3;;
    --)           shift; break;;
    -*)           die "unknown option: '$1' (usage: post-job.sh [--identity <key>] [--role <role>] <basename> [body-file])";;
    *)            break;;
  esac
done

base="${1:?usage: post-job.sh [--identity <key>] <basename> [body-file]}"
body_src="${2:-}"

case "$base" in
  -*)        die "illegal basename: '$base' (names must not start with '-'; run --help for usage)";;
  */*|.*|'') die "illegal basename: '$base'";;
esac

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline body STRING passed where a body-FILE path is expected).
# Without this, read_body falls through to `cat` on stdin — and with a non-tty
# stdin (every background / `claude -p` / systemd context) that blocks forever,
# wedging the shared producer lock (garden-harden-producer-body-read-hang). Fail
# fast, mirroring journal-entry.sh and land-journal-edit.sh.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$2 empty for a placeholder)"
fi

# Producer uses a shared clone (one is fine; posts don't compete on a worktree).
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

read_body() {
  if   [ -n "$body_src" ] && [ -f "$body_src" ]; then cat "$body_src"
  elif [ ! -t 0 ];                                then cat
  else printf '# %s\n\n(posted %s by %s)\n' "$base" "$(date -u +%FT%TZ)" "$GARDEN"
  fi
}
BODY="$(read_body)"

# This is the automatic producer choke point.  No watcher, scheduler, follow-up,
# auction, or role-generated job can retain a Claude pin during the quota route.
if [ -n "$canary_provider" ]; then
  case "$canary_provider" in anthropic|openai|local|moonshot|fireworks) ;; *) die "unknown canary provider '$canary_provider'";; esac
  case "$canary_tier" in mentat|mentor|minion|myrmidon) ;; *) die "unknown canary tier '$canary_tier'";; esac
  [ -n "$(tier_model_for_provider "$canary_tier" "$canary_provider")" ] \
    || die "provider '$canary_provider' has no reviewed model in tier '$canary_tier'"
  if printf '%s\n' "$BODY" | grep -q '^model:[[:space:]]'; then
    die "provider canaries select a tier, not a concrete model: remove model: from the body"
  fi
  BODY="$(printf '%s\n' "$BODY" | awk -v provider="$canary_provider" -v tier="$canary_tier" '
    function trim(s){sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);return s}
    { line[++n]=$0 }
    END {
      if (n && line[1]=="---") for(i=2;i<=n;i++) if(line[i]=="---"){end=i;break}
      if (!end) { print "---"; print "provider: " provider; print "tier: " tier; print "dispatch: canary"; print "---"; for(i=1;i<=n;i++) print line[i]; exit }
      seenprovider=seentier=seendispatch=0
      for(i=1;i<end;i++) {
        if(i==1){print line[i]; continue}
        if(line[i] ~ /^provider:[ \t]*/) { print "provider: " provider; seenprovider=1; continue }
        if(line[i] ~ /^tier:[ \t]*/) { print "tier: " tier; seentier=1; continue }
        if(line[i] ~ /^dispatch:[ \t]*/) { print "dispatch: canary"; seendispatch=1; continue }
        print line[i]
      }
      if (!seenprovider) print "provider: " provider
      if (!seentier) print "tier: " tier
      if (!seendispatch) print "dispatch: canary"
      for(i=end;i<=n;i++) print line[i]
    }')"
elif [ "${GARDEN_MANUAL_DISPATCH:-}" = 1 ]; then
  manual_tier="$(printf '%s\n' "$BODY" | sed -n '2,/^---$/s/^tier:[[:space:]]*//p' | head -1)"
  [ "$manual_tier" = mentat ] || die "manual dispatch may select only tier: mentat"
else
  BODY="$(printf '%s\n' "$BODY" | automatic_route_body)"
fi

# --role: stamp the performing role into the body's leading YAML frontmatter so
# the gardener handler can resolve a per-role default model. If the body already
# opens with a `---` frontmatter block, insert the field just after it (unless a
# `role:` is already present there — never clobber an explicit one); otherwise
# prepend a fresh frontmatter block. A body that names its own `role:` wins.
if [ -n "$role" ]; then
  first_line="$(printf '%s\n' "$BODY" | head -1)"
  if [ "$first_line" = "---" ]; then
    if printf '%s\n' "$BODY" | sed -n '2,/^---$/p' | grep -q '^role:[[:space:]]'; then
      log "body already carries a role: field; not overriding with --role '$role'"
    else
      BODY="$(printf '%s\n' "$BODY" | sed "1a role: $role")"
    fi
  else
    BODY="$(printf -- '---\nrole: %s\n---\n\n%s' "$role" "$BODY")"
  fi
fi

# No explicit identity → best-effort derive one from the body (a hand-named peer
# job that quotes the triggering comment URL still dedups). A body that cites zero
# or several distinct comment URLs yields none, leaving behavior unchanged.
if [ -z "$identity" ]; then
  identity="$(derive_job_identity_from_body "$BODY" || true)"
  [ -n "$identity" ] && log "derived directive identity '$identity' from body for '$base'"
fi
[ -n "$identity" ] && idhash="$(job_id_hash "$identity")" || idhash=""

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  # Basename dedup. A same-named LIVE job (plan/todo/doin) is always a no-op — the base
  # is the reservation spine, and a live copy means the work is queued/running (this is
  # also how two producers sharing a base convention — the CI-status auto-shepherd and a
  # manual "shepherd" — coordinate). A COMPLETED job (tada) only blocks when the caller
  # gave NO directive identity: with an identity, the jobs/index map (checked just below,
  # and it counts tada via job_in_lifecycle) is the authoritative re-see guard, so a
  # FRESH directive that merely derives the same (PR,verb) base as a finished job is NOT
  # swallowed by that stale tada entry — the endo-but-for-bots #671 "Shepherd." drop,
  # where a 2026-07-10 auto-shepherd in tada/ silently deduped a fresh 2026-07-15
  # maintainer directive of the same base. Without an identity, tada still blocks, so a
  # plain triager re-seeing an old completed change stays idempotent as before.
  if [ -e "$DIR/$JOBS_PLAN/$base.md" ] || [ -e "$DIR/$JOBS_TODO/$base.md" ] \
     || [ -e "$DIR/$JOBS_DOIN/$base.md" ] \
     || { [ -z "$idhash" ] && tada_exists "$DIR" "$base"; }; then
    log "job '$base' already present in lifecycle; nothing to do"
    exit 0
  fi

  # Directive-identity dedup: if this directive already owns a LIVE job (under
  # any base, from any producer), do not mint a second one. A stale entry — the
  # owning base has drained out of the lifecycle — is re-pointed below, so a
  # genuinely new directive is never blocked by a completed one.
  idx="$DIR/$JOBS_INDEX/$idhash"
  if [ -n "$idhash" ] && [ -f "$idx" ]; then
    owner="$(sed -n 's/^base:[[:space:]]*//p' "$idx" | head -1)"
    owner_id="$(sed -n 's/^identity:[[:space:]]*//p' "$idx" | head -1)"
    if [ "$owner_id" != "$identity" ]; then
      # sha1-16 collision between two DISTINCT identities (astronomically rare):
      # never fold them onto one job. Post WITHOUT indexing rather than corrupt
      # the entry; the base-level dedup still applies.
      log "WARN: identity-hash collision on '$idhash' ('$owner_id' != '$identity'); posting '$base' unindexed"
      idhash=""
    elif [ -n "$owner" ] && job_in_lifecycle "$DIR" "$owner"; then
      log "directive '$identity' already owns live job '$owner'; not minting '$base' (dedup)"
      exit 0
    fi
  fi

  mkdir -p "$DIR/$JOBS_TODO"
  printf '%s\n' "$BODY" > "$DIR/$JOBS_TODO/$base.md"
  git -C "$DIR" add "$JOBS_TODO/$base.md"
  if [ -n "$idhash" ]; then
    mkdir -p "$DIR/$JOBS_INDEX"
    printf 'base: %s\nidentity: %s\n' "$base" "$identity" > "$idx"
    git -C "$DIR" add "$JOBS_INDEX/$idhash"
  fi
  if commit_and_push "$DIR" "todo($base) posted by $GARDEN${identity:+ [id:$identity]}"; then
    log "posted '$base'${identity:+ (identity '$identity')}"
    exit 0
  fi
  log "post of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not post '$base' after retries"
