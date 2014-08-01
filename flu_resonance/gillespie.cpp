#include <iostream>
#include <random>
#include <chrono>
#include <math.h>

using namespace std;

const double pi = M_PI;
const int seed = chrono::system_clock::now().time_since_epoch().count();
default_random_engine rng(seed);
uniform_real_distribution<double> runif(0,1);

struct Par {
    double b0, b1, b2, l, d;
    int n;
};

double beta(double t, const Par& p) {
    return p.b0 * (1 + p.b1 * cos(p.b2*2*pi*t) );
}

double endemic_S(const Par &p, double beta) { return p.n/(beta*p.d); }
double endemic_I(const Par &p, double beta) { return (p.n- (p.n/(beta*p.d)))/(1+p.l/p.d); }


double next_event(double &t, int &s, int &i, const Par &p) {
    const double beta_t = beta(t, p);
    const double StoI = beta_t*i*s/p.n;
    const double ItoR = i/p.d;
    const double RtoS = (p.n-s-i)/p.l;
    const double totalRate = StoI + ItoR + RtoS;
    exponential_distribution<double> rexp(totalRate);
    const double event_time = rexp(rng);
    double r = runif(rng);
    if (r < StoI/totalRate) {                 // StoI
        s = s - 1;
        i = i + 1;
    } else if (r < (StoI + ItoR)/totalRate) { // ItoR
        i = i - 1;
    } else {                                  // RtoS
        s = s + 1;
    }
    t = t + event_time;
    return beta_t;
}

int main() {
    Par p;
    p.b0 = 500;
    p.b1 = 0.04;
    p.b2 = 1.0;
    p.n  = 500000;
    p.l  = 4;
    p.d  = 0.02;

    int i = endemic_I(p, p.b0) + 1;
    int s = endemic_S(p, p.b0) - 1;
    double t = 0.0;
    //cout << "s, i: " << s << ", " << i << endl;

    const double print_step = 0.01;
    double last_print = 10;
    double beta;
    while(t < 20 and i > 0) {
        beta = next_event(t, s, i, p);
        if (t > last_print) {
            cout << t << " " << i << " " << endemic_I(p,beta) << endl;
            last_print += print_step;
        }
    }
}
