MPICC=mpicc
CFLAGS=-O2 -Wall

all: q1 q2 q3 q4

q1: q1_blocking_ping_pong.c
	$(MPICC) $(CFLAGS) $< -o $@
q2: q2_nonblocking_ping_pong.c
	$(MPICC) $(CFLAGS) $< -o $@
q3: q3_deadlock_and_fix.c
	$(MPICC) $(CFLAGS) $< -o $@
q4: q4_ring_token_nonblocking.c
	$(MPICC) $(CFLAGS) $< -o $@

clean:
	rm -f q1 q2 q3 q4
