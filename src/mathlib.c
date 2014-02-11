/**
 * Some useful functions often required by calculators.
 */
#include <math.h>
#include <extend.h>

SC_VAR(eu, M_E)

SC_VAR(pi, M_PI)

SC_FUNC(ceil, num) {
	return ceill(num);
}

SC_FUNC(floor, num) {
	return floorl(num);
}

SC_FUNC(trunc, num) {
	return truncl(num);
}

SC_FUNC(round, num) {
	return roundl(num);
}

SC_FUNC(sqrt, num) {
    return sqrtl(num);
}

SC_FUNC(exp, num) {
    return expl(num);
}

SC_FUNC(ln, num) {
    return logl(num);
}

SC_FUNC(log, num) {
    return log10l(num);
}

SC_FUNC(cos, num) {
    return cosl(num);
}

SC_FUNC(sin, num) {
    return sinl(num);
}

SC_FUNC(tan, num) {
    return tanl(num);
}

SC_FUNC(cosh, num) {
    return coshl(num);
}

SC_FUNC(sinh, num) {
    return sinhl(num);
}

SC_FUNC(tanh, num) {
    return tanhl(num);
}

SC_FUNC(acos, num) {
    return acosl(num);
}

SC_FUNC(asin, num) {
    return asinl(num);
}

SC_FUNC(atan, num) {
    return atanl(num);
}

SC_FUNC(acosh, num) {
    return acoshl(num);
}

SC_FUNC(asinh, num) {
    return asinhl(num);
}

SC_FUNC(atanh, num) {
    return atanhl(num);
}
