#!/usr/bin/env python3
"""Operator transitions for the minion.town screening delegation.

The shell wrapper (minion-town-screening.sh) owns journal sync and the CAS push.
seed never overwrites an existing record and never undoes a revocation.
"""
import sys
from pathlib import Path

from policy import (AUTHOR, AUTHORIZATION, AUTHORIZATION_TEXT, BASE, CONFIGURATION,
                    ESCALATE_EXCEPT, ESCALATE_PATHS, ESCALATE_SECTIONS, REPOSITORY,
                    TOMBSTONE, digest, iso, now, read_json, record, require, status,
                    write_json)


def seed(journal):
    require(not (journal / TOMBSTONE).exists(), 'delegation revoked')
    if (journal / CONFIGURATION).exists():
        record(journal)
        return 'already seeded'
    entry = journal / AUTHORIZATION
    if not entry.exists():
        entry.parent.mkdir(parents=True, exist_ok=True)
        entry.write_text(AUTHORIZATION_TEXT)
    write_json(journal / CONFIGURATION, dict(
        schema=2, status='active', authorized_by='kriskowal', authorization=AUTHORIZATION,
        authorization_sha256=digest(entry.read_bytes()), repository=REPOSITORY, base=BASE,
        author=AUTHOR, escalate_paths=ESCALATE_PATHS, escalate_except=ESCALATE_EXCEPT,
        escalate_sections=ESCALATE_SECTIONS, healing=[], seeded_at=iso(now())))
    return 'seeded'


def transition(journal, action, reason):
    value = record(journal)
    if action == 'pause':
        value.update(status='paused', paused_by='maintainer', paused_at=iso(now()),
                     paused_reason=reason or 'maintainer pause')
    elif action == 'resume':
        value['status'] = 'active'
        for key in ('paused_by', 'paused_at', 'paused_reason'):
            value.pop(key, None)
        value['resumed_at'] = iso(now())
    write_json(journal / CONFIGURATION, value)
    return value['status']


def revoke(journal, reason):
    require(reason.strip(), 'revoke needs a non-empty reason')
    tombstone = journal / TOMBSTONE
    tombstone.parent.mkdir(parents=True, exist_ok=True)
    tombstone.write_text(f'revoked_at: {iso(now())}\n---\n{reason.rstrip()}\n')
    if (journal / CONFIGURATION).exists():
        value = read_json(journal / CONFIGURATION)
        value['status'] = 'revoked'
        write_json(journal / CONFIGURATION, value)
    return 'revoked'


def main():
    action, journal, *arguments = sys.argv[1:]
    journal = Path(journal)
    reason = Path(arguments[0]).read_text() if arguments else ''
    if action == 'seed':
        print(seed(journal))
    elif action in ('pause', 'resume'):
        print(transition(journal, action, reason.strip()))
    elif action == 'revoke':
        print(revoke(journal, reason))
    elif action == 'status':
        print(status(journal))
        if (journal / CONFIGURATION).exists():
            print((journal / CONFIGURATION).read_text().rstrip())
    else:
        raise ValueError('usage: seed|pause [reason-file]|resume|revoke <reason-file>|status')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(f'minion-town-screening: {error}', file=sys.stderr)
        sys.exit(1)
