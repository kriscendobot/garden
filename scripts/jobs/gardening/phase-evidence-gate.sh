#!/bin/bash
# phase-evidence-gate.sh -- keep an ordered design's prerequisites and
# acceptance evidence attached to the implementation PR that claims to deliver it.

set -uo pipefail

usage() {
  cat >&2 <<'EOF'
usage: phase-evidence-gate.sh <author|panel> <worktree>
       [--base <ref>] [--head <ref>] [--body-file <file>]
       [--repo <owner/name> --pr <number>] [--draft <yes|no>]
       [--evidence-file <file>]

Exit 0: clear (or an author-time draft probe / orchestrated slice)
Exit 10: relevant ordered design; the integrator must compare the ledger to it
Exit 20: blocked; the artifact cannot become review-ready
Exit 30: panel-time probe or orchestrated slice with a well-formed ledger; the
         panel reviews the code and its disposition stands, but the PR must not
         be un-drafted while the ledger says it is not the deliverable
Exit 3: body or governing design could not be read
EOF
}

mode="${1:-}"
worktree="${2:-}"
[ "$mode" = author ] || [ "$mode" = panel ] || { usage; exit 2; }
[ -n "$worktree" ] || { usage; exit 2; }
shift 2

base=""
head=HEAD
body_file=""
repo=""
pr=""
draft=yes
evidence_file=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --base) base="${2:?--base needs a ref}"; shift 2 ;;
    --head) head="${2:?--head needs a ref}"; shift 2 ;;
    --body-file) body_file="${2:?--body-file needs a file}"; shift 2 ;;
    --repo) repo="${2:?--repo needs owner/name}"; shift 2 ;;
    --pr) pr="${2:?--pr needs a number}"; shift 2 ;;
    --draft) draft="${2:?--draft needs yes or no}"; shift 2 ;;
    --evidence-file) evidence_file="${2:?--evidence-file needs a file}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 2 ;;
  esac
done

case "$draft" in yes|no) ;; *) usage; exit 2 ;; esac
worktree="$(cd "$worktree" 2>/dev/null && pwd)" || {
  echo "phase-evidence-verdict=undetermined reason=missing-worktree"
  exit 3
}

temporary_directory="$(mktemp -d "${TMPDIR:-/tmp}/phase-evidence.XXXXXX")"
trap 'rm -rf "$temporary_directory"' EXIT

body="$temporary_directory/body.md"
if [ -n "$body_file" ]; then
  [ -r "$body_file" ] || {
    echo "phase-evidence-verdict=undetermined reason=missing-body"
    exit 3
  }
  cp "$body_file" "$body"
elif [ -n "$repo" ] && [[ "$pr" =~ ^[0-9]+$ ]]; then
  GH="${GARDEN_GH:-gh}"
  if ! "$GH" pr view "$pr" --repo "$repo" --json body --jq '.body // ""' > "$body"; then
    echo "phase-evidence-verdict=undetermined reason=body-query-failed"
    exit 3
  fi
else
  echo "phase-evidence-verdict=undetermined reason=no-body-source"
  exit 3
fi

# Resolve a bare base branch name to its remote-tracking tip, as panel.sh does.
# A local branch in a per-job worktree can be stale against origin, and a diff
# from it counts the base's own advance as PR changes (endojs/endo-but-for-bots
# #1370). An explicit `origin/...`, a sha, or `HEAD~N` is left untouched.
case "$base" in
  ''|*/*|HEAD*|[0-9a-f][0-9a-f][0-9a-f][0-9a-f]*) ;;
  *)
    if git -C "$worktree" rev-parse --verify --quiet "refs/remotes/origin/$base^{commit}" >/dev/null 2>&1; then
      base="origin/$base"
    fi
    ;;
esac

design_paths="$temporary_directory/design-paths"
: > "$design_paths"
changed_paths="$temporary_directory/changed-paths"
: > "$changed_paths"
diff_known=0
has_non_design_change=0
# A design referenced by the body is governing evidence even when the PR does not
# edit the design. Changed design files are included because a PR can introduce or
# amend its own governing contract without naming the path in prose.
grep -Eo '([[:alnum:]_.-]+/)*designs/[[:alnum:]_./-]+\.md|(^|[[:space:]`(])DESIGN[[:alnum:]_.-]*\.md' "$body" 2>/dev/null \
  | sed -E 's/^[[:space:]`(]+//' >> "$design_paths" || true
if [ -n "$base" ] \
   && git -C "$worktree" rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1 \
   && git -C "$worktree" rev-parse --verify --quiet "$head^{commit}" >/dev/null 2>&1; then
  if git -C "$worktree" diff --name-only "$base...$head" > "$changed_paths" 2>/dev/null; then
    diff_known=1
    grep -E '(^|/)designs/.*\.md$|(^|/)DESIGN[^/]*\.md$' "$changed_paths" >> "$design_paths" || true
    while IFS= read -r changed_path; do
      [ -n "$changed_path" ] || continue
      case "$changed_path" in
        designs/*.md|*/designs/*.md|DESIGN*.md|*/DESIGN*.md) ;;
        *) has_non_design_change=1; break ;;
      esac
    done < "$changed_paths"
  fi
fi
sort -u "$design_paths" -o "$design_paths"

# A design proposal can define the ordered sequence; it is not an implementation
# claiming to deliver that sequence. Only implementation/code diffs owe the
# ledger. When the diff is known and design-only, leave it to the design panel.
if [ "$diff_known" -eq 1 ] && [ "$has_non_design_change" -eq 0 ] \
   && [ -s "$changed_paths" ]; then
  echo "phase-evidence-verdict=clear reason=design-only-diff"
  exit 0
fi

triggered_designs="$temporary_directory/triggered-designs"
phase_ids="$temporary_directory/phase-ids"
: > "$triggered_designs"
: > "$phase_ids"
tests_are_not_evidence=0
unresolved_designs=0

while IFS= read -r path; do
  [ -n "$path" ] || continue
  case "$path" in
    designs/*.md|*/designs/*.md|DESIGN*.md|*/DESIGN*.md) ;;
    *) continue ;;
  esac
  design="$temporary_directory/design.$(printf '%s' "$path" | cksum | awk '{print $1}')"
  if ! git -C "$worktree" show "$head:$path" > "$design" 2>/dev/null; then
    if [ "$head" = HEAD ] && [ -r "$worktree/$path" ]; then
      cp "$worktree/$path" "$design"
    else
      unresolved_designs=$((unresolved_designs + 1))
      continue
    fi
  fi

  sequence=0
  acceptance=0
  stop_gate=0
  grep -Eiq '^#{2,}[[:space:]].*(production|implementation|deployment|rollout|migration).*(sequence|phase)|^#{2,}[[:space:]].*sequence.*(stop|gate)|implementation proceeds in (this|numbered) order|ordered prerequisites?' "$design" \
    && sequence=1
  grep -Eiq '^#{2,}[[:space:]].*acceptance[[:space:]]+(evidence|criteria)' "$design" \
    && acceptance=1
  grep -Eiq 'stop[ -]?gates?|no later gate re-opens|prerequisite.*(must|before)' "$design" \
    && stop_gate=1

  if { [ "$sequence" -eq 1 ] && [ "$acceptance" -eq 1 ]; } || [ "$stop_gate" -eq 1 ]; then
    printf '%s\n' "$path" >> "$triggered_designs"
    awk '
      BEGIN { in_sequence=0 }
      /^#{2,}[[:space:]]/ {
        lower=tolower($0)
        if (lower ~ /(production|implementation|deployment|rollout|migration).*(sequence|phase)/ ||
            lower ~ /sequence.*(stop|gate)/) {
          in_sequence=1
        } else if (in_sequence) {
          exit
        }
        next
      }
      in_sequence && /^[0-9]+\./ {
        line=$0
        sub(/\..*/, "", line)
        print line
      }
    ' "$design" >> "$phase_ids"
    grep -Eiq '(code inspection|unit tests?).{0,80}(not|aren.t).{0,40}production evidence|unit tests?.{0,80}(prerequisites?|insufficient)' "$design" \
      && tests_are_not_evidence=1
  fi
done < "$design_paths"
sort -nu "$phase_ids" -o "$phase_ids"

trigger_count="$(wc -l < "$triggered_designs" | tr -d ' ')"
body_flat="$(tr '\n' ' ' < "$body")"
body_phase_signal=0
if printf '%s\n' "$body_flat" | grep -Eiq 'production sequence|stop[ -]?gate|acceptance evidence|steps?[[:space:]]+[0-9]|phase[[:space:]]+[0-9]'; then
  body_phase_signal=1
fi

if [ "$trigger_count" -eq 0 ]; then
  if [ "$body_phase_signal" -eq 1 ] && [ "$unresolved_designs" -gt 0 ]; then
    echo "phase-evidence-verdict=undetermined reason=governing-design-unresolved unresolved=$unresolved_designs"
    exit 3
  fi
  echo "phase-evidence-verdict=clear reason=no-ordered-design-signal"
  exit 0
fi

ledger_start='<!-- garden-phase-evidence-ledger:v1 -->'
ledger_end='<!-- /garden-phase-evidence-ledger -->'
start_count="$(grep -Fxc "$ledger_start" "$body" 2>/dev/null || true)"
end_count="$(grep -Fxc "$ledger_end" "$body" 2>/dev/null || true)"
findings="$temporary_directory/findings"
: > "$findings"
if [ "$start_count" -ne 1 ] || [ "$end_count" -ne 1 ]; then
  echo "missing-or-duplicate-ledger-markers" >> "$findings"
  ledger="$temporary_directory/ledger"
  : > "$ledger"
else
  ledger="$temporary_directory/ledger"
  awk -v start="$ledger_start" -v end="$ledger_end" '
    $0 == start { inside=1; next }
    $0 == end { inside=0; exit }
    inside { print }
  ' "$body" > "$ledger"
fi

if ! grep -Eiq '^##[[:space:]]+Phase and evidence ledger[[:space:]]*$' "$ledger" 2>/dev/null; then
  echo "missing-visible-ledger-heading" >> "$findings"
fi

field_value() { # field_value <name>
  local name="$1"
  awk -F: -v wanted="$name" '
    tolower($1) == tolower(wanted) {
      sub(/^[^:]*:[[:space:]]*/, "")
      print
      exit
    }
  ' "$ledger" 2>/dev/null
}

disposition="$(field_value Disposition | tr '[:upper:]' '[:lower:]' | tr -d '`' | xargs 2>/dev/null)"
# deliverable: the PR claims the design's full sequence and acceptance bar.
# non-deliverable-probe: an exploratory slice; draft forever (gap-revealing).
# orchestrated-slice: real code for some phases of a design whose remaining
#   phases a named successor job or orchestration owns. It is reviewed like any
#   build (the gauntlet runs), but it stays draft until the successor supplies
#   the evidence and the ledger turns `deliverable` (builder-pr-gauntlet-bypass,
#   kriscendobot/minion.town#148).
case "$disposition" in
  deliverable|non-deliverable-probe|orchestrated-slice) ;;
  *) echo "invalid-disposition" >> "$findings" ;;
esac
held_disposition=0
case "$disposition" in non-deliverable-probe|orchestrated-slice) held_disposition=1 ;; esac
open_phases="$temporary_directory/open-phases"
: > "$open_phases"

ledger_designs="$temporary_directory/ledger-designs"
grep -Eo '([[:alnum:]_.-]+/)*designs/[[:alnum:]_./-]+\.md|(^|[[:space:]`(])DESIGN[[:alnum:]_.-]*\.md' "$ledger" 2>/dev/null \
  | sed -E 's/^[[:space:]`(]+//' | sort -u > "$ledger_designs" || true
while IFS= read -r path; do
  grep -Fqx "$path" "$ledger_designs" || echo "missing-design:$path" >> "$findings"
done < "$triggered_designs"

phase_records="$temporary_directory/phase-records"
sed -nE 's/^[[:space:]]*[Pp]hase[[:space:]]+([0-9]+):[[:space:]]*([^|]+)\|[[:space:]]*(.+)$/\1|\2|\3/p' "$ledger" \
  | sed -E 's/[[:space:]]*\|[[:space:]]*/|/g' > "$phase_records"
while IFS= read -r id; do
  [ -n "$id" ] || continue
  record="$(awk -F'|' -v wanted="$id" '$1 == wanted { print; exit }' "$phase_records")"
  if [ -z "$record" ]; then
    echo "missing-phase:$id" >> "$findings"
    continue
  fi
  status="$(printf '%s' "$record" | cut -d'|' -f2 | tr '[:upper:]' '[:lower:]' | xargs)"
  evidence="$(printf '%s' "$record" | cut -d'|' -f3-)"
  [ -n "$(printf '%s' "$evidence" | xargs)" ] || echo "missing-phase-evidence:$id" >> "$findings"
  case "$status" in
    satisfied|superseded|not-applicable) ;;
    *)
      echo "$id:$status" >> "$open_phases"
      [ "$disposition" != deliverable ] || echo "open-phase:$id:$status" >> "$findings"
      ;;
  esac
done < "$phase_ids"

acceptance_record="$(sed -nE 's/^[[:space:]]*[Aa]cceptance:[[:space:]]*([^|]+)\|[[:space:]]*(.+)$/\1|\2/p' "$ledger" | head -1)"
if [ -z "$acceptance_record" ]; then
  echo "missing-acceptance" >> "$findings"
else
  acceptance_status="$(printf '%s' "$acceptance_record" | cut -d'|' -f1 | tr '[:upper:]' '[:lower:]' | xargs)"
  acceptance_evidence="$(printf '%s' "$acceptance_record" | cut -d'|' -f2-)"
  [ -n "$(printf '%s' "$acceptance_evidence" | xargs)" ] || echo "missing-acceptance-evidence" >> "$findings"
  if [ "$disposition" = deliverable ] && [ "$acceptance_status" != satisfied ]; then
    echo "acceptance-not-satisfied:$acceptance_status" >> "$findings"
  fi
  if [ "$disposition" = deliverable ] && [ "$tests_are_not_evidence" -eq 1 ] \
     && printf '%s' "$acceptance_evidence" | grep -Eiq 'tests?|typecheck|lint' \
     && ! printf '%s' "$acceptance_evidence" | grep -Eiq 'production|deployed|canary|browser|daemon|live|log|receipt|observation'; then
    echo "tests-substitute-for-production-evidence" >> "$findings"
  fi
fi

body_declares_open=0
if printf '%s\n' "$body_flat" | grep -Eiq \
  '(^|[. ;])(unmerged|unlanded)([. ;]|$)|steps?[^.]{0,160}(not attempted|deferred|out of scope)|((prerequisite|stop[ -]?gate)[^.]{0,120}(open|unresolved|unmerged|unlanded))|((default|currently|still|until)[^.]{0,120}(unavailable|fail[s]?[ -]?closed))|((unavailable|fail[s]?[ -]?closed)[^.]{0,120}(default|production seam|until))|acceptance evidence[^.]{0,120}(absent|missing|deferred|not run)'; then
  body_declares_open=1
fi
if [ "$held_disposition" -eq 0 ] && [ "$body_declares_open" -eq 1 ]; then
  echo "body-declares-open-prerequisite-or-evidence" >> "$findings"
fi

if [ "$disposition" = non-deliverable-probe ]; then
  probe_reason="$(field_value Probe-reason)"
  [ -n "$(printf '%s' "$probe_reason" | xargs 2>/dev/null)" ] || echo "missing-probe-reason" >> "$findings"
  if [ "$draft" != yes ]; then
    echo "probe-not-draft" >> "$findings"
  fi
fi
successor=""
if [ "$disposition" = orchestrated-slice ]; then
  # The successor is the durable owner of the remaining phases: a job base or an
  # orchestration base (or a PR/issue reference). One token, no prose, so a
  # sensor can resolve it and the maintainer can find it.
  successor="$(field_value Successor | tr -d '`' | xargs 2>/dev/null)"
  if [ -z "$successor" ]; then
    echo "missing-successor" >> "$findings"
  elif ! printf '%s' "$successor" | grep -Eq '^[A-Za-z0-9][A-Za-z0-9._/#:-]*$'; then
    echo "invalid-successor" >> "$findings"
  fi
  if [ "$draft" != yes ]; then
    echo "slice-not-draft" >> "$findings"
  fi
fi

design_list="$(paste -sd, "$triggered_designs")"
phase_list="$(paste -sd, "$phase_ids")"
if [ -s "$findings" ]; then
  finding_list="$(paste -sd, "$findings")"
  summary="phase-evidence-verdict=blocked disposition=${disposition:-invalid} designs=[$design_list] phases=[$phase_list] findings=[$finding_list]"
  printf '%s\n' "$summary"
  if [ -n "$evidence_file" ]; then
    {
      echo "$summary"
      echo "The governing design declares an ordered sequence, stop gate, or acceptance-evidence bar."
      echo "A deliverable must account for every numbered phase and satisfy the design's acceptance evidence; tests alone do not replace production observations when the design says so."
    } > "$evidence_file"
  fi
  exit 20
fi

open_list="$(paste -sd, "$open_phases")"
if [ "$held_disposition" -eq 1 ]; then
  if [ "$mode" = author ]; then
    verdict=probe
    [ "$disposition" = non-deliverable-probe ] || verdict=slice
    summary="phase-evidence-verdict=$verdict disposition=$disposition draft=yes designs=[$design_list] phases=[$phase_list] open=[$open_list]${successor:+ successor=$successor}"
    printf '%s\n' "$summary"
    [ -z "$evidence_file" ] || printf '%s\n' "$summary" > "$evidence_file"
    exit 0
  fi
  # Panel time. A fixer cannot close a production phase another job owns, so an
  # open phase here must not become a must-fix finding: six rounds on #148 ended
  # must-fix on exactly that. Report the open phases once, let the seats judge the
  # code, and withhold only the un-draft (the gauntlet driver re-reads the ledger
  # before its un-draft stage).
  summary="phase-evidence-verdict=hold-draft disposition=$disposition designs=[$design_list] phases=[$phase_list] open=[$open_list]${successor:+ successor=$successor} undraft=withheld"
  printf '%s\n' "$summary"
  if [ -n "$evidence_file" ]; then
    {
      echo "$summary"
      echo "The ledger says this PR is not the design's deliverable: open phases [$open_list]${successor:+ are owned by $successor}."
      echo "Review the code in the diff on its merits. Do not request changes for the open phases; a fixer cannot close them, and the PR stays draft until the ledger turns deliverable."
      echo "Do request changes if the ledger misstates which phases this diff covers, or if a phase it claims is unsupported by the diff."
    } > "$evidence_file"
  fi
  exit 30
fi

summary="phase-evidence-verdict=attention disposition=deliverable designs=[$design_list] phases=[$phase_list] acceptance=satisfied"
printf '%s\n' "$summary"
if [ -n "$evidence_file" ]; then
  {
    echo "$summary"
    echo "Compare every ledger row with the governing design's sequence and acceptance section."
    echo "Confirm that cited evidence is production evidence where the design distinguishes it from code inspection or unit tests."
  } > "$evidence_file"
fi
if [ "$mode" = panel ]; then exit 10; fi
exit 0
