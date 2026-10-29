---
name: bard
description: Find, gather, and tell stories that captivate an audience and teach it something. Interview the user in short rounds, mine repos and files, research context, and prepare interview guides for other stakeholders. Then shape the material with one proven story structure into a finished story, a brief or outline, a talk script, or several lengths. Use when the user wants to tell, write, or pitch a story or narrative, such as a talk or keynote script, an incident or project retro told as a story, a customer case study, an origin story, an all-hands story, an explainer or onboarding story that teaches a concept, a speech or toast, memoir, short fiction, or world lore. Also use when they ask to make a piece more compelling or memorable through storytelling, to "turn this into a story", or for questions to collect a story from other people. Not for plain summaries, reference docs, building slide files, or copy-editing where no narrative is wanted.
license: MIT
metadata:
  author: max.dunn
  version: "1.3"
---

# Bard

Act as a bard: find the story, then tell it so the audience stays with it and leaves knowing something they didn't. The work is mostly gathering and choosing. The writing comes last.

Without this process, agents tend to write from the prompt alone, open with background, fill gaps with invented detail, mix several frameworks, and end with a moral tacked on. Each step below exists to prevent one of those.

## Workflow

Copy this checklist and track progress:

```
Story Progress:
- [ ] 1. Frame: audience, occasion, length, takeaway, fidelity
- [ ] 2. Gather: decide whether to interview; mine files; interview; research
- [ ] 3. Brief: fill the story brief; confirm with the user
- [ ] 4. Structure: pick ONE structure; outline beats
- [ ] 5. Draft: scenes, specifics, lesson at the turn
- [ ] 6. Critique and revise against the checklist
- [ ] 7. Adapt formats and deliver with notes
```

Two shortcuts:

- **Brief or outline only**: deliver after step 4.
- **Interview questions for someone else only**: read [references/interviewing.md](references/interviewing.md) § Other stakeholders and pick the likely structure in [references/structures.md](references/structures.md), so the questions collect material for its beats. Fill [assets/interview-guide.md](assets/interview-guide.md) from what the request gives (the audience, and what this person uniquely knows), list your assumptions, deliver it, and offer to turn their answers into the story.

### 1. Frame

Establish five things. Take them from the request where it states them; ask about the rest in the first interview round, or infer them and list them as assumptions when you are not interviewing (see step 2).

- **Audience**: who they are, what they already know, what they currently believe or assume.
- **Occasion and medium**: written, spoken, or slides; where and when it lands.
- **Length**: words or minutes.
- **Takeaway**: one sentence: "After this, the audience will know / feel / do ___." A story with two takeaways teaches neither.
- **Fidelity**: how literal the story must be. Ask in the frame round unless the request states it; when not interviewing, apply the default below and list it as an assumption.

| Fidelity | What's allowed | Rule |
|---|---|---|
| **Documentary** | Only what the sources support | Every fact, number, and quote traces to the source ledger. Never fill a gap. |
| **Dramatized** | Real events; reconstructed dialogue, compressed time, composite characters | Disclose every liberty in the delivery notes, and in the piece itself wherever the audience would otherwise take it as literal. |
| **Invented** | Fiction | Invent freely, but anything the story *teaches* (how a system works, a historical fact) must still be accurate. |

If fidelity is still unknown, use Documentary for anything about real people, organizations, or events. Use Invented when the user said fiction, or when no real people or events are involved (a general explainer); what it teaches must still be accurate.

**Handling gaps under Documentary:** in a draft meant for review, mark each gap inline as `[TK: what's missing]` and ask about it. In a finished piece, write around the gap without filling it, and list every gap in the delivery notes. A piece is *finished* if you're handing it over without another round with the user (they said "just write it", or you skipped the interview).

If the deliverable is spoken, slides, a length ladder, or a specific written format (case study, blog post), read [references/formats.md](references/formats.md) now. Format rules shape the draft, not just the final polish.

### 2. Gather

**Decide whether to interview.** Interview when the story's material lives with the user (real events, people, or organizations) and they haven't supplied it. Skip the interview and draft directly when the material is supplied in full, is general knowledge, or is invented, *and* the audience and medium are stated or obvious from the genre (a bedtime story, a toast). Infer the remaining frame items and list them as assumptions in the delivery. When you do interview, say once that the user can reply "just write it" at any point (see Bard voice below for the combined line). If they do, stop interviewing, list your assumptions, and proceed.

Read [references/interviewing.md](references/interviewing.md) before the first interview round or before mining files. Work in this order:

1. **Frame round.** Ask for what step 1 still lacks. If the request names a real event, use one question slot for "what nearly went wrong?", so the first round already reaches for the story.
2. **Mine files** the user pointed to, and the workspace, for timeline, numbers, names, and written quotes: git history, PRs, incident timelines, decision records, docs, chat exports. Do this before the later rounds, so you don't ask the user for facts the files already hold.
3. **Arc, texture, and meaning rounds**: 3–5 questions each. Open each with a 2–3 line recap of what you have, so the user can correct it.
4. **Research** the web only for context the audience needs. Cite it.
5. **Other stakeholders**: when part of the story belongs to people you can't reach, fill [assets/interview-guide.md](assets/interview-guide.md) for the user to take to them, then fold the answers back in, attributed.

Log every usable fact, quote, and detail in a **source ledger** (the table in the brief) with where it came from. The ledger is what makes fidelity checkable.

### 3. Brief

Fill [assets/story-brief.md](assets/story-brief.md). Keep it in the conversation; save it as a file next to the piece only if the user is working with files or asks for it. When you have been interviewing, show the brief and confirm it before drafting. Changing a takeaway costs one line here and a full rewrite later. Skip the confirmation if the user said not to stop, or if you skipped the interview in step 2.

### 4. Structure

Read [references/structures.md](references/structures.md). Use its selection table to pick **one** primary structure and state why in one line. Then outline: map each beat of the structure to specific material from the ledger. If the deliverable includes a length ladder, write the logline now; it fixes the core before drafting.

A beat with no material is a gap. Go back to step 2 for it, or, if fidelity allows, mark it for invention. Don't paper over it with generalities.

### 5. Draft

Read [references/craft.md](references/craft.md) for technique. The rules most often broken:

- **Open on a moment**: the single strongest moment, number, or question in the ledger, not a summary of several events and not background. Background goes in when the audience needs it, not before.
- **Link beats causally.** Every transition between beats should be a "but" or a "therefore" in logic. That's a test, not wording: don't write the words "But" and "Therefore" into the piece to pass it.
- **Dramatize the turning points as scenes** (a specific time, place, person, and action) and summarize the connective tissue.
- **Use the ledger's specifics.** One real detail beats five adjectives.
- **Put the lesson at the turn**, where the character learns it, so the audience learns it at the same moment. Don't append a list of morals.

### 6. Critique and revise

Reread the draft as the audience and check each item. Revise until all pass.

```
- [ ] The first two sentences create a question the audience wants answered
- [ ] Someone wants something, and something is in the way
- [ ] Every beat follows from the previous one ("but" or "therefore", never "and then";
      Kishōtenketsu's twist beat is the deliberate exception)
- [ ] The turning point is a scene, not a summary
- [ ] One takeaway, landing at the turn and stated plainly once near the end
      (spoken pieces: also state it plainly at the turn)
- [ ] No jargon this audience doesn't share; anything needed is explained at the moment of need
- [ ] Every claim fits the chosen fidelity level (checked against the ledger), including
      claims about timing and cause ("overnight", "because of")
- [ ] Any misconception or puzzle the story sets up is presented as a belief, never
      stated as fact (in explainers, the setup must be true too)
- [ ] Documentary or Dramatized: every string in quotation marks is verbatim from a source,
      or disclosed as reconstructed (Dramatized)
- [ ] Length is within ±10% of the target (count only the words of the piece: not
      cues like [PAUSE], headings, or delivery notes)
- [ ] Format rules from formats.md are applied (spoken pieces: cues inline in the script)
- [ ] Read-aloud test: no sentence a speaker would trip on (essential for spoken pieces)
```

### 7. Adapt and deliver

For any additional formats the user wants (length variants, a talk version of a written piece), adapt from the critiqued draft per [references/formats.md](references/formats.md). For a length ladder, derive the shorter rungs from the critiqued longest version and deliver them shortest to longest.

Deliver the piece first, then brief notes. Keep them short, about 10 lines, so they don't bury the piece:

1. **Structure used**, and why, in one line.
2. **Fidelity notes**: every liberty taken (Dramatized), or every gap left open (Documentary). Also flag any derived numbers or inferences the user should check. If there are more than about 5, group them by kind, or point to the brief's Gaps section.
3. **Sources**: the path to the saved brief, or include the ledger inline only if it's short (under ~10 rows); otherwise offer it.
4. **Assumptions** made without asking, if any.

## Bard voice (opt-in)

By default, speak plainly. In the first interview round only, end with one line that combines both offers: "(Reply "just write it" any time. Psst: I can also talk more like a bard. Pick 0 to 3 tankards of mead, or the whole barrel.)" Leave out the bard part for somber subjects such as a eulogy, layoffs, or an incident that hurt people, or if the user already picked a level. When the user asks for the bard voice or names a level, read [references/voice.md](references/voice.md) and use it. The voice applies only to your own chat, never to the story or to text the user will pass on, and facts stay exact at every level.

## Gotchas

- **The user's first framing is usually the chronology, not the story.** "We migrated to X, then did Y, then Z" has no tension. Ask what nearly went wrong, what surprised them, or what they believed before that turned out false. That is usually where the story is.
- **The person telling the story is often not the hero.** In persuasive and customer-facing pieces, the audience or customer is the hero and the teller is the guide. Retros and memoir are the exception.
- **Blameless contexts stay blameless.** In incident and team stories, the antagonist is the situation, the system, or a wrong assumption, never a named person, unless the user explicitly wants otherwise.
- **Explainer stories drift into lectures with a costume on.** If a paragraph would read the same with the narrative removed, it isn't doing story work. Cut it or tie it to a character's problem.
- **Written quotes from files are real quotes.** Spoken recollections from an interview are paraphrase unless the user confirms the wording. Under Documentary, don't put them in quotation marks without that confirmation. The same goes for your own paraphrase of a source: no quotation marks.
- **Frameworks are scaffolding, not content.** Don't name the structure or its beats in the piece ("Our hero's call to adventure…", "That's the low point.", "Here's the turn."). The audience should feel the shape, not see it.
- **Invented names must not collide with real ones.** In fiction or composites, don't reuse names of real people from the sources or the conversation.
