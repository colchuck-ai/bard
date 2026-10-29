# Gathering: interviews, files, research

How to collect a story's raw material. Load this before the first interview round or before mining files.

## Interview principles

- **Ask for scenes, not opinions.** "Walk me through the moment you realized…" yields a story; "What did you learn?" yields a platitude. Get the moment first; meaning comes later.
- **Ask what they expected.** "What did you think would happen?" exposes the gap between expectation and reality, which is where tension lives.
- **Follow the energy.** When an answer gets specific, emotional, or funny, the next question goes there, not to the next item on your list.
- **Probe for specifics.** When you hear "it was slow", ask "how slow? what did it look like?" When you hear "people were upset", ask "who, and what did they say?" Get numbers, names (and how to spell them), times, places, and artifacts such as the error message, the whiteboard, or the Slack thread.
- **Don't lead.** Ask "how did that feel?" rather than "that must have been stressful?" A leading question gets your story back, not theirs.
- **Ask for the low point.** "What was the worst moment?" Stories without one are flat, and people rarely volunteer it.
- **Check quotes.** When an answer would make a good quote, ask if those were the actual words or a paraphrase (this matters under Documentary fidelity).

## Round sequence

Each round is 3–5 questions. Pick from the bank below and skip what you already know. After round 1, open each round with a 2–3 line recap.

**Round 1: Frame** (skip questions the request already answered; if the request names a real event, replace one you can infer with "What nearly went wrong?")
- Who's the audience, and what do they already know about this?
- Where will this be told or published, and how long should it be?
- What should they know, feel, or do differently afterwards?
- How literal must it be: strictly factual, dramatized with disclosed liberties, or fiction?
- Any constraints: names to avoid, confidentiality, tone, deadline?

**Round 2: Arc**
- What was the situation before: what was normal, what did people believe?
- What happened that disrupted it? When exactly?
- What went wrong, or what got in the way?
- What was the turning point: the moment, decision, or discovery?
- What is different now?

**Round 3: Texture**
- Take me to the single most vivid moment. Where were you, who was there, what did you see?
- What did someone actually say at that point?
- What numbers capture the stakes or the result?
- Is there an artifact (screenshot, message, graph, document) I can look at?

**Round 4: Meaning**
- What surprised you most?
- What do people most often get wrong about this?
- If you could tell your past self one thing at the start, what would it be?
- Why does this matter to *this* audience specifically?

## When to stop

Stop interviewing when all of these hold:

- Every field in the brief's Frame and Story sections is filled.
- You have at least one moment you can write as a scene (time, place, person, action).
- You can name the turning point.
- The takeaway is one sentence the user has agreed with.

Usually this takes 2–4 rounds. If the user's answers stay thin after round 3, say what's missing and offer to proceed with marked gaps.

## Mining files

Facts beat interpretation. Extract the timeline, actors, numbers, and written words.

| Source | What to pull |
|---|---|
| Git history (`git log --stat`, `git log --since=… --until=…`) | Timeline, who worked on what, the size and pace of change, telling commit messages |
| PR and issue threads | Debates, decisions, written quotes, reversals |
| Incident timelines, postmortems | Exact times, what was observed, actions taken, impact numbers |
| Decision records (ADRs), design docs | The options considered and why the losers lost (good tension) |
| Chat exports, meeting notes | Real-time reactions, verbatim quotes |
| Metrics, dashboards, changelogs | Before and after numbers |

Mine files after the frame round and before the arc round, so you don't ask the user for facts the files already hold. Log each item in the ledger with its path, commit hash, or URL. Read-only: never modify the files you're mining.

## Web research

Use it for context the audience lacks (history, how a technology works, industry numbers), not to inflate the story. Prefer primary sources, verify every number you use, and log the URL. Under Documentary fidelity, unverified web claims don't go in.

## Other stakeholders

When part of the story belongs to someone you can't interview directly:

1. Fill `assets/interview-guide.md` with questions tailored to what that person uniquely knows (usually rounds 2–3 from their point of view).
2. Give it to the user to take to them.
3. When answers come back, add them to the ledger attributed to that person, and treat recollections as paraphrase unless written down.
