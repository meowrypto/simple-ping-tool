# Multi-DNS Internet Connectivity & Latency Monitor

**Fixed and maintained by [Farzad Doosti](https://github.com/meowrypto)**

A lightweight Windows Batch script that checks your internet stability by pinging 5 of the most
reliable, widely-used public DNS servers and reports color-coded latency for each one.

Instead of relying on a single checkpoint, this tool gives you a broader look at your network's status.

## Features

- **Multi-Target Ping:** Tests Google, Cloudflare, Quad9, Cisco OpenDNS, and AdGuard.
- **Fast Diagnostics:** Sends 2 packets per server for a quick yet accurate status report.
- **Color-Coded Latency:**
  - 🟢 **Green** — average latency under 70 ms (excellent)
  - 🟠 **Orange** — average latency between 70–200 ms (acceptable)
  - 🔴 **Red** — average latency above 200 ms (poor)
- **Jitter / Stability Check:** measures how much the round-trip time varies between
  consecutive pings, not just the average — a connection can have a "good" average
  latency and still feel unstable if jitter is high.
  - 🟢 **Green** — jitter under 10 ms (very stable)
  - 🟠 **Orange** — jitter 10–30 ms (noticeable variation)
  - 🔴 **Red** — jitter above 30 ms (unstable)
- **Neon "ONLINE" indicator:** the online/offline status is always shown in a distinct
  phosphor-green color, separate from the latency color, so the two never get mixed up.
- **No Installation:** Pure Windows Batch script, zero dependencies.

## Tested DNS Servers

| Provider | IP |
|---|---|
| Google DNS | `8.8.8.8` |
| Cloudflare DNS | `1.1.1.1` |
| Quad9 DNS | `9.9.9.9` |
| Cisco OpenDNS | `208.67.222.222` |
| AdGuard DNS | `94.140.14.14` |
| Yandex.DNS (Basic) | `77.88.8.8` |
| DNS.WATCH | `84.200.69.80` |
| CleanBrowsing (Security) | `185.228.168.9` |
| Comodo Secure DNS | `8.26.56.26` |
| Alternate DNS | `76.76.19.19` |

## How to Use

1. Download `ping_tool.bat`.
2. Double-click the file to execute (or run it from `cmd.exe`).
3. Review the terminal output: each server shows `ONLINE`/`OFFLINE` plus a color-coded
   average latency.

## Changelog (v1.6.2 — reverted Quality Score, added credit line)

The Quality Score / ranking table experiment (v1.6.0–v1.6.1) added more moving
parts than it was worth and was reverted in favor of the simpler, proven v1.5.2
behavior: sequential testing, live per-server output, no scoring or sorting logic.
That's the version this script is based on again.

Also added a credit line — **"Fixed and maintained by Farzad Doosti"** — printed
at the end of the run, after the "Test Completed" banner.

## Changelog (v1.6.1 — fixed scoring + real sorted table, reverted in v1.6.2)

Two problems were reported with v1.6.0 and both are fixed here:

**1. Almost every server scored 0/100.** The original formula used fixed penalty
numbers (`latency/2`, `jitter×1.5`) that assumed "good" latency is under ~70ms.
On a connection where typical latency is 150–250ms and jitter is 10–65ms (a
perfectly normal real-world result, just not blazing-fast), the formula punished
everyone down to zero, making the score useless for comparison.

Fixed by rebuilding the formula around the *same* `GOOD_MAX` / `OK_MAX` /
`JITTER_GOOD_MAX` / `JITTER_OK_MAX` thresholds already used for the color coding:
latency and jitter are each scored 0–100 relative to where they fall between
"good" and "acceptable," then blended 70% latency / 30% jitter. This keeps scores
meaningful and spread out (e.g. 76, 67, 44, 40, 29 instead of five different
flavors of 0) regardless of whether your baseline connection is fast or slow.

**2. The final ranking wasn't actually sorted.** The hand-written sort logic (a
bubble sort using array-of-array indexing) had a bug and silently left every
result in its original test order. Rather than debug fragile manual sorting logic
further, this was replaced with Windows' own built-in `sort` command — each
result is written to a temp file as `score|name|status|latency|jitter`
(score zero-space-padded to 3 characters so plain text sort also sorts correctly
numerically), then `sort /R` reverse-sorts it in one reliable step. No custom sort
algorithm left to have bugs in.

**Also per feedback:** the inline `[Score: X/100]` shown next to each server during
testing was removed — the score now only appears once, in the final ranking table,
which is now a real aligned table (Rank / DNS Server / Score / Latency / Jitter
columns) instead of a list of loose lines.

## Changelog (v1.6.0 — Quality Score + final ranking, superseded)

Introduced the Quality Score concept and a first attempt at a ranking table.
Superseded by v1.6.1 above after real-world testing surfaced a scoring formula
that was too harsh and a sort that didn't actually sort. Kept here for history.

## Changelog (v1.5.2 — reverted to sequential, just faster timeout)

The parallel version (v1.5.0/v1.5.1) tested all servers at once but always waited a
fixed ~12 seconds before showing *any* results, which felt worse in practice than
watching each server's result appear one by one as it finishes. Reverted to
sequential testing (call `:TestDNS` once per server, one after another, same as
before) and kept the script's simplicity and reliability.

The only speed change kept from that experiment: `ping` now uses `-w 1200`
(1200 ms per-packet timeout) instead of Windows' default 4000 ms. A genuinely
unreachable server now shows `OFFLINE` noticeably faster instead of making you
wait up to 4 seconds per lost packet, without cutting it so close that a real but
slightly slow reply gets mistaken for a timeout. Adjustable via `PING_TIMEOUT` at
the top of the script.

## Changelog (v1.5.1 — fixed a startup crash in v1.5.0)

v1.5.0 could fail immediately with `The system cannot find the batch label specified
- waitloop`. This came from a classic Windows Batch pitfall: using `goto` inside a
chain of nested `if` blocks can confuse `cmd.exe`'s label lookup, even though the
label genuinely exists in the file. This was superseded by v1.5.2 (see above), which
drops the parallel approach entirely.

## Changelog (v1.5.0 — parallel testing, faster results — superseded)

This release tested all 10 servers at once using `start /b` and a polling loop, to
avoid the up-to-40-second wait of running them one after another. It was replaced by
v1.5.2 after testing showed the fixed wait before showing results felt worse than
sequential output, and after v1.5.1's `goto`-related crash. Kept here for history;
see v1.5.2 for the current approach.

Testing 10 DNS servers one after another was slow, for two reasons:

1. **Sequential execution:** each server had to fully finish before the next one
   started, so total time was the *sum* of all 10 tests.
2. **High default timeout:** Windows' `ping` waits up to 4000 ms per lost packet by
   default. A single unreachable server with 6 packets could take up to 24 seconds
   on its own.

This release fixes both:

- **All 10 servers are now tested in parallel.** Each server gets its own tiny
  helper `.bat` file (written to `%TEMP%`) that runs `ping` in the background via
  `start /b` and drops a "done" marker file when finished. The main script waits
  until every marker appears (or a safety cap of `MAX_WAIT` seconds, default 20)
  before moving on to print results — so total run time is roughly as long as the
  *slowest single server*, not the sum of all of them.
- **Ping timeout lowered to 1500 ms** (`PING_TIMEOUT` variable, was the Windows
  default of 4000 ms), so unreachable servers are marked `OFFLINE` faster without
  meaningfully affecting servers that are actually online.
- Results are still printed in the original, consistent order (Google, Cloudflare,
  Quad9, ...) regardless of which test happened to finish first.
- All temporary files (`.txt`, `.done`, `.job.bat`) are cleaned up automatically
  after each run.

If you ever want to go back to a slower-but-simpler sequential run, or need to tune
things further, `PING_COUNT`, `PING_TIMEOUT`, and `MAX_WAIT` are all adjustable at
the top of the script.

## Changelog (v1.4.0 — more DNS servers)

Added 5 more well-known public DNS resolvers, bringing the total to 10:
`Yandex.DNS`, `DNS.WATCH`, `CleanBrowsing` (Security filter), `Comodo Secure DNS`,
and `Alternate DNS`. Each is added the same way as the original five — one line
calling the `:TestDNS` subroutine — so extending the list further later is a
one-line change.

Note: Verisign Public DNS was intentionally left out — the free service was
discontinued in 2025 and its old IPs (`64.6.64.6` / `64.6.65.6`) no longer resolve
reliably.

## Changelog (v1.3.0 — Jitter support)

Added the ability to measure **jitter** (connection stability), not just raw average
latency.

- Each server is now pinged 6 times per test (previously 2), giving enough samples to
  measure variation between consecutive replies.
- The script reuses a single `ping` run per server (output saved to a temp file) to
  compute both the Average latency **and** the Jitter — no extra network calls needed.
- **Jitter calculation:** the mean of the absolute differences between each pair of
  consecutive round-trip times. This is a simplified version of the interarrival-jitter
  concept from RFC 3550 — smaller values mean a more stable, consistent connection;
  large jitter means the delay is swinging up and down even if the average looks fine.
- Jitter gets its own color coding, independent of the latency color:
  - 🟢 Green — jitter under 10 ms (very stable)
  - 🟠 Orange — jitter 10–30 ms (noticeable variation)
  - 🔴 Red — jitter above 30 ms (unstable connection)
- Thresholds are configurable via the `JITTER_GOOD_MAX` / `JITTER_OK_MAX` variables at
  the top of the script, same pattern as the existing latency thresholds.

## Changelog (v1.2.0 — bug-fix release)

This release fixes two bugs present in earlier versions:

1. **Startup error `'Quality' is not recognized...`**
   The window `title` command contained an unescaped `&` character. In `cmd.exe`, `&`
   separates commands, so `title ... Latency & Quality Monitor` was parsed as two
   commands, and the second (`Quality Monitor`) failed as an "unknown command." Fixed by
   removing the ampersand from the title string.

2. **Latency colors always showing green, regardless of actual ping time**
   The ping-output parser used `delims== ` (both `=` and space as delimiters) and took
   token 4. Because of how consecutive delimiters collapse in `FOR /F`, this actually
   captured the **Maximum** value instead of the **Average**, and left a trailing comma
   attached (e.g. `25ms,` instead of `22ms`). That trailing comma made the value an
   invalid integer, so Windows' `IF ... LSS ...` silently fell back to plain **string**
   comparison instead of numeric comparison. In string comparison, any latency starting
   with a small digit (1 or 2) tests as "less than 60" purely because `'1'`/`'2'` sort
   before `'6'` — which is why every result showed up green even at 200+ ms.
   Fixed by changing the delimiter to `=` only, which correctly isolates the Average
   value with no trailing comma, so numeric comparison works as intended.

Also restructured the script to use a single `:TestDNS` subroutine called once per
server instead of duplicating the same block five times — easier to maintain and less
error-prone for future edits.

## Known limitations

- The script matches the English string `Average` in `ping`'s output. On a
  non-English Windows locale (e.g. a Persian-language Windows install), `ping`'s
  output text is translated and the script will report every server as `OFFLINE`
  even though it's reachable. If this happens, run the script inside an English-locale
  `cmd.exe`, or open an issue with your locale's exact `ping` output so matching can be
  added.

## License

This project is open-source and available under the [MIT License](LICENSE).
