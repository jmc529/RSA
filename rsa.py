import RSAFunctions
import secrets


def generatePrime(bitlen):
    possiblePrime = secrets.randbits(bitlen)
    while not RSAFunctions.isProbablyPrime(possiblePrime, 100):
        possiblePrime = secrets.randbits(bitlen)
    return possiblePrime


def generateKeys(bitlen):
    p, q = generatePrime(bitlen), generatePrime(bitlen)
    while p == q:
        q = generatePrime(bitlen)
    n = p*q
    totient = (p-1)*(q-1)
    e = 65537
    gcd, x, y = RSAFunctions.egcd(e, totient)
    d = x
    if x < 0:
        d = totient+x
    return p, q, d


def encrypt(message, e, n):
    return RSAFunctions.fastModExp(message, e, n)


def decrypt(crypt, d, n):
    return RSAFunctions.fastModExp(crypt, d, n)


print(generateKeys(500))
