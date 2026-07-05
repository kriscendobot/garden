#!/bin/bash
# post-job.sh — producer primitive: put a job onto the board's todo/.
#
# Usage: post-job.sh [--identity <key>] <basename> [<body-file>]
#   <basename>   reserved job name; the spine that ties todo↔doin↔tada↔worktree.
#                Must be filesystem- and git-ref-safe; keep it short.
#   <body-file>  optional file whose contents become the job body. If omitted,
#                the body is read from stdin (or a one-line placeholder).
#   --identity   optional stable directive identity (see below). May also be
#                supplied via the GARDEN_JOB_IDENTITY env var.
#
# Idempotent by BASENAME: if <basename> already exists anywhere in the lifecycle
# (plan/todo/doin/tada) the post is a no-op success — a triager that re-sees the
# same change across ticks will not duplicate the job, provided the basename
# is derived deterministically from the change identity. plan/ counts: a job the
# proxy parked as blocked (proxy.sh park_blocked_jobs moves the ONLY live copy
# there) must not be re-minted into todo/ by a producer re-seeing the directive —
# that would run the "blocked" job AND let promote-plan.sh later clobber it with
# the stale plan body.
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
while [ $# -gt 0 ]; do
  case "$1" in
    --identity)   identity="${2:?--identity needs a value}"; shift 2;;
    --identity=*) identity="${1#--identity=}"; shift;;
    --role)       role="${2:?--role needs a value}"; shift 2;;
    --role=*)     role="${1#--role=}"; shift;;
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
  if [ -e "$DIR/$JOBS_PLAN/$base.md" ] || [ -e "$DIR/$JOBS_TODO/$base.md" ] \
     || [ -e "$DIR/$JOBS_DOIN/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
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
