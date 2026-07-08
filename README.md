# Multi-DNS Internet Connectivity & Latency Monitor

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

## How to Use

1. Download `ping_tool.bat`.
2. Double-click the file to execute (or run it from `cmd.exe`).
3. Review the terminal output: each server shows `ONLINE`/`OFFLINE` plus a color-coded
   average latency.

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