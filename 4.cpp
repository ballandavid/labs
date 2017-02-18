/*Player1 (user) picks a number between [0, 1000]. Player2 (computer) has to guess this number.
For each tip player1 says if the secret number is bigger or smaller. (divide et impera)*/

# include <iostream>
# include <time.h> // time function
# include <cstdlib> // random function
using namespace std;

int x; // secret number

int sim(int b, int j)
{
    int tipp = (rand() % (j-b) + b); // computer guesses between [b, j]
    cout << tipp << " ";

    //if(b > j)
    //    return -1;
    //else
   //     {
            if(x < tipp)
                sim(b, tipp-1);
            else
            {
                if(tipp < x)
                    sim(tipp+1, j);
                else
                    return tipp;
            }
      //  }
}

int main()
{
    time_t t;
    srand(time(&t)); // declaration for random function

    cout << "Type in secret number [0,1000]" << endl;
    cin >> x;

    sim(0, 1001);

    /*for(int i = 1; i <= 20; i++)
    {
        int b = 5, j = 10;
        int tipp = (rand() % j + b); // [b, b+j]
        cout << tipp << " ";
    }*/

}
