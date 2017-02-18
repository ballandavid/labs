/*Player1 (user) picks a number between [0, 1000]. Player2 (computer) has to guess this number.
 For each tip player1 says if the secret number is bigger or smaller. (divide et impera)*/

# include <iostream>
# include <time.h> // time function
# include <cstdlib> // random function
using namespace std;

int sim(int secret, int b, int j) {
	int tip = (rand() % (j - b) + b); // computer guesses between [b, j]
	cout << tip << " ";

	if (secret < tip) {
		sim( secret, b, tip);
	} else if (secret > tip) {
		sim(secret, tip + 1, j);
	}

	// this is the number, game over
	cout << "You win" << endl;
	return tip;
}

int main() {
	time_t t;
	srand(time(&t)); // declaration for random function

	int secret = -1;

	// need to do input validation that secret is between 0 and 1000
	while( secret < 0 || secret > 1000) {
		cout << "Type in secret number [0,1000]" << endl;
		cin >> secret;
	}

	sim(secret, 0, 1001);
}
