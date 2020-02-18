import decoder


def egcd(a, b):
    x, y, u, v, q, r, m, n = 0, 1, 1, 0, 0, 0, 0, 0
    while a != 0:
        q, r = b // a, b % a
        m, n = x - (u * q), y - (v * q)
        b, a, x, y, u, v = a, r, u, v, m, n
    return b, x, y


def readFile():
    rsaFile = open("StinsonRSA.txt", "r")
    encodedWords = []
    for line in rsaFile:
        encodedWords.extend(line.split())
    return encodedWords


def fastModExp(num, exp, mod):
    exp = str(bin(exp).replace("0b", ""))
    result = 1

    for ch in exp:
        result = (result*result) % mod
        if ch == "1":
            result = (result*num) % mod
    return result


def solveFour():
    P = 173
    Q = 181
    N = P * Q
    totient = (P-1) * (Q-1)
    encodedWords = readFile()
    gcd, X, Y = egcd(4913, totient)
    for word in encodedWords:
        decrypted = fastModExp(int(word), X, N)
        print(decoder.decode(decrypted, 3))

print(fastModExp(10, 45, 91))

