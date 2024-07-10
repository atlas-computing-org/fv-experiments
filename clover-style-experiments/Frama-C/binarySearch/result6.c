#include <stddef.h>

/*@
  requires \valid(a + (0 .. length-1));
  requires length >= 0;
  requires \forall integer i; 0 <= i < length - 1 ==> a[i] <= a[i + 1];

  assigns \nothing;
  
  ensures 0 <= \result <= length;
  ensures \forall integer i; 0 <= i < \result ==> a[i] < key;
  ensures \forall integer i; \result <= i < length ==> a[i] >= key;
*/
int BinarySearch(int a[], int length, int key) {
  int lo = 0;
  int hi = length;

  /*@
    loop invariant 0 <= lo <= hi <= length;
    loop invariant \forall integer i; 0 <= i < lo ==> a[i] < key;
    loop invariant \forall integer i; hi <= i < length ==> a[i] >= key;
    loop invariant \forall integer i; 0 <= i < length - 1 ==> a[i] <= a[i + 1];
    loop assigns lo, hi;
    loop variant hi - lo;
  */
  while (lo < hi) {
    int mid = lo + (hi - lo) / 2;

    /*@ assert lo <= mid < hi; */
    /*@ assert 0 <= mid < length; */

    if (a[mid] < key) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }

  /*@ assert 0 <= lo <= length; */
  /*@ assert \forall integer i; 0 <= i < lo ==> a[i] < key; */
  /*@ assert \forall integer i; lo <= i < length ==> a[i] >= key; */

  return lo;
}

