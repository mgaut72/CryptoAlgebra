---
layout: post
title: Shift Cipher
category: Classical-Cryptosystems
tags: [encryption, decryption]
---

Time for our first cipher, the Shift Cipher!

## The basics

The idea behind the shift cipher is that we adjust our previous mapping:
$$
\begin{array}{c c c c}
 a & b & c & \cdots & x & y & z \\\\
 \downarrow & \downarrow & \downarrow & \cdots & \downarrow & \downarrow & \downarrow \\\\
 0 & 1 & 2 & \cdots & 23 & 24 & 25 \\\\
 \end{array}
$$
by adding some number (called the key), modulo 26.

Lets take the example where our key is 2.
$$
\begin{array}{c c c c c c c}
 a & b & c & \cdots & x & y & z \\\\
 \downarrow & \downarrow & \downarrow & \cdots & \downarrow & \downarrow & \downarrow \\\\
 2 & 3 & 4 & \cdots & 25 & 0 & 1 \\\\
 \end{array}
$$

## Encryption

Abstracting the pattern away from out previous example, we can make the
following encryption function:
$$
E(x) = (x + k) \mod 26
$$

Generally speaking, you want $0 \leq k \leq 25$, but really since we are modding
by 26, it doesn't matter.  Any $0 > k_1 > 25$ has a corresponding
$0 \leq k \leq 25$


Let us write a function to shift a single letter by a given key, resulting
in an encrypted letter.
{% highlight haskell %}
-- file : CryptoTools.hs

shift :: Int -> Int -> Int
shift k x = (x + k) `mod` 26
{% endhighlight %}

Now we have a simple function that shifts individual characters.
Also recall that we have `charToIdx` and `idxToChar` from the
"Establishing Conventions" post.

With these tools we can create our final encryption function:
{% highlight haskell %}
-- file : shift.hs
import CryptoTools

shift_encrypt :: Int -> String -> String
shift_encrypt k cs = map (idxToChar . shift k . charToIdx) (clean cs)
{% endhighlight %}

### Testing shift_encrypt
{% highlight haskell %}
ghci> shift_encrypt 2 ['a'..'z']
"CDEFGHIJKLMNOPQRSTUVWXYZAB"
{% endhighlight %}

Just like the mapping given at the begining of this post!

## Decryption

So what happens if we are given the ciphertext `"ZHGLGLW"`, and know that the
key is 3? Well, we need a corresponding `shift_decrypt`.

Mathematically speaking the decryption function must be defined such that
the composition of the two is the identity function.

That is: `(shift_decrypt k . shift_encrypt k)` is the same as `id`

Consider
$$
E^{-1}(x) = (x - k) \mod 26
$$

With the same stipulations as our encryption function.

Lets test whether or not our function composition is in fact the identity
function:

$$
E^{-1}(E(x))
\\\\ = E^{-1}((x + k) \mod 26)
\\\\ = (((x + k) \mod 26) - k) \mod 26
\\\\ = x \mod 26
\\\\ = x,  \text{    since } x \in \mathbb{Z}_{26}
$$

Now we can write out the `shift_decrypt` function using $ E^{-1} $
{% highlight haskell %}
shift_decrypt' :: Int -> String -> String
shift_decrypt' k cs = map (idxToChar . shift (-k) . charToIdx) (clean cs)
{% endhighlight %}

Or we can make the clever observation that `shift_decrypt` is very simply
related to `shift_encrypt`
{% highlight haskell %}
-- file : Shift.hs

import CryptoTools

shift_decrypt :: Int -> String -> String
shift_decrypt k cs = shift_encrypt (-k) cs
{% endhighlight %}

### Testing shift_decrypt

So does it work?

Lets check that ciphertext given at the begining of this section:
{% highlight haskell %}
ghci> shift_decrypt 3 "ZHGLGLW"
"wedidit"
{% endhighlight %}

## Thoughts

I hope this first cipher wasn't too slow.  We are, after all, still on
cryptosystems that are hundreds or thousands of years old.  The pace will pick
up, and this blog will increase in computational and mathematical difficulty,
but hopefully remains (or becomes at some point) understandable.
