#!/usr/bin/env python3
"""cnf-backlog-triple.py — the garden's open queue as an ordinal backlog measure.

Read-only, report-only. Nothing here writes to the journal, mutates a job,
changes dispatch/promotion/claiming, or persists a counter a later run reads
back. Every run RECOMPUTES from the job files themselves (§ "board-derived",
below), so any outside observer can reproduce the number without trusting a
breadcrumb the measured session wrote about itself.

Ported from jcorbin's `unum` (skills/health-vector/cnf_triple.py, the reference
implementation, read at HEAD not at the garden's stale library ingest). The
open queue is reported as a Cantor-Normal-Form triple

    (r2, r1, r0)  =  omega^2*r2 + omega*r1 + r0

and two revisions are compared with lexicographic (ordinal) `o<`, NEVER by
total count. The point, in jcorbin's words: finishing one rank-1 PLANNING task
typically REPLACES it with several rank-0 children, which raises the total
count while strictly DECREASING the triple (one fewer omega-term, finitely more
finite terms). A count-based measure reads healthy planning work as regress;
the ordinal one reads it correctly. The `--check` fixtures PIN that
disagreement — see FIXTURES.

    cnf-backlog-triple.py                       # live journal, both slices
    cnf-backlog-triple.py --slice active        # only todo+doin
    cnf-backlog-triple.py --slice total         # todo+doin+plan (default is both)
    cnf-backlog-triple.py --rev <sha>           # the board at a journal2 commit
    cnf-backlog-triple.py --compare <old> <new> # o< between two commits
    cnf-backlog-triple.py --check               # regression fixtures
    cnf-backlog-triple.py --json                # machine-readable

Two invariants (job spec, jcorbin's TADA/1172 + admission.go doc comment):

  1. RANK IS DERIVED, NEVER DECLARED. This reads NO `rank:`/`omega:` field from
     a job and never adds one. A declared rank is self-reported and gameable; a
     board-derived one is recomputable by any outside observer. `role:` IS read
     — but `role:` is assigned by the PRODUCER (it already picks the model tier
     and the AGENT.md a worker loads), not self-reported by the job, so
     deriving rank from role is still derivation, not declaration.

  2. THE MEASURE IS BOARD-DERIVED. Recomputed from the job files on every run.
     No persisted counter that a later run increments (which a merge that
     resolves a frontmatter conflict the other way could silently rewind — the
     same hazard the garden hit from `reputation/` breadcrumbs).
"""

import argparse
import collections
import os
import re
import subprocess
import sys

# ---------------------------------------------------------------------------
# The queue and the edge corpus.
#
# unum measures TODO/ + DOIN/ + TOQU/. The garden's analogue of the ACTIVE
# queue is jobs/todo/ + jobs/doin/. jobs/plan/ is the garden's parked pool —
# heterogeneous (see GATE handling below) — and is the TOTAL backlog's extra
# term. The two are DIFFERENT QUESTIONS ("what is the fleet working now" vs
# "what does the fleet still owe"), so both slices are answerable and the
# default prints both; conflating them hides the thing the maintainer most
# wants to see.
#
# The EDGE corpus additionally reads jobs/tada/ (completed) and jobs/orch/
# (orchestration records), because a job's spawned children may already have
# completed — the realized floor (below) must still see them.
# ---------------------------------------------------------------------------
ACTIVE_DIRS = ["jobs/todo", "jobs/doin"]
PLAN_DIRS = ["jobs/plan"]
QUEUE_DIRS = ACTIVE_DIRS + PLAN_DIRS
EDGE_EXTRA_DIRS = ["jobs/tada"]           # completed-but-still-a-parent
ORCH_DIR = "jobs/orch"                     # orchestration spawn records

# ---------------------------------------------------------------------------
# The garden's rank rules — a better signal than unum's prose regexes.
#
# unum regexes prose for groom|uplift slugs and a first-person "filed as a
# trampoline seed" self-declaration, and its own comment records the false
# positive an over-broad `\btrampoline\b.*\b(seed|capstone)\b` under re.S
# caused. The garden does not need any of it: jobs carry `role:`, assigned by
# the PRODUCER and already load-bearing for model tier and which AGENT.md
# loads. Deriving rank from role is still derivation, and it is a cleaner,
# audited signal than scraping prose.
#
# Rules apply IN ORDER, first match wins. The realized floor is rule 1 because
# a job that has ALREADY spawned children is at least the rank its children
# imply — that is a FACT about the board, not an estimate from the job's shape.
# ---------------------------------------------------------------------------

# R2: output is tasks whose own output is tasks (an orchestration).
R2_ROLES = {"orchestrator"}
# A groom/uplift/orchestration-shaped basename, as a backstop for a producer
# that shaped an orchestration without stamping role: orchestrator. Anchored to
# whole hyphen-delimited words so `orchestrate-docs` matches but `search` does
# not. (Audited: fires on NOTHING in the live board today; role: orchestrator
# alone carries the sole R2. Kept because the next orchestration may arrive
# slug-shaped before role-stamped.)
R2_SLUG = re.compile(r"(?:^|-)(orch|orchestrat(?:e|ion|or)|groom|uplift)(?:-|$)", re.I)

# R1: output is a decision / plan / report, not the work itself.
R1_ROLES = {
    "designer", "assayer", "researcher", "scholar", "librarian",
    "prosecutor", "triager", "watchman",
}
# Title begins DESIGN/PROPOSE/SPEC, after an optional "component: " prefix
# ("web: DESIGN — ..."). Case-SENSITIVE, mirroring the reference: a lowercase
# "design" in prose is not a title verb. A backstop for a no-role job.
R1_TITLE_VERB = re.compile(r"^(?:[\w -]+:\s*)?(DESIGN|PROPOSE|SPEC)\b")

FM_KEY = re.compile(r"^([A-Za-z0-9_-]+):\s*(.*?)\s*$")
HEADING = re.compile(r"^#\s+(.*?)\s*$")


def run_git(root, *args):
    return subprocess.run(
        ["git", "-C", root, *args], capture_output=True, text=True, check=True
    ).stdout


def _iter_board_files(root, rev, dirs):
    """Yield (relpath, text) for every *.md under `dirs`, from a rev or dir."""
    if rev:
        try:
            names = run_git(root, "ls-tree", "-r", "--name-only", rev, "--", *dirs)
        except subprocess.CalledProcessError:
            return
        for rel in names.splitlines():
            if rel.endswith(".md"):
                yield rel, run_git(root, "show", f"{rev}:{rel}")
    else:
        for d in dirs:
            base = os.path.join(root, d)
            if not os.path.isdir(base):
                continue
            for fn in sorted(os.listdir(base)):
                if fn.endswith(".md"):
                    p = os.path.join(base, fn)
                    if os.path.isfile(p):
                        with open(p, encoding="utf-8", errors="replace") as fh:
                            yield os.path.join(d, fn), fh.read()


def _scan_frontmatter(text):
    """Line-scan the preamble for the keys we need.

    Garden jobs routinely carry TWO `---`-delimited blocks (a producer outer
    block, a role/model inner block) plus HTML-comment provenance markers, and
    the reference itself documents that strict-YAML frontmatter is not a safe
    assumption. So we do NOT parse YAML: we scan lines from the top until the
    first `#` heading (the body), taking the FIRST occurrence of each key. The
    producer's `role:` always precedes any prose mention of the word.
    """
    fm = {}
    title = None
    for line in text.splitlines():
        h = HEADING.match(line)
        if h:
            title = h.group(1)
            break
        m = FM_KEY.match(line)
        if m:
            k, v = m.group(1), m.group(2)
            if k not in fm:
                fm[k] = v
    return fm, title


def parse(rel, text):
    fm, title = _scan_frontmatter(text)
    base = os.path.basename(rel)[:-3]  # strip .md; the base IS the identity
    board = rel.split(os.sep)[1] if os.sep in rel else ""  # jobs/<board>/...
    return {
        "base": base,
        "board": board,
        "role": (fm.get("role") or "").strip().lower(),
        "gate": (fm.get("gate") or "").strip().lower(),
        "orchestrated_by": (fm.get("orchestrated_by") or "").strip(),
        "poisoned": (fm.get("poisoned") or "").strip().lower() == "true",
        "title": title or "",
        "body": text,
    }


def _split_ids(v):
    """A space/comma-separated basename list field -> [base, ...]."""
    return [x for x in re.split(r"[\s,]+", v.strip()) if x]


def build(root, rev):
    """-> (queue_rows, children) over the audited edge set.

    queue_rows: parsed jobs in todo+doin+plan (the backlog we rank).
    children:   parent_base -> {child_base, ...}, the spawn forest, drawn from
                orchestration records (`children:`) and from `orchestrated_by:`
                provenance on any job in the edge corpus.
    """
    queue, edge_jobs = [], {}
    for rel, text in _iter_board_files(root, rev, QUEUE_DIRS + EDGE_EXTRA_DIRS):
        t = parse(rel, text)
        edge_jobs[t["base"]] = t
        if t["board"] in ("todo", "doin", "plan"):
            queue.append(t)

    children = collections.defaultdict(set)

    # Edge source 1: orchestration records name their children directly.
    for rel, text in _iter_board_files(root, rev, [ORCH_DIR]):
        fm, _ = _scan_frontmatter(text)
        parent = os.path.basename(rel)[:-3]
        for c in _split_ids(fm.get("children", "")):
            if c != parent:
                children[parent].add(c)

    # Edge source 2: a child pointing back at its orchestrator.
    for t in edge_jobs.values():
        p = t["orchestrated_by"]
        if p and p != t["base"]:
            children[p].add(t["base"])

    return queue, children


def realized_rank(children):
    """rank(t) = 0 if childless else 1 + max(child ranks). Cycle-safe."""
    rank, state = {}, {}

    def go(n):
        if n in rank:
            return rank[n]
        if state.get(n) == "open":
            return 0  # back-edge in a cycle: treat as a leaf
        state[n] = "open"
        kids = children.get(n, ())
        r = 0 if not kids else 1 + max(go(k) for k in kids)
        state[n] = "done"
        rank[n] = r
        return r

    for n in list(children):
        go(n)
    return rank


def classify(t, realized):
    """The garden rank rules, in order, first match wins. -> (rank, why)."""
    # 1. Realized floor — it has already spawned; that is a fact, not a guess.
    r = realized.get(t["base"], 0)
    if r > 0:
        n = "" if r == 1 else f" ({r} deep)"
        return min(r, 2), f"realized floor: has spawned children{n}"

    # 2. R2 — output is tasks whose output is tasks.
    if t["role"] in R2_ROLES:
        return 2, f"R2: role {t['role']}"
    if R2_SLUG.search(t["base"]):
        return 2, "R2: orchestration-shaped slug"

    # 3. R1 — output is a decision/plan/report, not the work.
    if t["role"] in R1_ROLES:
        return 1, f"R1: role {t['role']}"
    if R1_TITLE_VERB.match(t["title"]):
        return 1, "R1: DESIGN/PROPOSE/SPEC title"
    if t["title"].rstrip().endswith("?"):
        return 1, "R1: title is a question"

    # 4. R0 — changes code or external state.
    return 0, f"R0: {t['role'] or 'no role'}"


def _in_slice(t, sl):
    if sl == "active":
        return t["board"] in ("todo", "doin")
    if sl == "plan":
        return t["board"] == "plan"
    return t["board"] in ("todo", "doin", "plan")  # total


def triple(root, rev, sl="total"):
    """-> ((r2,r1,r0), rows) for the requested slice. rows: (rank, why, t)."""
    queue, children = build(root, rev)
    realized = realized_rank(children)
    rows = []
    for t in sorted(queue, key=lambda x: x["base"]):
        if not _in_slice(t, sl):
            continue
        r, why = classify(t, realized)
        rows.append((r, why, t))
    c = collections.Counter(r for r, _, _ in rows)
    return (c[2], c[1], c[0]), rows


def o_lt(a, b):
    """ACL2 `o<` on the triple: leading component first. NOT a count delta.

    Python tuple comparison IS lexicographic, leading element first, which is
    exactly ordinal `<` on omega^2*r2 + omega*r1 + r0.
    """
    return a < b


def cnf(t):
    parts = []
    if t[0]:
        parts.append("w^2" if t[0] == 1 else f"w^2*{t[0]}")
    if t[1]:
        parts.append("w" if t[1] == 1 else f"w*{t[1]}")
    if t[2] or not parts:
        parts.append(str(t[2]))
    return " + ".join(parts)


# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------

def _gate_breakdown(rows):
    c = collections.Counter(t["gate"] or "<none>" for _, _, t in rows)
    return ", ".join(f"{g}:{n}" for g, n in c.most_common())


def report_slice(root, rev, sl, show_members=True):
    t, rows = triple(root, rev, sl)
    label = rev or "working tree"
    poisoned = sum(1 for _, _, x in rows if x["poisoned"])
    print(f"## {sl} backlog — {label}")
    print(f"   (r2, r1, r0) = {t}   CNF = {cnf(t)}   n={sum(t)} jobs")
    if sl in ("total", "plan"):
        print(f"   plan gates: {_gate_breakdown([r for r in rows if r[2]['board']=='plan'])}")
    if poisoned:
        print(f"   NOTE: {poisoned} of these are poisoned (parked failures), "
              f"not healthy backlog — see the caveat in the tada report.")
    if show_members:
        for want in (2, 1, 0):
            members = [(w, x) for r, w, x in rows if r == want]
            print(f"   rank {want} — {len(members)}:")
            for why, x in members:
                gate = f"[{x['gate']}]" if x["gate"] else ""
                print(f"     ({x['board']:<4}) {x['base'][:52]:<52} {why}  {gate}")
    print("   Membership is printed because a bare ordinal is not auditable.")
    print()
    return t


def report(root, rev, slices, show_members, as_json):
    if as_json:
        import json
        out = {}
        for sl in slices:
            t, rows = triple(root, rev, sl)
            out[sl] = {
                "triple": list(t), "cnf": cnf(t), "n": sum(t),
                "poisoned": sum(1 for _, _, x in rows if x["poisoned"]),
                "members": [
                    {"base": x["base"], "board": x["board"], "gate": x["gate"],
                     "rank": r, "why": w}
                    for r, w, x in rows
                ],
            }
        print(json.dumps(out, indent=2))
        return
    print(f"# CNF backlog triple — {rev or 'working tree'}")
    print("# (r2,r1,r0) = omega^2*r2 + omega*r1 + r0; compared by o<, never by count.")
    print()
    for sl in slices:
        report_slice(root, rev, sl, show_members)


def compare(root, old, new):
    print(f"# progress {old} -> {new}, per slice (o<, NOT count delta)")
    print()
    for sl in ("active", "total"):
        a = report_slice(root, old, sl, show_members=False)
        b = report_slice(root, new, sl, show_members=False)
        verdict = "<" if o_lt(b, a) else (">" if o_lt(a, b) else "=")
        print(f"   => {sl}: {cnf(b)}  o{verdict}  {cnf(a)}")
        da, db = sum(a), sum(b)
        print(f"      count {da} -> {db} ({db - da:+d}) — report the o{verdict} "
              f"verdict, NOT this delta.")
        if verdict == "<" and db >= da:
            print("      NOTE: count and o< DISAGREE. That is the metric earning "
                  "its keep: an undecided decomposition was cashed into finite work.")
        print()


# ---------------------------------------------------------------------------
# Regression fixtures — the disagreement is the one that MUST hold.
#
# Fixtures are committed board roots under test/fixtures/cnf/{A,B}/. B is A
# after finishing ONE rank-1 planning job (a designer job) and REPLACING it
# with three rank-0 children (builder jobs). Count rises +2 while the triple
# falls strictly under o<. If these two ever stop disagreeing, the metric has
# stopped earning its keep — it would just be a slower count.
# ---------------------------------------------------------------------------
def _fixtures_dir():
    return os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "test", "fixtures", "cnf")


def check(fixtures=None):
    fx = fixtures or _fixtures_dir()
    a_root, b_root = os.path.join(fx, "A"), os.path.join(fx, "B")
    ok = True

    def expect(name, got, want):
        nonlocal ok
        good = got == want
        ok = ok and good
        print(f"{'ok  ' if good else 'FAIL'} {name}: got {got} want {want}")

    ta, _ = triple(a_root, None, "total")
    tb, _ = triple(b_root, None, "total")
    expect("fixture A total triple", ta, (1, 1, 2))
    expect("fixture B total triple", tb, (1, 0, 5))

    # The headline: o< falls strictly while count RISES.
    ca, cb = sum(ta), sum(tb)
    disagree = o_lt(tb, ta) and cb > ca
    print(f"{'ok  ' if disagree else 'FAIL'} DISAGREEMENT  {ta} -> {tb}: "
          f"count {ca}->{cb} (+{cb - ca}, reads WORSE) but o< "
          f"{'strictly DOWN, reads BETTER' if o_lt(tb, ta) else 'NOT down'}")
    ok = ok and disagree

    # A realized floor: A's designer job that (in a third fixture C) has spawned
    # a child is lifted to at least its child's rank.
    c_root = os.path.join(fx, "C")
    if os.path.isdir(c_root):
        _, rows = triple(c_root, None, "total")
        floored = [x["base"] for r, w, x in rows if "realized floor" in w]
        good = floored == ["c-parent-planning"]
        ok = ok and good
        print(f"{'ok  ' if good else 'FAIL'} realized floor lifts a spawned "
              f"parent: {floored} want ['c-parent-planning']")

    print("PASS" if ok else "FAIL")
    return ok


def _default_root():
    # Prefer a journal-shaped cwd, else $GARDEN_ROOT/journal.
    for cand in (os.getcwd(),
                 os.path.join(os.environ.get("GARDEN_ROOT", ""), "journal")):
        if cand and os.path.isdir(os.path.join(cand, "jobs", "plan")):
            return cand
    return os.getcwd()


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--root", default=None,
                    help="journal root (default: cwd or $GARDEN_ROOT/journal)")
    ap.add_argument("--rev", default=None, help="a journal2 git revision")
    ap.add_argument("--slice", choices=["active", "total", "plan", "both"],
                    default="both", help="which backlog to report (default both)")
    ap.add_argument("--compare", nargs=2, metavar=("OLD", "NEW"),
                    help="o< between two journal2 revisions")
    ap.add_argument("--no-members", action="store_true",
                    help="print only the triples, not the membership")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--check", action="store_true", help="run regression fixtures")
    ap.add_argument("--fixtures", default=None, help="fixture root (for --check)")
    args = ap.parse_args()

    if args.check:
        sys.exit(0 if check(args.fixtures) else 1)

    root = args.root or _default_root()

    if args.compare:
        compare(root, args.compare[0], args.compare[1])
        return

    slices = ["active", "total"] if args.slice == "both" else [args.slice]
    report(root, args.rev, slices, not args.no_members, args.json)


if __name__ == "__main__":
    main()
