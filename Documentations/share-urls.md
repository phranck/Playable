---
id: share-urls
title: Share URLs
position: after-guide
---

A podcast on Playable has two addresses. Both can be shared and both open the app when it is installed.

## The readable address

```text
https://playable.at/mein-podcast-name
```

This is the one to offer somebody who is sharing. It reads as the podcast's name, so whoever receives it knows what they are about to open.

The name part is a slug: lowercase, joined by single hyphens, and made from the podcast's title. German vowels are spelled out rather than stripped, so `Österreich Heute` becomes `oesterreich-heute`. Stripping the diacritic instead would produce `sterreich-heute`, and folding to the bare vowel would produce `osterreich-heute`, which is a different word.

## The identifier address

```text
https://playable.at/live/Ab3Cd5Ef7G
```

This one carries an identifier instead of a name. It never changes, and it exists before a podcast has a slug at all, which is why Podlive shares this form: a Parse object identifier is what it has.

The identifier is opaque. Nothing about the address changes when Playable issues identifiers of its own.

## What happens when a podcast is renamed

Every slug a podcast has ever had keeps pointing at it, permanently.

| Address | Answer |
|---|---|
| The current slug | The podcast |
| A slug it used to have | A permanent redirect to the current one |
| A slug no podcast has held | Not found |
| A withdrawn podcast | Gone, rather than not found |
| The identifier address | The podcast, whatever it is called now |

A released slug is never given to a different podcast. If it were, every link shared before the rename would start resolving to somebody else's show, and nothing would report it: the link keeps working, it is simply wrong.

## What a slug can never be

The readable address sits at the root of the site, so a slug competes with every page the site has. A slug can therefore never be one of the paths the site owns, such as `live`, `about`, `privacy`, `impressum` or `.well-known`. That is checked when a slug is minted rather than when somebody visits it, so the clash lands on whoever can still choose a different name.

## Opening the app

Both addresses are Universal Links. Because the readable one sits at the root, the apps claim the root and exclude every path the site owns first, in that order, since the first matching rule decides.

`/live` is the exception that is easy to get wrong. The listing page at `/live` belongs to the site, whilst every address below it belongs to the apps, so the two are claimed separately. Excluding `live` outright would quietly stop every identifier-based link opening the app, and nothing would report that either: the link would keep working, in a browser.

A stream that has ended is not an error. The address still resolves to the podcast, and the page says the stream is over, because somebody who followed a shared link deserves to see whose stream it was.
