# XDP Firewall

A high-performance, stateful firewall using eBPF and XDP.

## Dependencies

To compile and run this project, you will need:
- `clang` and `llvm`
- `libbpf-devel` (or `libbpf-dev` on Debian/Ubuntu)
- `linux-headers` for your kernel version
- `python3` and `pip`
- Python libraries: `libbpf`, `psycopg2-binary`, and `geoip2`

```bash
# Example on Fedora/CentOS
sudo dnf install clang llvm libbpf-devel kernel-devel
# Example on Debian/Ubuntu
# sudo apt-get install clang llvm libbpf-dev linux-headers-$(uname -r)

pip install libbpf psycopg2-binary geoip2
```

### GeoIP Database

This project uses the MaxMind GeoLite2 database for GeoIP lookups. 
1. Download the `GeoLite2-Country.mmdb` and `GeoLite2-ASN.mmdb` files from the [MaxMind website](https://www.maxmind.com/en/geolite2/signup). You will need to sign up for a free account.
2. Place the downloaded `.mmdb` files into the `userspace/` directory.

## Project Structure

- `bpf/`: Contains the eBPF kernel-space C code.
- `userspace/`: Contains the user-space Python controller.
  - `GeoLite2-Country.mmdb`: GeoIP country database.
  - `GeoLite2-ASN.mmdb`: GeoIP ASN database.
- `rules.json`: Defines the firewall rules.
- `Makefile`: Compiles the eBPF code.
- `docker-compose.yml`: Manages the PostgreSQL database for logging.

## Development Plan

1.  [x] **Step 1: Basic Skeleton & Environment Setup**
2.  [x] **Step 2: Basic Packet Filtering (IP, Port, Protocol)**
3.  [x] **Step 3: PostgreSQL Logging & Rule Loading**
4.  [ ] **Step 4: Advanced Rules (GeoIP, ASN, TCP Flags)**
5.  [ ] **Step 5: Stateful TCP Inspection**
6.  [ ] **Step 6: Rate Limiting**
