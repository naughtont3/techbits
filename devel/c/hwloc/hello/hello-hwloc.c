/*
 * Testing with something like this:
 *
 *     bash:$ numactl --physcpubind=7 ./hello-hwloc
 *     bash:$ numactl --physcpubind=3,4,5,8 ./hello-hwloc 
 *
 * References:
 *  - 2012 HWLoc tutorial for guide
 *    https://www.open-mpi.org/projects/hwloc/tutorials/20120702-POA-hwloc-tutorial.pdf
 *  - HWLoc v1.11.8 documentation
 *    https://www.open-mpi.org/projects/hwloc/doc/v1.11.8/a00140.php#gacba7ecb979baf824d5240fa2cb2a8be6
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "hwloc.h"

int main (int argc, char **argv)
{
    int rc;
	int i;
	int n;
    int nsockets = 0;
    int ncores = 0;
    int npus = 0;
    int depth  = 0;
    int num_depths = 0;
    hwloc_topology_t topo;
    hwloc_obj_t obj;
	//hwloc_cpuset_t set;
	hwloc_bitmap_t set;
	hwloc_pid_t pid;
	int flags = 0;
    char *str = NULL;

	pid = getpid();

    hwloc_topology_init(&topo);
    hwloc_topology_load(topo);

    /* Number of Packages (sockets) */
    nsockets = hwloc_get_nbobjs_by_type(topo, HWLOC_OBJ_PACKAGE);

    /* Number of Cores */
    ncores = hwloc_get_nbobjs_by_type(topo, HWLOC_OBJ_CORE);

    /* Number of ProcessingUnits (hwthreads?) */
    npus = hwloc_get_nbobjs_by_type(topo, HWLOC_OBJ_PU);

    /* Number of Depths in topology */
    num_depths = hwloc_topology_get_depth(topo);

    printf("Hello World nsockets=%d ncores=%d npus=%d depths=%d\n",
            nsockets, ncores, npus, num_depths);

	/* ################################################### */

	set = hwloc_bitmap_alloc();
	if (!set) {
		fprintf(stderr, "failed to allocate a bitmap\n");
		hwloc_topology_destroy(topo);
		return (EXIT_FAILURE);
	}

	/* retrieve the CPU binding of the current entire process */
	hwloc_get_cpubind(topo, set, flags | HWLOC_CPUBIND_PROCESS);
	//hwloc_get_cpubind(topo, set, flags | HWLOC_CPUBIND_THREAD);

    /* set = hwloc_bitmap_dup(obj->cpuset); */
    hwloc_bitmap_asprintf(&str, set);
    printf("cpuset set is %s\n", str);
    free(str);
	str = NULL;

	/* TJN: Testing results using 'numactl --physcpubind=7 ./hello-hwloc' */
	n = hwloc_bitmap_first(set);
    printf("bitmap_first = %d\n", n);

	/* TJN: Testing results using 'numactl --physcpubind=7 ./hello-hwloc' */
	n = hwloc_bitmap_last(set);
    printf("bitmap_last = %d\n", n);

	hwloc_bitmap_free(set);

	/* ################################################### */

	set = hwloc_bitmap_alloc();
	if (!set) {
		fprintf(stderr, "failed to allocate a bitmap\n");
		hwloc_topology_destroy(topo);
		return (EXIT_FAILURE);
	}

	hwloc_get_proc_cpubind(topo, pid, set, flags | HWLOC_CPUBIND_PROCESS);

    /* set = hwloc_bitmap_dup(obj->cpuset); */
    hwloc_bitmap_asprintf(&str, set);
    printf("cpuset (proc) set is %s\n", str);
    free(str);
	str = NULL;

	/* Testing results using 'numactl --physcpubind=7 ./hello-hwloc' */
	n = hwloc_bitmap_first(set);
    printf("bitmap_first (proc) = %d\n", n);

	/* Testing results using 'numactl --physcpubind=7 ./hello-hwloc' */
	n = hwloc_bitmap_last(set);
    printf("bitmap_last (proc) = %d\n", n);

	hwloc_bitmap_free(set);

#if 0
    for (depth=0; depth < num_depths; depth++) {
        for (i=0; i < hwloc_get_nbobjs_by_depth(topo, depth); i++) {
            obj = hwloc_get_obj_by_depth(topo, depth, i);
        }
    }
#endif

    hwloc_topology_destroy(topo);

    return (EXIT_SUCCESS);
}
