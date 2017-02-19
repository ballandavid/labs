/*Player1 (computer) picks a number between [0, 1000]. Player2 (user) has to guess this number.
 For each tip player1 says if the secret number is bigger or smaller. (divide et impera)*/

# include <iostream>
# include <time.h> // time function
# include <cstdlib> // random function
using namespace std;

void sim_r(int secret, int b, int j) {
	int tip = 0;

	cout << "Guess the number in [" << b << ", " << j << "]: ";
	cin >> tip;
	cout << endl;

	if (tip < b || tip > j) {
		cout << "Your guess is not in the expected interval!" << endl;
	} else if (tip > secret) {
		cout << "The secret number is SMALLER" << endl;
		sim_r(secret, b, tip - 1);
	} else if (tip < secret) {
		cout << "The secret number is BIGGER" << endl;
		sim_r(secret, tip + 1, j);
	} else {
		cout << tip << " was the SECRET number!";
	}
}

void sim(int secret, int b, int j) {
	int tip = -1;

	while (tip != secret) {
		cout << "Guess the number in [" << b << ", " << j << "]: ";
		cin >> tip;
		cout << endl;

		if (tip < b || tip > j) {
			cout << "Your guess is not in the expected interval!" << endl;
		} else if (tip > secret) {
			cout << "The secret number is SMALLER" << endl;
			j = tip - 1;
		} else if (tip < secret) {
			cout << "The secret number is BIGGER" << endl;
			b = tip + 1;
		}
	}

	cout << tip << " was the SECRET number!";
}

int main(int argc, char** argv) {
	time_t t;
	srand(time(&t)); // seed the random number generator

	cout << "The computer picked a number" << endl << "x = ?" << endl;
	int secret = rand() % 1000;

	sim(secret, 0, 1000);

	return 0;
}
