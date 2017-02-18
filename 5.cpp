/*Player1 (computer) picks a number between [0, 1000]. Player2 (user) has to guess this number.
 For each tip player1 says if the secret number is bigger or smaller. (divide et impera)*/

# include <iostream>
# include <time.h> // time function
# include <cstdlib> // random function
using namespace std;

int sim(int secret, int b, int j) {
	int tip = 0;

	cout << "Guess the number in [" << b << ", " << j << "]" << endl;
	cout << "Tip = ";
	cin >> tip;
	cout << endl;

	if (tip < b || tip > j) {
		cout << "Your guess is not in the expected interval!" << endl;
		sim( secret, b, j);
	} else if (tip > secret) {
		cout << "The secret number is SMALLER" << endl;
		sim(secret,b, tip - 1);
	} else if (tip < secret) {
		cout << "The secret number is BIGGER" << endl;
		sim(secret,tip + 1, j);
	}

	cout << tip << " was the SECRET number!";

	return 0;
}

int main() {
	time_t t;
	srand(time(&t)); // declaration for random function

	cout << "The computer picked a number" << endl << "x = ?" << endl;
	int secret = rand() % 1000;

	cout << endl << "Your guess: " << endl << endl;
	sim( secret, 0, 1000);
}
