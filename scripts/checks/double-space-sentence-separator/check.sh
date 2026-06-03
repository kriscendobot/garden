#!/bin/bash
# check.sh -- the double-space-sentence-separator gate.
#
# Fires when *new* lines added in the diff against GATE_BASE_REF
# introduce a sentence-separator pattern (`. ` or `.  ` followed by a
# capital letter) on a physical line in a markdown or comment context.
# The garden's wrap rule is sentence-per-line; multi-sentence physical
# lines that newly appear in a markdown file or a comment are the
# pattern the maintainer named on PR #3 review 4414266979.
#
# The gate is *diff-scoped* on purpose. The maintainer's directive
# ("we dispatch an agent only if these patterns are found in the diff,
# so that we do not relitigate salutations") makes the diff the right
# unit. Pre-existing multi-sentence lines in the tree are out of
# scope; only newly introduced ones fire.
#
# Honors:
#   GATE_REPO_ROOT  the directory to scan (default: $PWD).
#   GATE_BASE_REF   the git ref to diff against (default: HEAD).
#
# Output: prints offending added-lines (with file context) to stderr.
# Exits 0 if clean, 1 if any new offender is found.
#
# An initialism / salutation allowlist filters out the dominant false
# positives. The allowlist is intentionally short; adding to it is a
# judgment call the maintainer makes by editing this script.

set -uo pipefail

REPO_ROOT=${GATE_REPO_ROOT:-$PWD}
BASE_REF=${GATE_BASE_REF:-HEAD}

test -d "$REPO_ROOT" || { echo "double-space-sentence-separator: REPO_ROOT not a directory: $REPO_ROOT" >&2; exit 2; }
cd "$REPO_ROOT" || { echo "double-space-sentence-separator: cd failed: $REPO_ROOT" >&2; exit 2; }

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  # Outside a git repo we have no diff to evaluate; pass silently.
  exit 0
fi

# Resolve BASE_REF. If it's HEAD on a clean tree, there is no diff to
# inspect; we exit clean. The gate only meaningfully fires when there
# are unmerged changes to look at.
if ! git rev-parse --verify --quiet "$BASE_REF" >/dev/null 2>&1; then
  # Unknown ref; pass silently rather than failing the runner.
  exit 0
fi

# The allowlist of initialisms and salutations that legitimately appear
# as `Xxx. Yyy` mid-line. Keep short; the gate's purpose is to catch
# the sentence-separator antipattern, not to relitigate prose. Each
# entry is a literal token that, when found *before* the matched
# space, suppresses the match.
ALLOWLIST=(
  # Latin shorthand commonly used inside parenthetical asides.
  "e.g."
  "i.e."
  "cf."
  "etc."
  "et al."
  "vs."
  "viz."
  # Salutations.
  "Mr."
  "Mrs."
  "Ms."
  "Dr."
  "Prof."
  "Sr."
  "Jr."
  "St."
  # Abbreviations that frequently appear mid-sentence.
  "No."
  "vol."
  "ch."
  "p."
  "pp."
  "Fig."
  "Eq."
)

# Build the awk allowlist regex by joining tokens with `|` after
# escaping regex metacharacters. We only escape `.` because the
# allowlist has nothing else regex-special.
allow_regex=""
for tok in "${ALLOWLIST[@]}"; do
  esc=${tok//./\\.}
  if [ -z "$allow_regex" ]; then
    allow_regex="$esc"
  else
    allow_regex="${allow_regex}|$esc"
  fi
done

# Gather the file paths we care about from the diff. The gate's scope
# is .md files (markdown) and comments in source files; we approximate
# "comments" by also including .js / .ts / .sh / .py since those
# files' comment payloads frequently carry prose. .json / .yaml are
# excluded because their `. ` occurrences are typically structured
# (version pins, ids).
mapfile -t CHANGED_FILES < <(
  git diff --name-only --diff-filter=AMR "$BASE_REF"... 2>/dev/null \
    | grep -E '\.(md|js|mjs|cjs|ts|tsx|sh|py)$' || true
)

if [ "${#CHANGED_FILES[@]}" -eq 0 ]; then
  exit 0
fi

# Walk each changed file's added-lines (lines beginning with `+`,
# excluding `+++` file headers). Apply the sentence-separator regex
# and the allowlist filter.
hits=""
for f in "${CHANGED_FILES[@]}"; do
  [ -f "$f" ] || continue
  # `git diff -U0` would suppress context, but we want context to
  # report. We rely on the leading `+` to filter to added lines.
  added=$(git diff -U0 --no-color "$BASE_REF"... -- "$f" 2>/dev/null \
    | awk -v allow="$allow_regex" '
        /^\+\+\+/ { next }
        /^\+/ {
          body = substr($0, 2)
          # Strip the allowlist tokens out of a working copy of the
          # line before testing. This way a line that contains BOTH
          # an allowlisted token AND a true offender still surfaces
          # the offender.
          if (allow != "") {
            gsub(allow, "_", body)
          }
          # Match: a period followed by one or two spaces followed by
          # an ASCII capital letter. The pattern targets the
          # specific shape the maintainer named ("`. ` or `.  `").
          if (match(body, /\.  ?[A-Z]/)) {
            print $0
          }
        }
      ' 2>/dev/null || true)
  if [ -n "$added" ]; then
    if [ -z "$hits" ]; then
      hits="--- $f ---"$'\n'"$added"
    else
      hits="$hits"$'\n'"--- $f ---"$'\n'"$added"
    fi
  fi
done

if [ -n "$hits" ]; then
  printf '%s\n' "$hits" >&2
  exit 1
fi

exit 0
