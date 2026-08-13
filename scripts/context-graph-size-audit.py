#!/usr/bin/env python3
"""Report the size and shape of the garden's reachable Markdown context graph."""

from __future__ import annotations

import argparse
import fnmatch
import os
import re
import statistics
import subprocess
import sys
from collections import defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import unquote, urlsplit


LINK_RE = re.compile(r"(?<!!)\[[^\]]*\]\(\s*(<[^>]+>|[^\s)]+)")
H2_RE = re.compile(r"^##(?!#)\s+", re.MULTILINE)
GENERATED_JOURNAL_INDEX = Path("library/sections/README.md")


@dataclass(frozen=True)
class Document:
    path: Path
    lines: int
    size: int
    sections: int


def tracked_markdown(root: Path) -> set[Path]:
    """Return tracked Markdown paths, falling back to an on-disk walk."""
    result = subprocess.run(
        ["git", "-C", str(root), "ls-files", "-z", "--", "*.md"],
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    if result.returncode == 0:
        return {
            Path(os.fsdecode(item))
            for item in result.stdout.split(b"\0")
            if item
        }
    return {
        path.relative_to(root)
        for path in root.rglob("*.md")
        if ".git" not in path.parts
    }


def main_roots(root: Path, files: set[Path], exclude_globs: tuple[str, ...] = ()) -> list[Path]:
    patterns = (
        "CLAUDE.md",
        "README.md",
        "WORKTREES.md",
        "roles/*/AGENT.md",
        "roles/jurors/*/AGENT.md",
        "roles/COMMON.md",
        "skills/*/SKILL.md",
        "designs/*.md",
        "context/*.md",
        "context/**/*.md",
    )
    roots = {
        path
        for path in files
        if any(fnmatch.fnmatch(path.as_posix(), pattern) for pattern in patterns)
        and not any(fnmatch.fnmatch(path.as_posix(), pattern) for pattern in exclude_globs)
    }
    agents = Path("AGENTS.md")
    claude = Path("CLAUDE.md")
    if agents in files:
        # A distinct file is a root. A hard link or symlink to CLAUDE.md is not.
        try:
            differs = not os.path.samefile(root / agents, root / claude)
        except (FileNotFoundError, OSError):
            differs = agents != claude
        if differs:
            roots.add(agents)
    return sorted(roots)


def resolve_link(root: Path, source: Path, raw_target: str) -> Path | None:
    target = raw_target.strip("<>")
    parsed = urlsplit(target)
    if parsed.scheme or parsed.netloc or not parsed.path or parsed.path.startswith("/"):
        return None
    decoded = unquote(parsed.path)
    candidate = Path(os.path.normpath(source.parent / decoded))
    if candidate.parts and candidate.parts[0] == "..":
        return None
    absolute = root / candidate
    if absolute.is_dir():
        candidate /= "README.md"
        absolute = root / candidate
    if absolute.is_file() and candidate.suffix.lower() == ".md":
        return candidate
    return None


def links_from(root: Path, source: Path) -> set[Path]:
    text = (root / source).read_text(encoding="utf-8", errors="replace")
    return {
        resolved
        for match in LINK_RE.finditer(text)
        if (resolved := resolve_link(root, source, match.group(1))) is not None
    }


def walk(
    root: Path,
    seeds: list[Path],
    exclude_globs: tuple[str, ...] = (),
) -> tuple[set[Path], dict[Path, set[Path]]]:
    def excluded(path: Path) -> bool:
        return any(fnmatch.fnmatch(path.as_posix(), pattern) for pattern in exclude_globs)

    reachable: set[Path] = set()
    edges: dict[Path, set[Path]] = {}
    pending = deque(path for path in seeds if (root / path).is_file() and not excluded(path))
    while pending:
        path = pending.popleft()
        if path in reachable:
            continue
        reachable.add(path)
        edges[path] = {target for target in links_from(root, path) if not excluded(target)}
        pending.extend(edges[path] - reachable)
    return reachable, edges


def inspect(root: Path, paths: set[Path]) -> dict[Path, Document]:
    docs = {}
    for path in paths:
        data = (root / path).read_bytes()
        text = data.decode("utf-8", errors="replace")
        docs[path] = Document(path, len(text.splitlines()), len(data), len(H2_RE.findall(text)))
    return docs


def size_class(doc: Document) -> str:
    if doc.lines >= 600 or doc.size >= 48 * 1024:
        return "very large"
    if doc.lines >= 300 or doc.size >= 24 * 1024:
        return "large"
    if doc.lines >= 100 or doc.size >= 8 * 1024:
        return "medium"
    return "small"


def candidate_reasons(docs: dict[Path, Document], generated_exempt: set[Path]) -> dict[Path, list[str]]:
    siblings: dict[Path, list[int]] = defaultdict(list)
    for doc in docs.values():
        siblings[doc.path.parent].append(doc.lines)

    flagged = {}
    for path, doc in docs.items():
        if path in generated_exempt:
            continue
        reasons = []
        if doc.lines >= 300:
            reasons.append("at least 300 lines")
        if doc.size >= 24 * 1024:
            reasons.append("at least 24 KiB")
        peer_lines = siblings[path.parent]
        if len(peer_lines) >= 3:
            median = statistics.median(peer_lines)
            if doc.lines >= 150 and median > 0 and doc.lines >= 2 * median:
                reasons.append(f"{doc.lines / median:.1f}x the sibling median ({median:g} lines)")
        if doc.lines >= 160 and doc.sections >= 8:
            reasons.append(f"{doc.sections} level-two sections suggest mixed topics")
        if reasons:
            flagged[path] = reasons
    return flagged


def tree_name(path: Path, branch: str) -> str:
    if branch == "main2":
        return "main2 context library"
    return "journal2 root" if len(path.parts) == 1 else f"journal2 {path.parts[0]}/"


def format_size(size: int) -> str:
    return f"{size / 1024:.1f} KiB"


def revision(root: Path) -> str:
    result = subprocess.run(
        ["git", "-C", str(root), "rev-parse", "--short=12", "HEAD"],
        check=False,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip() if result.returncode == 0 else "unknown"


def render_tree(
    name: str,
    docs: dict[Path, Document],
    flagged: dict[Path, list[str]],
    top_n: int,
    generated_exempt: set[Path],
) -> list[str]:
    lines = [f"## {name}", ""]
    lines.append(f"Reachable documents: {len(docs)}. Reorganization candidates: {len(flagged)}.")
    lines.extend(["", f"### Largest {min(top_n, len(docs))} documents", ""])
    lines.extend(["| Path | Lines | Bytes | Class | Level-two sections |", "| --- | ---: | ---: | --- | ---: |"]) 
    for doc in sorted(docs.values(), key=lambda item: (-item.lines, -item.size, item.path.as_posix()))[:top_n]:
        note = " (generated index, exempt)" if doc.path in generated_exempt else ""
        lines.append(
            f"| `{doc.path.as_posix()}`{note} | {doc.lines} | {doc.size} | {size_class(doc)} | {doc.sections} |"
        )
    lines.extend(["", "### Reorganization candidates", ""])
    if not flagged:
        lines.append("None.")
    else:
        for path, reasons in sorted(flagged.items(), key=lambda item: (-docs[item[0]].lines, item[0].as_posix())):
            doc = docs[path]
            lines.append(
                f"- `{path.as_posix()}` ({doc.lines} lines, {format_size(doc.size)}): "
                + "; ".join(reasons)
                + "."
            )
    lines.append("")
    return lines


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--main-root", type=Path, default=Path.cwd(), help="main2 checkout root")
    parser.add_argument("--journal-root", type=Path, required=True, help="journal2 checkout root")
    parser.add_argument("--date", required=True, help="report date in YYYY-MM-DD form")
    parser.add_argument("--top", type=int, default=15, help="largest documents listed per tree")
    parser.add_argument(
        "--exclude-root-glob",
        action="append",
        default=[],
        metavar="PATTERN",
        help="drop main2 roots matching this glob before the walk (repeatable)",
    )
    parser.add_argument(
        "--exclude-journal-seed",
        action="append",
        default=[],
        metavar="PATH",
        help="drop a journal2 seed path so the walk does not start from it (repeatable)",
    )
    return parser.parse_args()


def run() -> int:
    args = parse_args()
    main_root = args.main_root.resolve()
    journal_root = args.journal_root.resolve()
    if args.top < 1:
        raise SystemExit("--top must be positive")
    for root, label in ((main_root, "main"), (journal_root, "journal")):
        if not root.is_dir():
            raise SystemExit(f"{label} root is not a directory: {root}")

    exclude_root_globs = tuple(args.exclude_root_glob)
    exclude_journal_seeds = {Path(item) for item in args.exclude_journal_seed}

    main_files = tracked_markdown(main_root)
    main_reachable, _ = walk(
        main_root, main_roots(main_root, main_files, exclude_root_globs), exclude_root_globs
    )
    main_docs = inspect(main_root, main_reachable)

    journal_files = tracked_markdown(journal_root)
    journal_seeds = [
        path
        for path in (Path("README.md"), Path("projects/README.md"), Path("library/README.md"))
        if path in journal_files and path not in exclude_journal_seeds
    ]
    journal_reachable, _ = walk(journal_root, journal_seeds)
    journal_docs = inspect(journal_root, journal_reachable)

    generated_exempt = {GENERATED_JOURNAL_INDEX} & journal_reachable
    main_flagged = candidate_reasons(main_docs, set())
    journal_flagged = candidate_reasons(journal_docs, generated_exempt)

    grouped: dict[str, dict[Path, Document]] = defaultdict(dict)
    for path, doc in journal_docs.items():
        grouped[tree_name(path, "journal2")][path] = doc

    main_root_prose = (
        "The main2 roots are the top-level orientation documents plus every role, juror, skill, design, and `context/` Markdown document."
    )
    if exclude_root_globs:
        main_root_prose += (
            " Excluded main2 globs (dropped as roots and pruned from the walk, so they are neither seeded nor reached through links): "
            + ", ".join(f"`{glob}`" for glob in exclude_root_globs)
            + "."
        )
    journal_seed_prose = "The journal2 roots are " + ", ".join(f"`{seed.as_posix()}`" for seed in journal_seeds) + "; links from those roots may reach additional journal trees."
    if exclude_journal_seeds:
        journal_seed_prose += " Excluded journal2 seeds: " + ", ".join(f"`{seed.as_posix()}`" for seed in sorted(exclude_journal_seeds)) + "."

    lines = [
        f"# Context graph size audit ({args.date})",
        "",
        "This report walks relative inline Markdown links from the documented context roots. "
        + main_root_prose
        + " "
        + journal_seed_prose,
        "",
        "Classification thresholds: small is below 100 lines and 8 KiB; medium starts at 100 lines or 8 KiB; large starts at 300 lines or 24 KiB; very large starts at 600 lines or 48 KiB. "
        "A hand-authored document is flagged when it reaches 300 lines or 24 KiB, has at least 160 lines and eight level-two sections, or has at least 150 lines and twice the median line count of three or more same-directory peers. "
        "The generated `library/sections/README.md` index is classified but exempt from reorganization flags.",
        "",
        f"Revisions: main2 `{revision(main_root)}`; journal2 `{revision(journal_root)}`.",
        "",
    ]
    lines.extend(render_tree("main2 context library", main_docs, main_flagged, args.top, set()))
    for name in sorted(grouped):
        tree_docs = grouped[name]
        tree_flags = {path: reasons for path, reasons in journal_flagged.items() if path in tree_docs}
        lines.extend(render_tree(name, tree_docs, tree_flags, args.top, generated_exempt))

    main_orphans = sorted(
        path
        for path in main_files - main_reachable
        if not any(fnmatch.fnmatch(path.as_posix(), pattern) for pattern in exclude_root_globs)
    )
    journal_orphan_trees = {seed.parts[0] for seed in journal_seeds if len(seed.parts) > 1}
    journal_context_files = {
        path for path in journal_files if path.parts and path.parts[0] in journal_orphan_trees
    }
    journal_orphans = sorted(journal_context_files - journal_reachable)
    journal_tree_prose = (
        " and ".join(f"`{tree}/`" for tree in sorted(journal_orphan_trees))
        if journal_orphan_trees
        else "no seeded trees"
    )
    lines.extend(["## Orphan signal", ""])
    lines.append(
        f"Unreachable tracked Markdown documents: {len(main_orphans)} on main2 and "
        f"{len(journal_orphans)} under journal2 {journal_tree_prose}."
    )
    for label, paths in (("main2", main_orphans), ("journal2 context", journal_orphans)):
        if paths:
            shown = paths[:50]
            lines.extend(["", f"### {label} orphans (showing {len(shown)} of {len(paths)})", ""])
            lines.extend(f"- `{path.as_posix()}`" for path in shown)

    total_docs = len(main_docs) + len(journal_docs)
    total_flagged = len(main_flagged) + len(journal_flagged)
    lines.extend(
        [
            "",
            "## Summary",
            "",
            f"Walked {total_docs} reachable documents and flagged {total_flagged} reorganization candidates.",
            "",
            "Consider running this report periodically through the garden scheduling mechanism if trend data would be useful.",
        ]
    )
    sys.stdout.write("\n".join(lines) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(run())
