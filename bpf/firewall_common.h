#ifndef FIREWALL_COMMON_H
#define FIREWALL_COMMON_H

#include <linux/types.h>

// --- Constants ---
#define ACTION_ALLOW 0
#define ACTION_BLOCK 1
#define ACTION_RATE_LIMIT 2

#define EVENT_TYPE_BLOCK 1
#define EVENT_TYPE_NEW_IP 2
#define EVENT_TYPE_PASS 3 // Event for allowed traffic

// ... (rest of the file is the same)

#endif // FIREWALL_COMMON_H
