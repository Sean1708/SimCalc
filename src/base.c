#include <base.h>

long double bintold(const char* restrict nptr) {
    long double result = 0;

    const int length = strlen(nptr);
    const int end = length - 1;
    for (int i = 0; i < length; i++) {
        char c = nptr[end - i];

        /* only valid characters are '1', '0' or a 'b' as the second character
         * only. if '0' or valid 'b' then nothing needs to be done */
        if (c == '1') {
            result += pow(2, i);
        } else if (!((c == 'b' && (end - i) == 1) || c == '0')) {
            return nan(NULL);
        }
    }

    return result;
}

long double octtold(const char* restrict nptr) {
    long double result = 0;

    const int length = strlen(nptr);
    const int end = length - 1;
    /* bear in mind that this adds the initial zero if present but I can't think
     * of a situation in which that would be an issue */
    for (int i = 0; i < length; i++) {
        /* current digit */
        int d = nptr[end - i] - '0';

        /* 0-7 are the only valid octal characters */
        if (d >= 0 && d <= 7) {
            result += d * pow(8, i);
        } else {
            return nan(NULL);
        }
    }

    return result;
}

long double hextold(const char* restrict nptr) {
    long double result = 0;

    const int length = strlen(nptr);
    const int end = length -1;
    for (int i = 0; i < length; i++) {
        char c = nptr[end - i];
        int d = 0;

        /* allow optional 'x' in second position */
        if (c == 'x' && (end - i) == 1) continue;

        if (c >= '0' && c <= '9') {
            d = c - '0';
        } else if (c >= 'A' && c <= 'F') {
            d = 10 + c - 'A';
        } else if (c >= 'a' && c <= 'f') {
            d = 10 + c - 'a';
        } else {
            return nan(NULL);
        }

        result += d * pow(16, i);
    }

    return result;
}
