#!/bin/bash
# typist-friendly-code-points.sh — pre-push-gate probe (skills/pre-push-gates § probes),
# with an auto-fix mode the gate's auto-fix stage runs before the probe pass.
#
# Deterministic (no-LLM) detector and fixer for CODE POINTS THAT ARE DIFFICULT FOR
# A TYPIST TO MAINTAIN in bot-authored markdown: `→` (U+2192) where `->` types and
# reads just as well, curly quotes, `…`, `≤`/`≥`/`≠`, the multiplication sign, and
# similar symbol/punctuation glyphs with an ASCII spelling. A glyph with no key on
# a standard keyboard makes every future human edit harder; the maintainer cannot
# retype it and either copy-pastes it forward or lets the document drift.
#
# Provenance: kriskowal review on endojs/endo-but-for-bots#124 (discussion
# r3548802060, 2026-07-11): "Avoid code points that are difficult for a typist to
# maintain. This is a standing instruction that should be in style guidance and
# observed by automation in the jury selection process and automatically fixed."
# Precipitating example: designs/daemon-endor-pet-store-sqlite.md used U+2192
# arrows throughout. Rule text: skills/typist-friendly-code-points/SKILL.md.
#
# HOW IT WORKS: the probe scans the ADDED lines of changed `.md` files (staged
# diff, else the unstaged working-tree diff), skipping fenced code blocks and
# inline code spans (a document may quote a glyph in order to talk about it, as
# the SKILL's own tables do). Two glyph classes:
#   * mechanically fixable (arrows, ellipsis, curly quotes, <=/>=/!=, x, minus,
#     no-break space): `--fix` rewrites them in place across each changed file
#     (fix on encounter, whole file) and re-stages files that were staged;
#   * judgment-only (bullet `•`, check/ballot marks): detected and failed with a
#     one-line suggestion, never rewritten (the right ASCII depends on reading).
# The em dash (U+2014) is deliberately NOT here: skills/em-dash-style owns it and
# its rewrite (period / parentheses / colon) is judgment, not substitution. The
# en dash is tolerated per the same skill. Source under src/ and lib/ is already
# covered whole by the stricter no-non-ascii-in-source probe; box-drawing by
# no-ascii-banners. Those two rules currently rely on guidance/detection and the
# panel; this executable probe covers the markdown prose surface only.
#
# SCOPE LIMITS (narrow by design, skills/pre-push-gates § Pitfalls): `.md` files
# only; `references/` (vendored snapshots) and node_modules are skipped; per-file
# escape hatch is a `typist-code-points-exempt` marker in the first five lines.
# Inline-span skipping assumes single-backtick spans (a double-backtick span's
# inner text is scanned; bias toward firing).
#
# Subcommands / usage:
#   typist-friendly-code-points.sh [<project-root>]
#       Probe mode over the staged (else unstaged) diff. Prints `pass`, or one
#       `fail:` line per distinct (file, code point); exits 0/1.
#   typist-friendly-code-points.sh --fix [<project-root>]
#       Auto-fix mode: rewrite the mechanically fixable glyphs in every changed
#       `.md` file (whole file, fences and code spans preserved), re-stage files
#       that had staged changes, print one `fixed:` line per rewritten file.
#       Exits 0 (judgment-only glyphs are left for probe mode to report).
#   typist-friendly-code-points.sh --scan-stdin [<label>]
#       Scan stdin as the full content of a file named <label> (default
#       `<stdin>`), every line treated as added. For tests / demonstration.
#   typist-friendly-code-points.sh --fix-stdin
#       Rewrite stdin to stdout. For tests / demonstration.

set -uo pipefail

# engine — one perl program, two modes. Reads the file content on stdin.
#   argv: <mode: scan|fix> <label> <ranges: "all" | "start,count start,count ...">
# scan: print `fail:` lines for blocklisted glyphs on added lines outside fences
#       and code spans; dedupe per (file, code point); exit 1 on any finding.
# fix:  print the rewritten content to stdout (substituting only outside fences
#       and code spans); report the substitution count on fd 3 if open, else /dev/null.
engine() {
  perl -CSD -e '
    use strict; use warnings; use utf8;
    my ($mode, $label, $ranges) = @ARGV;
    my %fix = (
      "\x{2192}" => "->",  "\x{2190}" => "<-",  "\x{2194}" => "<->",
      "\x{21D2}" => "=>",  "\x{21D0}" => "<=",  "\x{2026}" => "...",
      "\x{201C}" => "\"",  "\x{201D}" => "\"",  "\x{2018}" => "\x27",
      "\x{2019}" => "\x27","\x{2264}" => "<=",  "\x{2265}" => ">=",
      "\x{2260}" => "!=",  "\x{00D7}" => "x",   "\x{2212}" => "-",
      "\x{00A0}" => " ",
    );
    my %judge = (
      "\x{2022}" => "a leading \x60-\x60 bullet, or a comma between inline items",
      "\x{2713}" => "yes / [x] / PASS (pick by reading)",
      "\x{2714}" => "yes / [x] / PASS (pick by reading)",
      "\x{2717}" => "no / [ ] / FAIL (pick by reading)",
      "\x{2718}" => "no / [ ] / FAIL (pick by reading)",
    );
    my %name = (
      "\x{2192}" => "RIGHTWARDS ARROW",       "\x{2190}" => "LEFTWARDS ARROW",
      "\x{2194}" => "LEFT RIGHT ARROW",       "\x{21D2}" => "RIGHTWARDS DOUBLE ARROW",
      "\x{21D0}" => "LEFTWARDS DOUBLE ARROW", "\x{2026}" => "HORIZONTAL ELLIPSIS",
      "\x{201C}" => "LEFT DOUBLE QUOTATION MARK",  "\x{201D}" => "RIGHT DOUBLE QUOTATION MARK",
      "\x{2018}" => "LEFT SINGLE QUOTATION MARK",  "\x{2019}" => "RIGHT SINGLE QUOTATION MARK",
      "\x{2264}" => "LESS-THAN OR EQUAL TO",  "\x{2265}" => "GREATER-THAN OR EQUAL TO",
      "\x{2260}" => "NOT EQUAL TO",           "\x{00D7}" => "MULTIPLICATION SIGN",
      "\x{2212}" => "MINUS SIGN",             "\x{00A0}" => "NO-BREAK SPACE",
      "\x{2022}" => "BULLET",
      "\x{2713}" => "CHECK MARK",             "\x{2714}" => "HEAVY CHECK MARK",
      "\x{2717}" => "BALLOT X",               "\x{2718}" => "HEAVY BALLOT X",
    );
    my $class = join("", keys %fix, keys %judge);
    my $fixclass = join("", keys %fix);
    my %added;
    my $all = ($ranges eq "all");
    unless ($all) {
      for my $r (split " ", $ranges) {
        my ($start, $count) = split ",", $r;
        $count = 1 unless defined $count;
        $added{$_} = 1 for $start .. $start + $count - 1;
      }
    }
    my ($infence, $lineno, $findings, $subs) = (0, 0, 0, 0);
    my %seen;
    while (my $line = <STDIN>) {
      $lineno++;
      my $eol = ($line =~ s/\n$//) ? "\n" : "";
      if ($line =~ /^\s*(```|~~~)/) {
        $infence = !$infence;
        print $line, $eol if $mode eq "fix";
        next;
      }
      if ($infence) {
        print $line, $eol if $mode eq "fix";
        next;
      }
      # Split on backticks; even-index segments sit outside inline code spans.
      # An inside-span segment is exempt only when it QUOTES a glyph (its content
      # is nothing but blocklisted glyphs and whitespace, as the SKILL tables do);
      # a span that carries a glyph among other text (a signature like
      # `stmt.get(...) -> object`) is content and is scanned / fixed like prose.
      my @parts = split /`/, $line, -1;
      for my $i (0 .. $#parts) {
        if ($i % 2) {
          (my $stripped = $parts[$i]) =~ s/[$class\s]//g;
          next if $stripped eq "";
        }
        if ($mode eq "fix") {
          $subs += $parts[$i] =~ s/([$fixclass])/$fix{$1}/ge;
        } elsif ($all or $added{$lineno}) {
          for my $ch ($parts[$i] =~ /([$class])/g) {
            my $key = $label . "\x00" . $ch;
            next if $seen{$key}++;
            $findings++;
            my $cp = sprintf "U+%04X", ord $ch;
            if (exists $fix{$ch}) {
              printf "fail: %s:%d %s %s: type %s (auto-fixable: run with --fix)\n",
                $label, $lineno, $cp, $name{$ch}, "\x60$fix{$ch}\x60";
            } else {
              printf "fail: %s:%d %s %s: rewrite as %s\n",
                $label, $lineno, $cp, $name{$ch}, $judge{$ch};
            }
          }
        }
      }
      print join("`", @parts), $eol if $mode eq "fix";
    }
    if ($mode eq "fix") {
      my $fd3;
      open($fd3, ">&=", 3) or open($fd3, ">", "/dev/null");
      print $fd3 "$subs\n";
      exit 0;
    }
    exit($findings ? 1 : 0);
  ' -- "$@"
}

# is_exempt — a file that opts out with a `typist-code-points-exempt` marker in
# its first five lines (mirrors the ascii-exempt / spell-out-exempt hatches).
is_exempt() {
  head -5 "$1" 2>/dev/null | grep -q 'typist-code-points-exempt'
}

# wants_scan — whether a path is in the probe's scope.
wants_scan() {
  case "$1" in
    references/*|*/references/*|node_modules/*|*/node_modules/*) return 1 ;;
    *.md) return 0 ;;
    *) return 1 ;;
  esac
}

# changed_md_files — the changed `.md` paths, staged diff first, else unstaged.
changed_md_files() {
  local files
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    files=$(git diff "$PRE_PUSH_BASE_REF"...HEAD --name-only --diff-filter=d 2>/dev/null)
  else
    files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
    [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)
  fi
  local f
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    wants_scan "$f" || continue
    [ -f "$f" ] || continue
    is_exempt "$f" && continue
    printf '%s\n' "$f"
  done <<EOF
$files
EOF
}

# added_ranges_for — the added-line ranges of one file as "start,count ..." (from
# the same diff changed_md_files used), or "" when the diff carries no added lines.
added_ranges_for() {
  local f="$1" diff
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    diff=$(git diff -U0 "$PRE_PUSH_BASE_REF"...HEAD -- "$f" 2>/dev/null)
  else
    diff=$(git diff --staged -U0 -- "$f" 2>/dev/null)
    [ -z "$diff" ] && diff=$(git diff -U0 -- "$f" 2>/dev/null)
  fi
  printf '%s\n' "$diff" \
    | sed -n 's/^@@ [^+]*+\([0-9][0-9,]*\).*/\1/p' \
    | tr '\n' ' ' | sed 's/ $//'
}

run_probe() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }
  local rc=0 f ranges out
  while IFS= read -r f; do
    ranges=$(added_ranges_for "$f")
    [ -z "$ranges" ] && continue
    # shellcheck disable=SC2094 # engine writes stdout, never the input file.
    out=$(engine scan "$f" "$ranges" < "$f")
    if [ -n "$out" ]; then printf '%s\n' "$out"; rc=1; fi
  done <<EOF
$(changed_md_files)
EOF
  [ "$rc" = 0 ] && echo pass
  return "$rc"
}

run_fix() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }
  local f tmp subs
  while IFS= read -r f; do
    tmp=$(mktemp)
    # shellcheck disable=SC2094 # output is a distinct temporary file.
    subs=$( { engine fix "$f" all < "$f" > "$tmp"; } 3>&1 )
    if [ "${subs:-0}" -gt 0 ] 2>/dev/null; then
      cat "$tmp" > "$f"
      # Re-stage only when the file already had staged changes; a working-tree-only
      # edit stays unstaged for the calling step's own commit machinery.
      if [ -n "${PRE_PUSH_BASE_REF:-}" ] || [ -n "$(git diff --staged --name-only -- "$f" 2>/dev/null)" ]; then
        git add -- "$f"
      fi
      echo "fixed: $f ($subs substitutions)"
    fi
    rm -f "$tmp"
  done <<EOF
$(changed_md_files)
EOF
  return 0
}

case "${1:-}" in
  --fix)
    run_fix "${2:-.}"
    ;;
  --scan-stdin)
    engine scan "${2:-<stdin>}" all && echo pass
    ;;
  --fix-stdin)
    engine fix "<stdin>" all 3>/dev/null
    ;;
  *)
    run_probe "${1:-.}"
    ;;
esac
