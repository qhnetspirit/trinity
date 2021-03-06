#include <stdlib.h>
#include <netinet/udp.h>
#include "net.h"
#include "random.h"
#include "utils.h"	// RAND_ARRAY
#include "compat.h"

static const unsigned int udp_opts[] = {
	UDP_CORK, UDP_ENCAP
};

void udp_setsockopt(struct sockopt *so)
{
	unsigned char val;
	char *optval;

	val = RAND_ARRAY(udp_opts);
	so->optname = udp_opts[val];

	switch (so->optname) {
	case UDP_CORK:
		break;
	case UDP_ENCAP:
		optval = (char *) so->optval;
		optval[0] = RAND_RANGE(1, 3);        // Encapsulation types.
		break;
	default:
		break;
	}
}
