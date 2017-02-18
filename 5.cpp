/*Player1 (computer) picks a number between [0, 1000]. Player2 (user) has to guess this number.
For each tip player1 says if the secret number is bigger or smaller. (divide et impera)*/

# include <iostream>
# include <time.h> // time function
# include <cstdlib> // random function
using namespace std;

int x; // secret number

int sim(int b, int j)
{
    int tip;

    cout << "Guess the number in [" << b << ", " << j  << "]" << endl;
    cout << "Tip = ";
    cin >> tip;
    cout << endl;

    if(tip < b or tip > j)
    {
        cout << "Watch the interval!" << endl;
        sim(b, j);
    }
    else
        if(tip > x)
        {
            cout << "The secret number is SMALLER" << endl;
            sim(b, tip-1);
        }
        else
            if(tip < x)
                {
                    cout << "The secret number is BIGGER" << endl;
                    sim(tip+1, j);
                }
            else
                {
                    cout << tip << " was the SECRET number!";
                    return 0;
                }
}

int main()
{
    time_t t;
    srand(time(&t)); // declaration for random function

    cout << "The computer picked a number" << endl << "x = ?" << endl;
    x = (rand() % 1000);
    //cout << x << endl;

    cout << endl << "Your tips:" << endl<< endl;
    sim(0, 1000);
}
