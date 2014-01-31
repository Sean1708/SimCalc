/**
 * functions for converting binary, octal and hexadecimal strings to long
 * doubles since the functionality is missing from math.h
 *
 * since these functions were written specifically for use with SimCalc they
 * perform minimal error checking, though some checking is performed for
 * portability
 */
#ifndef __BASE_H__
#define __BASE_H__

#include <string.h>
#include <math.h>

long double bintold(const char* restrict nptr);
long double octtold(const char* restrict nptr);
long double hextold(const char* restrict nptr);

#endif /* __BASE_H__ */
