#!/bin/bash
# detect-catch-all-swallow.sh — deterministic (no-LLM) detector for a CATCH-ALL
# ERROR SWALLOW landing in a proposed change. It scans the change's ADDED diff
# lines (the new code, not pre-existing context) for a try/catch `catch` block
# whose body neither NARROWS on an error class/code nor RETHROWS/LOGS — i.e. a
# bare `catch {}` / `catch { return undefined }` / `catch (e) { return false }`
# that quietly discards EVERY error class.
#
# Why a third enforcement site: error-swallowing is nominally covered at review
# by the saboteur juror (skills/saboteur-adversarial-review, skills/adversarial-
# tests). But the saboteur checks the try-BODY's *width* (how much code is inside
# the try), not the catch-clause's error-class *breadth* — so a catch that eats
# all classes slips past when the try body itself looks innocuous. That miss is
# security-relevant: a swallowed error frequently feeds a confinement decision
# (a failed check silently downgraded to "allow"), so an eaten exception becomes
# a fail-open. This gate catches the swallow the moment it lands in a gardening
# diff, so the fixer can narrow/rethrow it before the panel ever sees it; the
# saboteur juror remains the semantic backstop for what the grep misses.
#
# Mirrors detect-banners.sh's discipline:
#   * QUIET BY DESIGN in `check` mode: prints nothing; answers via exit status.
#       check: exit 0 -> a catch-all swallow was added   exit 1 -> clean (quiet)
#   * FAVORS FALSE POSITIVES in what it matches: any added `catch` block whose
#     contiguous-added body contains NONE of the SAFE signals (a rethrow, an
#     `instanceof`, an error property inspection, or a log call) is flagged. It
#     is cheaper to flag a borderline swallow than to let a fail-open land; the
#     saboteur juror is the backstop.
#
# We can only speak about NEW swallows against a base: with no base ref (shallow
# clone, missing HEAD~1) there are no scannable added lines, so the honest, quiet
# answer is "no new swallow" (exit 1) — the conditional fixer downstream is an
# LLM and must not be run on noise it cannot act on.
#
# Scope: only CODE files (js/ts/jsx/tsx/mjs/cjs). Markdown/prose never match
# (excluded by extension). The body is tracked only across CONTIGUOUS added
# lines (a hunk boundary, a context line, or a removed line ends the block), so
# a catch whose body is pre-existing/unchanged code is deliberately NOT tracked
# here — the saboteur juror covers that. Promise `.catch(cb)` handlers are also
# out of scope (the try/catch statement form is what the prosecutor flagged);
# the saboteur remains the backstop for the callback form.
#
# Subcommands:
#   check <worktree> [base]   exit 0 if a catch-all swallow appears in added code
#   lines <worktree> [base]   print each offending catch opener as `<path>: <text>`
#                             (consumed by handlers/catch-all-swallow-claude.sh)
#
# base defaults to HEAD~1.

set -uo pipefail
cmd="${1:?usage: detect-catch-all-swallow.sh <check|lines> <worktree> [base]}"; shift
wt="${1:?worktree}"; shift
base="${1:-HEAD~1}"

# A base we cannot resolve means we cannot isolate the ADDED lines; clean & quiet.
git -C "$wt" rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1 || exit 1

# Walk the diff. For each `catch (...) {` opener that appears in an ADDED code
# line, accumulate the catch body across contiguous added lines by brace depth,
# then flag the block if its body carries NONE of the SAFE signals:
#   * rethrow / propagate:   throw, reject(
#   * narrow on error class: instanceof
#   * inspect error prop:    .code .name .errno .status .statusCode .message
#   * log:                   console, logger, .log( .warn( .error( .info(
#                            .debug( .trace(
# The offender is reported as `<path>: <opener line text>`.
offending_lines() {
  git -C "$wt" diff "$base" -- 2>/dev/null | awk '
    function scanclose(s,   i,c,n){          # count braces; return close index or 0
      n=length(s)
      for(i=1;i<=n;i++){ c=substr(s,i,1)
        if(c=="{") gdepth++
        else if(c=="}"){ gdepth--; if(gdepth<=0) return i } }
      return 0
    }
    function finalize(){                      # flag unless the body looks handled
      if (body !~ /throw|reject\(|instanceof|\.(code|name|errno|status|statusCode|message)|console|logger|\.(log|warn|error|info|debug|trace)\(/)
        print cpath ": " ctext
    }
    /^\+\+\+ /{
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      iscode = (path ~ /\.(js|ts|jsx|tsx|mjs|cjs)$/)
      incatch=0; next
    }
    /^@@/{ incatch=0; next }                  # hunk boundary breaks contiguity
    /^\+/{
      if(!iscode){ incatch=0; next }
      text=substr($0,2)
      if (incatch) {
        ci=scanclose(text)
        if (ci>0){ body=body "\n" substr(text,1,ci); finalize(); incatch=0 }
        else { body=body "\n" text; if(++clines>60){ finalize(); incatch=0 } }
        next
      }
      # not mid-block: look for a catch opener whose `{` is on this line.
      if (match(text, /(^|[^A-Za-z0-9_$])catch[ \t]*(\([^)]*\))?[ \t]*\{/)) {
        rest=substr(text, RSTART+RLENGTH-1)   # from the opening `{`
        gdepth=0; body=""; cpath=path; ctext=text; clines=1
        ci=scanclose(rest)
        if (ci>0){ body=substr(rest,1,ci); finalize() }   # closed on same line
        else { body=rest; incatch=1 }
      }
      next
    }
    { incatch=0 }                             # context/removed line breaks contiguity
  '
}

case "$cmd" in
  check) [ -n "$(offending_lines)" ] && exit 0 || exit 1 ;;
  lines) offending_lines ;;
  *) echo "detect-catch-all-swallow.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac
