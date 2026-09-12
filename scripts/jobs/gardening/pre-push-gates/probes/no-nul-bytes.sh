#!/bin/bash
# no-nul-bytes.sh -- reject literal NUL bytes in changed text files.
#
# A single NUL byte (U+0000) makes git treat a file as BINARY: `git diff` and
# GitHub's review UI then render only "Binary files a/x and b/x differ" and
# suppress the line-level diff entirely. A NUL smuggled into an otherwise textual
# file therefore hides that file's substantive change from human review. This
# probe fails when a changed text file carries any NUL byte, so the author is
# forced to spell the character with a TEXTUAL ESCAPE (`\0`, `\x00`,
# `String.fromCharCode(0)`, `Buffer.from([0])`, etc.) that keeps the file text
# and its diff reviewable.
#
# Provenance: a test file that embedded literal NULs went binary and hid its
# substantive diff from GitHub review; the fix is to require textual escapes.
#
# HOW IT WORKS: the probe walks the changed files (staged diff, else the unstaged
# working-tree diff, or `<base>...HEAD` when the driver supplies `--base-ref`) and
# reads each file's POST-CHANGE content, checking for a NUL byte. Because a NUL
# makes the whole file binary, git produces no added-line ranges to inspect, so
# the check is whole-file rather than added-line-scoped; any NUL in a file the
# change touches fails. The content is streamed straight into the detector — never
# captured in a shell variable, which would silently strip NULs.
#
# SCOPE LIMITS (narrow by design, skills/pre-push-gates § Pitfalls): the probe
# skips paths that are legitimately binary, so it never flags a real asset:
#   * a curated denylist of known-binary extensions (images, archives, fonts,
#     media, compiled objects, ...);
#   * `references/` (vendored snapshots) and `node_modules/`;
#   * any file the repository itself declares binary via a gitattributes `-diff`
#     (or `binary`) attribute -- the principled per-file escape hatch for an
#     intentionally-binary fixture with an otherwise-textual name.

set -uo pipefail

# is_probably_binary -- a known-binary extension the probe never inspects.
is_probably_binary() {
  case "${1,,}" in
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.ico|*.bmp|*.tif|*.tiff|*.avif|*.heic) return 0 ;;
    *.pdf|*.zip|*.gz|*.tgz|*.bz2|*.xz|*.zst|*.7z|*.rar|*.tar|*.jar|*.war) return 0 ;;
    *.woff|*.woff2|*.ttf|*.otf|*.eot) return 0 ;;
    *.mp3|*.mp4|*.wav|*.ogg|*.opus|*.flac|*.webm|*.mov|*.avi|*.mkv|*.m4a|*.m4v) return 0 ;;
    *.wasm|*.class|*.node|*.bin|*.exe|*.dll|*.so|*.dylib|*.o|*.a|*.obj|*.lib) return 0 ;;
    *.db|*.sqlite|*.sqlite3|*.dat|*.pack|*.idx|*.snap|*.keystore|*.jks|*.p12) return 0 ;;
    *) return 1 ;;
  esac
}

# out_of_scope -- vendored / dependency trees the probe never inspects.
out_of_scope() {
  case "$1" in
    references/*|*/references/*|node_modules/*|*/node_modules/*) return 0 ;;
    *) return 1 ;;
  esac
}

# declared_binary -- the repository marks this path binary via gitattributes
# (`binary`, or `-diff`), the intentional-binary escape hatch. `git check-attr`
# prints `<path>: diff: unset` when the diff attribute is turned off.
declared_binary() {
  local file="$1" attr
  attr=$(git check-attr diff -- "$file" 2>/dev/null) || return 1
  case "$attr" in
    *": diff: unset") return 0 ;;
    *) return 1 ;;
  esac
}

# file_content -- the post-change bytes of one file, matching the diff the probe
# selected: HEAD in base-ref mode, the index for a staged change, else the
# working tree. NEVER captured into a variable (that strips NULs); only streamed.
file_content() {
  local file="$1"
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then cat "$file" 2>/dev/null; return; fi
  if git diff --staged --quiet -- "$file" 2>/dev/null; then
    cat "$file" 2>/dev/null
  else
    git show ":$file" 2>/dev/null || cat "$file" 2>/dev/null
  fi
}

# nul_finding -- print one `fail:` line and return 1 when the file carries a NUL,
# else return 0. The content is piped straight into perl so NUL bytes survive;
# only the (NUL-free) report line is captured.
nul_finding() {
  local file="$1" out rc=0
  out=$(file_content "$file" | NUL_PROBE_FILE="$file" perl -0777 -ne '
    my $first = index($_, "\x00");
    exit 0 if $first < 0;
    my $count = () = /\x00/g;
    printf "fail: %s carries %d NUL byte(s) (first at byte offset %d); a literal NUL makes the file binary and hides its diff from review -- spell the character with a textual escape such as \\0, \\x00, or String.fromCharCode(0)\n",
      $ENV{NUL_PROBE_FILE}, $count, $first;
    exit 1;
  ') || rc=1
  [ -n "$out" ] && printf '%s\n' "$out"
  return "$rc"
}

run_probe() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }

  local files findings=0 file
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    files=$(git diff "$PRE_PUSH_BASE_REF"...HEAD --name-only --diff-filter=d 2>/dev/null)
  else
    files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
    [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)
  fi

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    out_of_scope "$file" && continue
    is_probably_binary "$file" && continue
    declared_binary "$file" && continue
    [ -f "$file" ] || continue
    nul_finding "$file" || findings=$((findings + 1))
  done <<EOF
$files
EOF

  if [ "$findings" -eq 0 ]; then
    echo pass
    return 0
  fi
  return 1
}

run_probe "${1:-.}"
