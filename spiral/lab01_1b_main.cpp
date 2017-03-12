#include "lab01_1b.h"

int main( int argc, char** argv)
{
	int* matrix = NULL;
	int* p = NULL;
	int* output = NULL;
	int n = 0;
	
	ifstream f("input_lab01_1b.txt");
	int x = 0;
	while ( !f.eof()) {
		f >> x;
		++n;
	}

	int matrix_len = n;
	n = sqrt( n);
	
	// alocate inout and output
	matrix = new int[matrix_len];
	output = new int[matrix_len];

	cout << "Matrix length:" << matrix_len << " row/col count: " << n << endl;

	// rewind to start of file
	f.clear();                 // clear fail and eof bits
	f.seekg(0, std::ios::beg); // back to the start!

	p = matrix;
	for (int i = 0; i < matrix_len; ++i)
	{
		f >> *p++;
	}
	
	f.close();

	SpiralSorrend( matrix, n, output);
	
	p = output;
	for (int i = 0; i < matrix_len; ++i)
	{
		cout << *p++ << " ";
	}
		
	return 0;
}