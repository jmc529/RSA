local rsaFunctions = {}

math.randomseed(os.time())
math.random() math.random() math.random()

--decompose n-1 as (2^s)*d
local function decompose(negOne)
  local exponent, remainder = 0, negOne
  while (remainder%2) == 0 do 
    exponent = exponent+1
    remainder = remainder/2
  end
  assert((2^exponent)*remainder == negOne and ((remainder%2) == 1), "Error setting up s and d value")
  return exponent, remainder
end

local function isNotWitness(n, possibleWitness, exponent, remainder)
  local witness = rsaFunctions.fastModExp(possibleWitness, remainder, n)
  
  if (witness == 1) or (witness == n-1) then
    return false
  end

  for _=0, exponent-1 do
    witness = rsaFunctions.fastModExp(witness, 2, n)
    if witness == (n-1) then
      return false
    end
  end

  return true
end

--using miller-rabin primality testing
--n the integer to be tested, k the accuracy of the test
function rsaFunctions.isProbablyPrime(n, accuracy)
  if n <= 3 then
    return n == 2 or n == 3
  end
  if (n%2) == 0 then
    return false
  end
  
  local exponent, remainder, witness = decompose(n-1)

  --checks if it is composite
  for i=0, accuracy do
    witness = math.random(2, n - 2)
    if isNotWitness(n, witness, exponent, remainder) then
      return false
    end
  end

  --probably prime
  return true
end

function rsaFunctions.toBits(num)
  local t={}
  --math.frexp(n) -> m, e  :  n = m2^e; 0.5 <= m < 1
  --so this sets i to the total amount of binary digits w/o padding
  for i=select(2,math.frexp(num)),1,-1 do
      rest=math.fmod(num,2)
      t[i]=rest
      num=math.floor((num-rest)/2)
  end
  return t
end

--left to right 
function rsaFunctions.fastModExp(num, expBits, mod)
  if type(expBits) == "number" then
    expBits = rsaFunctions.toBits(expBits)
  end

  local result = 1
  for i=1, #expBits do
    result=(result*result)%mod
    if expBits[i]==1 then
      result=(result*num)%mod
    end
  end
  return result 
end

--best practice: a>b
function rsaFunctions.gcd(a, b)
  while a%b ~= 0 do
    a, b = b, a%b
  end
  return b
end

--best practice: b>a
function rsaFunctions.egcd(a, b)
  local x,y, u,v, q,r, m,n = 0,1, 1,0
  while a~=0 do 
    q,r = math.floor(b/a), b%a
    m,n = x-(u*q), y-(v*q)
    b,a, x,y, u,v = a,r, u,v, m,n
  end
  return b, x, y
end

return rsaFunctions