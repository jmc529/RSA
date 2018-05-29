local rsa = require("rsaFunctions")
math.randomseed(os.time())
math.random() math.random() math.random()

local RSA = {}

local function generatePrimes(bitLen)
	assert(bitLen<32, "Maximum bit length for lua's integers must be below 32, a safe number would be 16.")
	n = math.floor(bitLen*math.log10(2))
	possiblePrime = 0
	repeat
		possiblePrime = math.random(10^(n-1), 10^n)
	until rsa.isProbablyPrime(possiblePrime, 50)
	return possiblePrime
end

function RSA.generateKeys(bitLen)
	p = generatePrimes(bitLen)
	q = 0
	repeat 
		q = generatePrimes(bitLen)
	until p ~= q
	n = p*q
	totient  = (p-1)*(q-1)
	e = 0

	smallE = {3, 5, 7, 11, 13, 17, 23, 29, 31}
	for i=1, #smallE do
		if rsa.gcd(totient, smallE[i]) == 1 then
			e = smallE[i]
			break
		end
	end
	assert(e~=0, "e was never properly assigned.")

	gcd,x,y = rsa.egcd(e, totient)
	d = x
	if x<0 then
		d = totient+x
	end

	return e, n, d
end

function RSA.encyrpt(message, e, n)
	return rsa.fastModExp(message, e, n)
end

function RSA.decrypt(crypt, d, n)
	return rsa.fastModExp(crypt, d, n)
end

return RSA
