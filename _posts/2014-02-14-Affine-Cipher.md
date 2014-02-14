---
layout: post
title: Affine Cipher
category: Classical-Cryptosystems
tags: [encryption, decryption]
---

This time we are going to look at a
generalization of the [Shift Cipher]({% post_url 2014-01-21-Shift-Cipher %})
Called the Affine Cipher.

Fortunately for us, this will also give us the chance to take a look at some
of the algebraic properties of $ \mathbb{Z}_{26} $ as a ring.

## Encryption

The affine cipher is much like the shift cipher, in that we have a simple
linear equation to convert our characters.  However, this time we add the
option of a multiplicative constant.  Our encryption function is then:
$$
E(x) = (\\alpha x + \\beta) \\mod 26
$$

where $0 < \\alpha < 26$ and $0 \leq \\beta < 26$, with the necessity
that $gcd(\\alpha, 26) = 1$.
We will discuss the requirement on $\\alpha$ later on.

{% highlight haskell %}
-- file : Affine.hs
import CryptoTools

affine_encrypt :: Int -> Int -> String -> String
affine_encrypt a b cs = map (idxToChar. affine a b . charToIdx) (clean cs)
    where affine a b c = (a * c + b) `mod` 26
{% endhighlight %}

The Haskell code for the affine cipher is very much like the shift cipher.
We are simply applying an affine transform to each character in the
plaintext.

## Decryption

Let us invert our encryption function with some simple algebra. Since
we have clearly established that we are working in $ \mathbb{Z}_{26} $,
the " $ \\mod 26 $ " will be left off:

$$
y = \alpha x + \beta \\\\
(y - \beta) = \alpha x \\\\
x = \frac{1}{\alpha}(y - \beta)
$$

This is all well and good, but what is $ \frac{1}{\alpha} $?

If we were working in $\mathbb{Q}$, or some super-set of the rationals,
this would make perfect sense, but it so happens that we are working
in $ \mathbb{Z}_{26} $

So what we need is some $\alpha^{-1}$ such that $ \alpha \alpha^{-1} = 1$.

What if I told you that $\alpha$ has a multiplicative inverse
in $\mathbb{Z}_26$ if and only if $gcd(\alpha, 26) = 1$? Would you
believe me? I wouldn't belive me, so lets prove it!

### $\alpha$ has a multiplicative inverse in $\mathbb{Z}_n \Leftrightarrow gcd(a,n) = 1$

#### $\Rightarrow$

Suppose $\alpha$ has a multiplicative inverse in $\mathbb{Z}_n$, say $\alpha^{-1}$.

Then $\alpha \alpha^{-1} = 1$

Which means that $\alpha \alpha^{-1} \equiv 1 \mod n$.

So $\alpha \alpha^{-1} = nk$ for some $k \in \mathbb{Z}$.

Then $\alpha \alpha^{-1} - nk = 1$.

Suppose $g = gcd(\alpha, n)$.

Then $g$ divides $\alpha$ and $g$ divides $n$, so $g$ divides
$\alpha \alpha^{-1} - nk$, which implies that $g$ divides 1.

Clearly $1$ divides $g$.

Since $g$ divides 1, and 1 divides $g$, we have that $g = 1$.

That is, $gcd(\alpha, n) = 1$.


#### $\Leftarrow$

Suppose $gcd(\alpha, n) = 1$.

Then by the [Extended Euclidean Algorithm](http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm),
$\alpha x + n y = 1$ for some integers $x,y$

Then $\alpha x = 1 - ny$

So $\alpha x = 1 \mod n$

Then $x$ is the multiplicative inverse of $\alpha$ in $\mathbb{Z}_n$

That is, $x = \alpha^{-1}$.


### Rings Vs. Fields

Earlier I said that $\mathbb{Z}_{26}$ was
a <a href="http://en.wikipedia.org/wiki/Ring_(mathematics)#Definition">Ring</a>

All this means is that $\mathbb{Z}_{26}$ has an associated addition operator
and multiplication operator.  In this case, it is just our regular addition
and multiplication, mod 26.

Please take a look at the other properties that these operations must satisfy
in the
<a href="http://en.wikipedia.org/wiki/Ring_(mathematics)#Definition">Ring Wikipedia</a>

Note that in general, a ring does not have multiplicative inverses.  A field
on the other had, is a ring in which every element has multiplicative inverses
(and a few other properties).

Using the above proof, we can make the following observation:

Every element will have a multiplicative inverse in $\mathbb{Z}_p$, where
$p$ is prime.

This follows directly from the fact that $gcd(n, p) = 1 \forall n$, $p$ prime.

Just so you know, it turns out that $\mathbb{Z}_p$ is a field, but for now,
we only care that there are multiplicative inverses.

### Calculating Multiplicative Inverses

First, lets take a nieve approach.  For a given element of $\mathbb{Z}_{26}$,
we can multiply by something in `[1..25]` until the resulting answer is 1,
giving the multiplicative inverse.

{% highlight haskell %}
ghci> let invZ26 n = head [x | x <- [1..25], x * n `mod` 26 == 1]
ghci> invZ26 5
21
ghci> it * 5
105
ghci> it `mod` 26
1
ghci> inv26 2
*** Exception: Prelude.head: empty list
{% endhighlight %}

It looks like this inverse function works just fine, based on these few checks.
The `empty list` exception is to be expected, since $gcd(2,26) \neq 1$ we would
expect there to not be a multiplicaive inverse of 2.

### Extended Euclidean Algorithm

The [Extended Euclidean Algorithm](http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm)
is the accepted best way to determine the multiplicative inverse in an
"modular structures" such as $\mathbb{Z}_{26}$.

The Extended Euclidean Algorithm with inputs $a,b$ computes the
integers $x,y$ such that $ax + by = gcd(a,b)$.

We will define the function `inverse` that uses the Extended
Euclidean Algorithm to compute the multiplicative inverse in
an arbitrary base $q$

{% highlight haskell %}
--file : CryptoTools.hs

inverse q 1 = 1
inverse q p = (n * q + 1) `div` p
    where n = p - inverse p (q `mod` p)
{% endhighlight %}

### Finally an Inverse Function

Now that the algebra is out of the way, the inverse function
is really quite simple:

{% highlight haskell %}
--file Affine.hs

affine_decrypt :: Int -> Int -> String -> String
affine_decrypt a b cs = map (idxToChar . unaffine a b . charToIdx) (clean cs)
      where unaffine a b c = inverse 26 a * (c - b) `mod` 26
{% endhighlight %}


## Benefits of Extending the Shift Cipher

So how much better did we do by adding a multiplicative factor
to the Shift Cipher?

Well first, lets answer the question: How many unique
Shift Ciphers are there?

Well we can use any $k \in \{1,2,...,25\}$ as our encryption key
in the Shift Cipher, which is only 25 possible keys. That can
be brute forces quite easily, even by hand if it was important.

Now, how many unique Affine Ciphers are there?

Well there are two parameters in the equation, $\alpha$ and $\beta$.
We have the requirement that $gcd(\alpha, 26) = 1$.

So we need to know how many numbers are relatively prime to 26.

The mathy way of asking this question would be, "What is $\phi(26)$?" where
$\phi$ is the Euler-Phi or Euler-Totient function.

Formally:

$$\phi(n) = \vert \\{ x : gcd(n,x) = 1 \\} \vert$$

We can nievely program $\phi$ exactly as we have defined it above:

{% highlight haskell %}
-- file : CryptoTools.hs

phi' :: Int -> Int
phi' x = length [ a | a <- [1..(x-1)], gcd a x == 1 ]
{% endhighlight %}

Now we can say that there are $\phi(26) * 26 = 12 * 26 = 312$ possibile Affine
Ciphers.

This would definitely make the Affine Cipher unpleasant to brute
force by hand, but beyond that, a computer could brute force it,
or a frequency analysis can still be done.
