import secrets
import random
import math


# decompose n-1 as (2^s)*d
def decompose(negative_one):
    exponent, remainder = 0, negative_one
    while (remainder % 2) == 0:
        exponent = exponent+1
        remainder = remainder//2

    return exponent, remainder


def isNotWitness(n, possible_witness, exponent, remainder):
    witness = fastModExp(possible_witness, remainder, n)

    if (witness == 1) or (witness == n - 1):
        return False

    for _ in range(exponent-1):
        witness = fastModExp(witness, 2, n)
        if witness == (n - 1):
            return False
    return True


def egcd(a, b):
    x, y, u, v, q, r, m, n = 0, 1, 1, 0, 0, 0, 0, 0
    while a != 0:
        q, r = b // a, b % a
        m, n = x - (u * q), y - (v * q)
        b, a, x, y, u, v = a, r, u, v, m, n
    return b, x, y


# Miller-Rabin
def isProbablyPrime(n, accuracy):
    if n <= 3:
        return n == 2 or n == 3
    if (n % 2) == 0:
        return False

    exponent, remainder = decompose(n - 1)

    # checks if it is composite
    for i in range(accuracy):
        witness = random.randrange(2, n-2)
        if isNotWitness(n, witness, exponent, remainder):
            return False

    # probably prime
    return True


def fastModExp(num, exp, mod):
    exp = str(bin(int(exp)).replace("0b", ""))
    result = 1

    for ch in exp:
        result = (result*result) % mod
        if ch == "1":
            result = (result*num) % mod
    return result
