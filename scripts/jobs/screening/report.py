#!/usr/bin/env python3
"""Bulletin views of the minion.town screening delegation (deterministic, no LLM).

  report.py parked-filter <journal>   filter parked-PR TSV rows on stdin
  report.py section <journal>         the "Screened by proxy" section body
"""
import sys
from pathlib import Path

from policy import (CONFIGURATION, REPOSITORY, SCREENINGS, TOMBSTONE, now, parse_time,
                    read_json, status)

URL = f'https://github.com/{REPOSITORY}'
WINDOW = 24 * 3600


def seeded(journal):
    return (journal / CONFIGURATION).is_file() and not (journal / TOMBSTONE).exists()


def parked_filter(journal, rows):
    """Drop delegated-repository rows while the no-escalation screen is seeded."""
    for row in rows:
        if not row.strip():
            continue
        cells = row.rstrip('\n').split('\t')
        if seeded(journal) and cells[0] == REPOSITORY and len(cells) > 1 and cells[1].isdigit():
            continue
        sys.stdout.write(row if row.endswith('\n') else row + '\n')


def recent(stamp):
    try:
        return (now() - parse_time(stamp)).total_seconds() <= WINDOW
    except (ValueError, TypeError, AttributeError):
        return False


def section(journal):
    if not (journal / CONFIGURATION).is_file() and not (journal / TOMBSTONE).exists():
        print('(delegation not armed)')
        return
    verdict = status(journal)
    line = f'Delegation: **{verdict}**'
    if verdict == 'paused':
        value = read_json(journal / CONFIGURATION)
        line += f" by {value.get('paused_by', '?')} since {value.get('paused_at', '?')}: {value.get('paused_reason', '')}"
    print(line)
    events = []
    for path in sorted((journal / SCREENINGS).glob('*/*.json')):
        try:
            item = read_json(path)
        except (OSError, ValueError):
            continue
        link = f"[#{item.get('pull_request')}]({URL}/pull/{item.get('pull_request')})"
        head = str(item.get('head', ''))[:11]
        if path.name.startswith('blocked-'):
            if recent(item.get('at')):
                events.append((item['at'], f"- {item['at']} {link} `{head}` **blocked**: {item.get('reason', 'screen unreadable')}"))
            continue
        if path.name.startswith('escalated-'):
            if recent(item.get('at')):
                events.append((item['at'], f"- {item['at']} {link} `{head}` **escalated**: {', '.join(item.get('paths', []))}"))
            continue
        if recent(item.get('screened_at')):
            events.append((item['screened_at'], f"- {item['screened_at']} {link} `{head}` screened"
                           + (f" (heal of `{item['heal'][:11]}`)" if item.get('heal') else '')))
        if item.get('merge_commit') and recent(item.get('merged_at')):
            deploy = item.get('deploy', 'pending')
            if item.get('deploy_url'):
                deploy = f"[{deploy}]({item['deploy_url']})"
            health = f", watchdog {item['health']}" if item.get('health') else ''
            events.append((item['merged_at'], f"- {item['merged_at']} {link} merged "
                           f"`{item['merge_commit'][:11]}`; deploy {deploy}{health}"
                           f"{' — ' + item['outcome'] if item.get('outcome') else ''}"))
    if not events:
        print('\n(no screening activity in the last 24 h)')
        return
    print()
    for _, text in sorted(events, reverse=True):
        print(text)


def main():
    command, journal = sys.argv[1:3]
    journal = Path(journal)
    if command == 'parked-filter':
        parked_filter(journal, sys.stdin.readlines())
    elif command == 'section':
        section(journal)
    else:
        raise SystemExit('usage: report.py parked-filter|section <journal>')


if __name__ == '__main__':
    main()
