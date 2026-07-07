# Multi-DNS Internet Connectivity Tester

A lightweight Windows Batch script designed to check your internet stability by pinging 5 of the most reliable and widely used global DNS servers. 

Instead of relying on a single checkpoint, this tool gives you a broader look at your network's status.

## Features
* **Multi-Target Ping:** Tests connection against Google, Cloudflare, Quad9, OpenDNS, and AdGuard.
* **Fast Diagnostics:** Sends 2 packets per server for a quick yet accurate status report.
* **Status Summary:** Clearly filters output to show latency statistics and a simple `ONLINE` / `OFFLINE` indicator for each service.
* **No Installation:** Pure Windows Batch script, zero dependencies.

## Tested DNS Servers
1. **Google DNS:** `8.8.8.8`
2. **Cloudflare DNS:** `1.1.1.1`
3. **Quad9 DNS:** `9.9.9.9`
4. **Cisco OpenDNS:** `208.67.222.222`
5. **AdGuard DNS:** `94.140.14.14`

## How to Use
1. Download `ping_tool.bat`.
2. Double-click the file to execute.
3. Review the terminal output to identify if specific servers are unreachable or if your overall connection is down.

## License
This project is open-source and available under the [MIT License](LICENSE).
