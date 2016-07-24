def comb(n, m):
    return product(range(n - m + 1, n+1)) / product(range(1, m+1))

def factorial(n):
    return product(range(1, n+1))


def factors(n): #return dictionary of primes to their powers
    factors = {}
    while n > 1:
        prime = least_prime_factor(n)
        if factors.get(prime) == None:
            factors[prime] = 1
        else:
            factors[prime] += 1
        n /= prime
    return factors

def gcd(a,b):
    if a < b:
        return gcd(b,a)
    if a % b == 0:
        return b
    return gcd(b, a-a/b*b)

def isAbundant(n):
    return sumProperDivisors(n) > n

def isPalindrome(s):
    for i in range(0, len(s)/2):
        if s[i] != s[len(s) - i - 1]:
            return False
    return True

def isPrime(n):
    if n == 2:
        return True;
    if n < 2 or n%2 == 0:
        return False
    f = 3
    while f*f <= n:
        if n % f == 0:
            return False
        f += 2
    return True

def leastPrimeFactor(n):
    p = 2
    while p*p <= n:
        if n % p == 0:
            return p
        else:
            if p == 2:
                p = 3
            else:
                p += 2
    return n

def numDivisors(n):
    return reduce(lambda x, y: x*(y+1), factors(n).values(), 1)

def maxPrimeFactor(n):
    p = 2
    while p*p <= n:
        if n % p == 0:
            n /= p
        else:
            if p == 2:
                p = 3
            else:
                p += 2
    return n

def product(numList):
    return reduce(lambda x, y: x*y, numList, 1)


def summation(numbers):
    return reduce(lambda x, y: x+y, numbers)

def sumProperDivisors(n):
    answer = 1
    for prime, power in factors(n).iteritems():
        answer *= summation([prime**k for k in range(0,power + 1)])
    return answer - n
