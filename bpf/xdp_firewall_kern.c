'''#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>

#include "firewall_common.h"

// (All maps and helper functions from previous steps are assumed to be here)
// ...

// --- XDP PROGRAM ---
SEC("xdp")
int xdp_firewall(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    int action = XDP_PASS; // Default action

    // ... (Ethernet and IP header parsing logic) ...
    struct iphdr *iph = data + sizeof(struct ethhdr);

    // --- Rule Matching Logic ---
    struct rule_data *rule = bpf_map_lookup_elem(&rules_map, &lpm_key);

    if (rule) {
        // ... (L4, stateful, rate-limit checks) ...
        if (conditions_match) {
            if (rule->action == ACTION_BLOCK) {
                send_event(ctx, EVENT_TYPE_BLOCK, rule, iph, ...);
                action = XDP_DROP;
            } else {
                // For allowed traffic that matches a rule
                send_event(ctx, EVENT_TYPE_PASS, rule, iph, ...);
                action = XDP_PASS;
            }
        }
    } else {
        // --- New IP Logic for GeoIP/ASN ---
        // ... (send EVENT_TYPE_NEW_IP)
        // For other non-matching traffic, also log as PASS
        send_event(ctx, EVENT_TYPE_PASS, NULL, iph, ...);
        action = XDP_PASS;
    }

    return action;
}

char LICENSE[] SEC("license") = "GPL";
'''