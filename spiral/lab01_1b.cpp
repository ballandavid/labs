#include "lab01_1b.h"

void SpiralSorrend(const int* matrix, int n, int* spiral)
{
	int count = n*n;
	
	int dir = 0; // 0 - right, 1 - down, 2 - left, 3 - up
	int iteration = 1;
	int count_per_iteration = n;
	
	// start from the "previous" position. Since we go "right" from the first row and col, that's [0, -1]
	int row = 0;
	int col = -1;
	
	while ( count_per_iteration > 0) 
	{
		// cout << "DIR: " << dir << " IT: " << iteration << " COUNT/IT: " << count_per_iteration << " ROW: " << row << " COL: " << col<< endl;
		
		// read the full count for the current iteration
		for( int i = 0; i < count_per_iteration; ++i) 
		{
			// increment the row/col based on the current direction
			if ( dir == 0) {
				++col;
			} else if ( dir == 1) {
				++row;
			} else if ( dir == 2) {
				--col;
			}  else if ( dir == 3) {
				--row;
			}
			
			// read the current position
			*spiral++ = matrix[ row*n+col];
		}
		
		// change direction: RIGHT -> DOWN -> LEFT -> UP -> RIGHT ....
		dir = (dir + 1) % 4;
		
		// the count per iterations decreases by 1 after every 2 iterations
		if ( iteration == 1) {
			iteration = 2;
			--count_per_iteration;
		} else {
			--iteration;
		}
	}
		
}