def encode(word):
    code = 0
    for i in range(len(word)):
        code += (ord(word[-(i + 1)]) - ord('a')) * 26 ** i
    return code


def decode(x, length):
    digits = []
    word = ''
    for i in range(length):
        digits.append(x % 26)
        x = x // 26
    while(digits):
        word += chr(ord('a') + digits.pop())
    return word
