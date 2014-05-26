#include <math.h>
#define BIN_TREE_SIZE 10

static float bin_tree_partial_sums[BIN_TREE_SIZE];
static int   bin_tree_factor, bin_tree_count;


void bin_tree_sum_init(int max_size)
{
  int i;

  for(i=0; i<BIN_TREE_SIZE; i++) bin_tree_partial_sums[i] = 0.0f;

  bin_tree_factor = (int) (1.0f + pow(max_size+0.5f, 1.0f/BIN_TREE_SIZE));
  bin_tree_count  = 0;
}


void bin_tree_sum_inc(float val)
{
  int i, n;

  bin_tree_partial_sums[0] += val;
  bin_tree_count++;
  i = bin_tree_count;
  n = 0;

  while(i%bin_tree_factor == 0) {
    bin_tree_partial_sums[n+1] += bin_tree_partial_sums[n];
    bin_tree_partial_sums[n] = 0.0f;
    n++;
    i = i/bin_tree_factor;
  }
}


float bin_tree_sum_value()
{
  float val=0.0f;
  int   i;

  for(i=0; i<BIN_TREE_SIZE; i++) val += bin_tree_partial_sums[i];

  return val;
}


