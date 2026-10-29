# INC-2291 — Month-end close short by $2.1M

Postmortem notes (raw), compiled by Priya Raman (Data Platform)

## Timeline (all times UTC)
- 2026-03-28: Vendor Ledgerline ships v4 of their export API. Release notes mention "ISO 8601 dates now default." Nobody on our side reads it.
- 2026-03-29 02:00: Nightly `ledger-ingest` batch runs. Parser expects `MM/DD/YYYY`. Rows with ISO dates fail to parse and are **skipped** (the parser logs at DEBUG level and continues). 18,412 of 61,030 rows skipped.
- 2026-03-29 to 2026-03-31: Batch runs nightly, same behavior. Job status: green every night.
- 2026-04-01 09:40: Finance closes March. Revenue reported $2.1M below forecast. Attributed to "seasonality" in the close meeting.
- 2026-04-02 15:12: Analyst Marco Diaz notices Hartwell Logistics (a top-10 customer) has zero March invoices. Posts in #finance-data: "Either Hartwell churned and nobody told us, or something is very broken."
- 2026-04-02 15:30: Priya pulls the ingest logs, finds 18k DEBUG "unparseable date, skipping" lines per night.
- 2026-04-02 18:05: Fix deployed (parse both formats). Backfill run for Mar 29–Apr 2.
- 2026-04-03 11:00: Finance reopens March close. Corrected revenue within 0.3% of forecast.

## Impact
- March close reopened; one-day delay to board reporting.
- No customer-facing impact.

## Contributing factors
- Parser skipped bad rows silently instead of failing.
- Job health measured only by "did the process exit 0".
- No row-count anomaly check (61k rows → 43k rows went unnoticed).
- Vendor changelog not monitored.

## Action items
- [done] Parser now fails the job if >0.5% of rows are unparseable.
- [done] Row-count anomaly alert (>10% drop vs 7-day median).
- [open] Subscribe Data Platform to vendor changelogs.

## Quotes from retro meeting (from the meeting recording transcript)
- Priya: "The job was green for four nights. Green meant 'the process didn't crash.' It never meant 'the data is right.'"
- Marco: "I almost didn't post. I figured someone else had already checked."
